//
//  NSAttributedString+Extension.m
//  XR_Douyin
//
//  Created by 谢汝 on 2018/9/7.
//  Copyright © 2018年 谢汝. All rights reserved.
//

#import "NSAttributedString+Extension.h"

@implementation NSAttributedString (Extension)
- (CGSize)multiLineSize:(CGFloat)width {
    CGRect rect = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    return CGSizeMake(ceilf(rect.size.width), ceilf(rect.size.height));
}
@end
