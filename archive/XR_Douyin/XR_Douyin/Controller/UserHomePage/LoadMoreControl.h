//
//  LoadMoreControl.h
//  XR_Douyin
//
//  Created by 谢汝 on 2018/9/11.
//  Copyright © 2018年 谢汝. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LoadingType) {
    LoadStateIdle,
    LoadStateLoading,
    LoadStateAll,
    LoadStateFailed
};

typedef void(^onLoad)(void);

@interface LoadMoreControl : UIControl
@property (nonatomic, strong) UIScrollView *superView;
@property (nonatomic, assign) LoadingType loadingType;
@property (nonatomic, strong) UIImageView *indicatorView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, copy) onLoad onLoad;

-(instancetype)initWithFrame:(CGRect)frame surplusCount:(NSInteger)surplusCount;



- (void)setLoadingType:(LoadingType)loadingType;

- (void)setOnLoad:(onLoad)onLoad;

- (void)reset;

- (void)startLoading;

- (void)endLoading;

- (void)loadingFailed;

- (void)loadingAll;
@end
