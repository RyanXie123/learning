//
//  UIImage+Extension.m
//  XR_Douyin
//
//  Created by 谢汝 on 2018/9/7.
//  Copyright © 2018年 谢汝. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)



- (UIImage *)drawCircleImage {
    CGFloat side = MIN(self.size.width, self.size.height);
    //    opaque—透明开关，如果图形完全不用透明，设置为YES以优化位图的存储。
   //    scale—–缩放因子 iPhone 4是2.0，其他是1.0。虽然这里可以用[UIScreen mainScreen].scale来获取，但实际上设为0后，系统就会自动设置正确的比例了。
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(side, side), NO, 0);
    //抗锯齿 默认开启
    CGContextSetShouldAntialias(UIGraphicsGetCurrentContext(), YES);
    
    CGContextAddPath(UIGraphicsGetCurrentContext(), [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, side, side)].CGPath);
    CGContextClip(UIGraphicsGetCurrentContext());
    
    CGFloat originX = -(self.size.width - side) / 2.f;
    CGFloat originY = -(self.size.height - side) / 2.f;
    [self drawInRect:CGRectMake(originX, originY, self.size.width, self.size.height)];
    
    CGContextDrawPath(UIGraphicsGetCurrentContext(), kCGPathFillStroke);
    
    UIImage *output = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return output;
    
}

@end
