//
//  NSTextAttachment+Emotion.m
//  XR_Douyin
//
//  Created by 谢汝 on 2018/9/9.
//  Copyright © 2018年 谢汝. All rights reserved.
//

#import "NSTextAttachment+Emotion.h"
#import <objc/runtime.h>



@implementation NSTextAttachment (Emotion)

- (void)setEmotionKey:(NSString *)key {
    objc_setAssociatedObject(self, &emotionKey, key, OBJC_ASSOCIATION_COPY);
}

- (NSString *)emotionKey {
    return objc_getAssociatedObject(self, &emotionKey);
}

@end
