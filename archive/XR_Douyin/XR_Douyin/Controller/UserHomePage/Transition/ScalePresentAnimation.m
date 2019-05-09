//
//  ScalePresentAnimation.m
//  XR_Douyin
//
//  Created by 谢汝 on 2018/9/27.
//  Copyright © 2018 谢汝. All rights reserved.
//

#import "ScalePresentAnimation.h"
#import "UserHomePageController.h"
#import "AwemeListController.h"


@implementation ScalePresentAnimation
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.25f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    AwemeListController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
}



@end
