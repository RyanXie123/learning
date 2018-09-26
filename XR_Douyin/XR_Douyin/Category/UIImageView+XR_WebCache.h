//
//  UIImageView+XR_WebCache.h
//  XR_Douyin
//
//  Created by 谢汝 on 2018/9/21.
//  Copyright © 2018年 谢汝. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^WebImageCompletedBlock)(UIImage *image, NSError *error);
typedef void(^WebImageProgressBlock)(CGFloat percent);


@interface UIImageView (XR_WebCache)


- (void)setImageWithUrl:(NSURL *)imageUrl;
- (void)setImageWithUrl:(NSURL *)imageUrl completedBlock:(WebImageCompletedBlock)completedBlock;
- (void)setImageWithUrl:(NSURL *)imageUrl progressBlcok:(WebImageProgressBlock)progressBlock completedBlock:(WebImageCompletedBlock)completedBlock;

@end


