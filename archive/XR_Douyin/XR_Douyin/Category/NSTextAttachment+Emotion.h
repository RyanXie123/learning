//
//  NSTextAttachment+Emotion.h
//  XR_Douyin
//
//  Created by 谢汝 on 2018/9/9.
//  Copyright © 2018年 谢汝. All rights reserved.
//

#import <UIKit/UIKit.h>
static char emotionKey;

@interface NSTextAttachment (Emotion)

- (void)setEmotionKey:(NSString *)key;
- (NSString *)emotionKey;


@end
