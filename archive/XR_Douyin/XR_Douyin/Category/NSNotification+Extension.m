//
//  NSNotification+Extension.m
//  XR_Douyin
//
//  Created by 谢汝 on 2018/9/8.
//  Copyright © 2018年 谢汝. All rights reserved.
//

#import "NSNotification+Extension.h"

@implementation NSNotification (Extension)

- (CGFloat)keyboardHeight {
    NSDictionary *userInfo = [self userInfo];
    CGSize size = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue].size;
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    return UIInterfaceOrientationIsLandscape(orientation) ? size.width : size.height;
    
}


@end
