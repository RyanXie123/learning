//
//  UIWindow+Extension.m
//  XR_Douyin
//
//  Created by 谢汝 on 2018/9/10.
//  Copyright © 2018年 谢汝. All rights reserved.
//

#import "UIWindow+Extension.h"
#import <objc/runtime.h>

static char tipsViewKey;
static char tapGesKey;

@implementation UIWindow (Extension)
+ (void)showTips:(NSString *)text {
    UIWindow *window = [[[UIApplication sharedApplication]delegate]window];
    UITextView *tipsView = objc_getAssociatedObject(self, &tipsViewKey);
    
    if (tipsView) {
        
    }
    
    
    //计算文字宽高
    CGFloat maxWidth = 200;
    CGFloat maxHeight = window.frame.size.height - 200;
    CGFloat commonInset = 10;
    
    UIFont *font = [UIFont systemFontOfSize:12];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:text];
    [string addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, string.length)];
    CGRect rect = [string boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin context:nil];
    CGSize size = CGSizeMake(ceilf(rect.size.width), ceilf(rect.size.height < maxHeight?rect.size.height:maxHeight));
    CGRect tipsFrame = CGRectMake(window.frame.size.width/2- (size.width + 2 * commonInset)/2, window.frame.size.height - (size.height + 2 * commonInset) - 100 , size.width + 2 * commonInset, size.height + 2 * commonInset);
    
    tipsView = [[UITextView alloc]initWithFrame:tipsFrame];
    
    tipsView.text = text;
    tipsView.font = font;
    tipsView.textColor = [UIColor whiteColor];
    tipsView.backgroundColor = [UIColor blackColor];
    
    tipsView.selectable = NO;
    tipsView.editable = NO;
    tipsView.scrollEnabled = NO;
    
    tipsView.textContainerInset = UIEdgeInsetsMake(commonInset, commonInset, commonInset, commonInset);
    tipsView.textContainer.lineFragmentPadding = 0;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handlerGuesture:)];
    [window addGestureRecognizer:tap];
    [window addSubview:tipsView];
    
    objc_setAssociatedObject(self, &tipsViewKey, tipsView, OBJC_ASSOCIATION_RETAIN);
    objc_setAssociatedObject(self, &tapGesKey, tap, OBJC_ASSOCIATION_RETAIN);
    
    [self performSelector:@selector(dismiss) withObject:nil afterDelay:2.0f];
    
}


+ (void)handlerGuesture:(UIGestureRecognizer *)sender {
    if(!sender || !sender.view)
        return;
    [self dismiss];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismiss) object: nil];
}

+ (void)dismiss {
    UIWindow *window = [[[UIApplication sharedApplication]delegate]window];
    UITapGestureRecognizer *tapGes = objc_getAssociatedObject(self, &tapGesKey);
    [window removeGestureRecognizer:tapGes];
    
    UITextView *tipsView = objc_getAssociatedObject(self, &tipsViewKey);
    [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
        tipsView.alpha = 0;
    } completion:^(BOOL finished) {
        [tipsView removeFromSuperview];
    }];
    
    
}

@end
