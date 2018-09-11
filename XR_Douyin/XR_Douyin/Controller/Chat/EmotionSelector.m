//
//  EmotionSelector.m
//  XR_Douyin
//
//  Created by 谢汝 on 2018/9/8.
//  Copyright © 2018年 谢汝. All rights reserved.
//

#import "EmotionSelector.h"
#import "Constants.h"
NSInteger const EmotionSelectorHeight = 220;

@interface EmotionSelector ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, assign) CGFloat itemHeight;
@property (nonatomic, assign) CGFloat itemWidth;


@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, strong) NSDictionary *emotionDic;

@property (nonatomic, assign) NSInteger currentIndex;


@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *send;

@end
@implementation EmotionSelector

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}
- (void)addTextViewObserver:(UITextView *)textView {
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, EmotionSelectorHeight)];
    if (self) {
        self.backgroundColor = ColorSmoke;
        self.clipsToBounds = NO;
        
        NSDictionary *data = [NSString readJson2DicWithFileName:@"emotion"];
        _emotionDic = [data objectForKey:@"dict"];
        _data = [data objectForKey:@"array"];
        
        _itemWidth = SCREEN_WIDTH / 7.0;
        _itemHeight = 50;
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.itemSize = CGSizeMake(_itemWidth, _itemHeight);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _itemHeight * 3) collectionViewLayout:layout];
        _collectionView.clipsToBounds = NO;
        _collectionView.backgroundColor = ColorClear;
        _collectionView.alwaysBounceHorizontal = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        [_collectionView registerClass:EmotionCell.class forCellWithReuseIdentifier:NSStringFromClass(EmotionCell.class)];

        [self addSubview:_collectionView];
        
    }
    
    return self;
}

#pragma mark - UICollectionViewDataSource Delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return _data.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 21;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    EmotionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(EmotionCell.class) forIndexPath:indexPath];
    NSArray *array = _data[indexPath.section];
    if (indexPath.section < _data.count -1) { //最后一屏幕要特殊处理
        if (indexPath.row < array.count) {
            [cell initData:array[indexPath.row]];
        }
    }else {
        if (indexPath.row % 3 != 2) {
            [cell initData:array[indexPath.row - indexPath.row/3]];
        }
    }
    
    if (indexPath.row == 20) {
        [cell setDelete];
    }
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_delegate) {
        if (indexPath.row == 20) {
            [_delegate onDelete];
        }else {
            EmotionCell *cell = (EmotionCell *)[collectionView cellForItemAtIndexPath:indexPath];
            if (cell.emotionKey) {
                [_delegate onSelect:cell.emotionKey];
            }
        }
        
    }
}


@end



@implementation EmotionCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _emotion = [[UIImageView alloc]initWithFrame:self.bounds];
        _emotion.contentMode = UIViewContentModeCenter;
        [self.contentView addSubview:_emotion];
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    _emotion.image = nil;
}

- (void)setDelete {
    _emotion.image = [UIImage imageNamed:@"iconLaststep"];
    _emotionKey = nil;
}

- (void)initData:(NSString *)key {
    _emotionKey = key;
    
    NSString *emoIconsPath = [[NSBundle mainBundle]pathForResource:@"Emoticons" ofType:@"bundle"];
    NSString *arrowPath = [emoIconsPath stringByAppendingPathComponent:key];
    _emotion.image = [UIImage imageWithContentsOfFile:arrowPath];
}

@end

