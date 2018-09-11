//
//  RefreshControl.m
//  XR_Douyin
//
//  Created by 谢汝 on 2018/9/7.
//  Copyright © 2018年 谢汝. All rights reserved.
//

#import "RefreshControl.h"
#import <Masonry.h>

@implementation RefreshControl

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:CGRectMake(0, -50, SCREEN_WIDTH, 50)]) {
        _refreshingType = RefreshHeaderStateIdle;
        _indicatorView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon60LoadingMiddle"]];
        [self addSubview:_indicatorView];
    }
    return self;

}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.height.mas_equalTo(25);
    }];
    
    if (!_superView) {
        _superView = (UIScrollView *)[self superview];
        [_superView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    }

}




- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentOffset"]) {
        UIScrollView *superView = (UIScrollView *)[self superview];
        if (superView.isDragging && _refreshingType == RefreshHeaderStateIdle && superView.contentOffset.y < -80) {
            _refreshingType = RefreshHeaderStatePulling;
        }
        
        if (!superView.isDragging && _refreshingType == RefreshHeaderStatePulling && superView.contentOffset.y >= -50) {
            [self startRefresh];
            _onRefreshBlock();
        }
        
        
        
    }else {
        return [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)startRefresh {
    if (_refreshingType != RefreshHeaderStateRefreshing) {
        _refreshingType = RefreshHeaderStateRefreshing;
        UIScrollView *superView = (UIScrollView *)[self superview];
        UIEdgeInsets edgeInsets = superView.contentInset;
        edgeInsets.top += 50;
        superView.contentInset = edgeInsets;
        [self startAnim];
    
    }
}
- (void)endRefresh {
    if (_refreshingType != RefreshHeaderStateIdle) {
        _refreshingType = RefreshHeaderStateIdle;
        
        
        UIScrollView *superView = (UIScrollView *)[self superview];
        UIEdgeInsets edgeInsets = superView.contentInset;
        edgeInsets.top -= 50;
        superView.contentInset = edgeInsets;
        [self stopAnim];

    }
}
- (void)loadAll{
    _refreshingType = RefreshHeaderStateAll;
    [self setHidden:YES];
}



#pragma mark - animation
- (void)startAnim {
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI * 2.0];
    rotationAnimation.duration = 1.5;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = MAXFLOAT;
    
    [self.indicatorView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];

}
- (void)stopAnim {
    [self.indicatorView.layer removeAllAnimations];
}



- (void)dealloc {
    [_superView removeObserver:self forKeyPath:@"contentOffset"];
}

@end
