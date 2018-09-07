//
//  RefreshControl.h
//  XR_Douyin
//
//  Created by 谢汝 on 2018/9/7.
//  Copyright © 2018年 谢汝. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
//refreshing type enum
//typedef NS_ENUM(NSUInteger,RefreshingType) {
//    RefreshHeaderStateIdle          = 0,
//    RefreshHeaderStatePulling       = 1,
//    RefreshHeaderStateRefreshing    = 2,
//    RefreshHeaderStateAll           = 3
//};

typedef NS_ENUM(NSUInteger, RefreshingType) {
    RefreshHeaderStateIdle = 0,
    RefreshHeaderStatePulling = 1,
    RefreshHeaderStateRefreshing = 2,
    RefreshHeaderStateAll = 3
};

typedef void(^OnRefresh)(void);

@interface RefreshControl : UIControl

@property (nonatomic, weak) UIScrollView *superView;
@property (nonatomic, strong) UIImageView *indicatorView;
@property (nonatomic, copy) OnRefresh onRefreshBlock;
@property (nonatomic, assign) RefreshingType refreshingType;


- (void)startRefresh;
- (void)endRefresh;
- (void)loadAll;


@end
