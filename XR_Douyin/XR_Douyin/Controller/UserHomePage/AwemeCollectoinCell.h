//
//  AwemeCollectoinCell.h
//  XR_Douyin
//
//  Created by 谢汝 on 2018/9/11.
//  Copyright © 2018年 谢汝. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Aweme.h"
@interface AwemeCollectoinCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *favoriteNum;


- (void)initData:(Aweme *)aweme;
@end
