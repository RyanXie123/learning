//
//  LoadMoreControl.m
//  XR_Douyin
//
//  Created by 谢汝 on 2018/9/11.
//  Copyright © 2018年 谢汝. All rights reserved.
//

#import "LoadMoreControl.h"
#import "Constants.h"
#import <Masonry.h>

@interface LoadMoreControl ()
@property (nonatomic, assign) NSInteger  surplusCount;
@property (nonatomic, assign) CGRect originalFrame;
@end


@implementation LoadMoreControl
- (instancetype)init {
    return [self initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
}
- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame surplusCount:0];
}

- (instancetype)initWithFrame:(CGRect)frame surplusCount:(NSInteger)surplusCount {
    if (self = [super initWithFrame:frame]) {
        self.layer.zPosition = -1;
        _originalFrame = frame;
        _surplusCount = surplusCount;
        
        
//        self setLoadingType:<#(LoadingType)#>
        _indicatorView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon30WhiteSmall"]];
        [self addSubview:_indicatorView];
        
        _label = [UILabel new];
        _label.text = @"正在加载中";
        _label.textColor = ColorGray;
        _label.font = SmallFont;
        _label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_label];
        
        [self setLoadingType:LoadStateIdle];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (!_superView) {
        _superView = (UIScrollView *)[self superview];
        [_superView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
        UIEdgeInsets edgeInsets = _superView.contentInset;
        edgeInsets.bottom += 50;
        _superView.contentInset = edgeInsets;
    }
}



#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    __weak __typeof(self) wself = self;
    if ([keyPath isEqualToString:@"contentOffset"]) {
        if ([wself.superView isKindOfClass:[UICollectionView class]]) {
            UICollectionView *collectionView = (UICollectionView *)wself.superView;
            NSInteger lastSection = collectionView.numberOfSections - 1;
            if (lastSection > 0) {
                NSInteger lastRow = [collectionView numberOfItemsInSection:lastSection] - 1;
                if (lastRow > 0) {
                    if (collectionView.indexPathsForVisibleItems.count > 0) {
                        NSArray *indexPaths = [collectionView indexPathsForVisibleItems];
                        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"row" ascending:YES];
                        NSArray *sortedIndexPaths = [indexPaths sortedArrayUsingDescriptors:@[sort]];
                        NSIndexPath *indexPath = sortedIndexPaths.lastObject;
                        
                        if (indexPath.section == lastSection && indexPath.row >= (lastRow - wself.surplusCount)) {
                            if (wself.loadingType == LoadStateFailed || wself.loadingType == LoadStateIdle) {
                                if (wself.onLoad) {
                                    wself.onLoad();
                                    [wself startLoading];
                                }
                            }
                        }
                        
                        if (indexPath.section == lastSection && indexPath.row == lastRow) {
                            UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
                            self.frame = CGRectMake(0, CGRectGetMaxY(cell.frame), SCREEN_WIDTH, 50);
                            
                        }
                        
                    }
                    
                    
                    
                }
            }
            
            
        }
        
        if ([wself.superView isKindOfClass:[UITableView class]]) {
            UITableView *tableView = (UITableView *)self.superView;
            NSInteger lastSection = tableView.numberOfSections - 1;
            if (lastSection >= 0) {
                NSInteger lastRow = [tableView numberOfRowsInSection:lastSection] - 1;
                if (lastRow >= 0) {
                    NSIndexPath *visibleLastCellIndex = [tableView indexPathForCell:tableView.visibleCells.lastObject];
                    if (visibleLastCellIndex.section == lastSection && visibleLastCellIndex.row >= (lastRow - _surplusCount)) {
                        if (wself.loadingType == LoadStateFailed || wself.loadingType == LoadStateIdle) {
                            if (wself.onLoad) {
                                wself.onLoad();
                                [wself startLoading];
                            }
                        }
                        if (visibleLastCellIndex.section == lastSection || visibleLastCellIndex.row == lastRow) {
                            wself.frame = CGRectMake(0, CGRectGetMaxY(tableView.visibleCells.lastObject.frame), SCREEN_WIDTH, 50);
                            
                        }
                    }
                    
//                    NSIndexPath visibleLastCellIndex =
                }
            }
        }
        
        
        
        
    }else {
        return [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }

}



#pragma mark - Loading Action

- (void)reset {
    [self setLoadingType:LoadStateIdle];
    self.frame = _originalFrame;
}

- (void)startLoading {
    if (_loadingType != LoadStateLoading) {
        [self setLoadingType:LoadStateLoading];
    }
}

- (void)endLoading {
    if (_loadingType != LoadStateIdle) {
        [self setLoadingType:LoadStateIdle];
    }
}

- (void)loadingFailed {
    if (_loadingType != LoadStateFailed) {
        [self setLoadingType:LoadStateFailed];
    }
}


- (void)loadingAll {
    if (_loadingType != LoadStateAll) {
        [self setLoadingType:LoadStateAll];
    }
}

- (void)updateFrame {
    if([self.superView isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView *)self.superView;
        CGFloat y = tableView.contentSize.height > _originalFrame.origin.y ? tableView.contentSize.height : _originalFrame.origin.y;
        self.frame = CGRectMake(0, y, SCREEN_WIDTH, 50);
    }
    if([self.superView isKindOfClass:[UICollectionView class]]) {
        UICollectionView *collectionView = (UICollectionView *)self.superView;
        CGFloat y = collectionView.contentSize.height > _originalFrame.origin.y ? collectionView.contentSize.height : _originalFrame.origin.y;
        self.frame = CGRectMake(0, y, SCREEN_WIDTH, 50);
    }
}
#pragma mark - Setter/Getter


- (void)setLoadingType:(LoadingType)loadingType {
    _loadingType = loadingType;
    
    switch (loadingType) {
        case LoadStateIdle: {
            [self setHidden:YES];
            break;
        }
        case LoadStateLoading: {
            [self setHidden:NO];
            [_indicatorView setHidden:NO];
            [_label setText:@"内容加载中..."];
            [_label mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.centerX.equalTo(self).offset(20);
            }];
            [_indicatorView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.right.equalTo(self.label.mas_left).inset(5);
                make.width.height.mas_equalTo(15);
            }];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self startAnim];
            });
            break;
        }
        case LoadStateAll: {
            [self setHidden:NO];
            [_indicatorView setHidden:YES];
            [_label setText:@"没有更多了哦~"];
            [_label mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self);
            }];
            [self stopAnim];
            [self updateFrame];
            break;
        }
        case LoadStateFailed: {
            [self setHidden:NO];
            [_indicatorView setHidden:YES];
            [_label setText:@"加载更多"];
            [_label mas_updateConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(self);
            }];
            [self stopAnim];
            break;
            
            break;
        }
    }
    
}


- (void)setOnLoad:(onLoad)onLoad {
    _onLoad = onLoad;
}



#pragma mark - Animation

- (void)startAnim {
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.fromValue = @(0);
    rotationAnimation.toValue = @(M_PI * 2);
    rotationAnimation.duration = 1.5;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = MAXFLOAT;
    
    [self.indicatorView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
}
- (void)stopAnim {
    [self.indicatorView.layer removeAllAnimations];
}



@end
