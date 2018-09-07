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



- (void)startRefresh {
    
}
- (void)endRefresh {
    
}
- (void)loadAll{
    
}


@end
