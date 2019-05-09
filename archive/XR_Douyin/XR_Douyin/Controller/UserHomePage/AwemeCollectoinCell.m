//
//  AwemeCollectoinCell.m
//  XR_Douyin
//
//  Created by 谢汝 on 2018/9/11.
//  Copyright © 2018年 谢汝. All rights reserved.
//

#import "AwemeCollectoinCell.h"
#import "Constants.h"
#import <SDWebImage/UIImageView+WebCache.h>
@implementation AwemeCollectoinCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.clipsToBounds = YES;
        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = ColorThemeGray;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_imageView];
        
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.colors = @[(__bridge id)ColorClear.CGColor, (__bridge id)ColorBlackAlpha20.CGColor, (__bridge id)ColorBlackAlpha60.CGColor];
        gradientLayer.locations = @[@0.3, @0.6, @1.0];
        gradientLayer.startPoint = CGPointMake(0.0f, 0.0f);
        gradientLayer.endPoint = CGPointMake(0.0f, 1.0f);
        gradientLayer.frame = CGRectMake(0, self.frame.size.height - 100, self.frame.size.width, 100);
        [_imageView.layer addSublayer:gradientLayer];
        
        _favoriteNum = [[UIButton alloc] init];
        [_favoriteNum setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [_favoriteNum setTitleEdgeInsets:UIEdgeInsetsMake(0, 2, 0, 0)];
        [_favoriteNum setTitle:@"0" forState:UIControlStateNormal];
        [_favoriteNum setTitleColor:ColorWhite forState:UIControlStateNormal];
        _favoriteNum.titleLabel.font = SmallFont;
        [_favoriteNum setImage:[UIImage imageNamed:@"icon_home_likenum"] forState:UIControlStateNormal];
        [_favoriteNum setImageEdgeInsets:UIEdgeInsetsMake(0, -2, 0, 0)];
        [self addSubview:_favoriteNum];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _imageView.frame = self.bounds;
    _favoriteNum.frame = CGRectMake(10, self.bounds.size.height - 20, self.bounds.size.width - 20, 12);
}

- (void)initData:(Aweme *)aweme {
    __weak __typeof(self) wself = self;
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:aweme.video.dynamic_cover.url_list.firstObject] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
    }];
//    [self.favoriteNum setTitle:[NSString formatCount:aweme.statistics.digg_count] forState:UIControlStateNormal];
}

@end
