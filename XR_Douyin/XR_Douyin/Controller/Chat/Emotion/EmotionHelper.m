//
//  EmotionHelper.m
//  XR_Douyin
//
//  Created by 谢汝 on 2018/9/9.
//  Copyright © 2018年 谢汝. All rights reserved.
//

#import "EmotionHelper.h"
#import "NSTextAttachment+Emotion.h"


#define EmotionFont [UIFont systemFontOfSize:16.0]

@implementation EmotionHelper



//将表情文本插入指定位置
+ (NSAttributedString *)insertEmotion:(NSAttributedString *)str index:(NSInteger)index emotionKey:(NSString *)key {
    NSTextAttachment *attachMent = [[NSTextAttachment alloc]init];
    [attachMent setEmotionKey:key];
    
    
    NSString *emotionPath = [EmotionHelper emotionIconPath:key];
    attachMent.image = [UIImage imageWithContentsOfFile:emotionPath];
//    attachMent.bounds = CGRectMake(0, EmotionFont.descender, EmotionFont.lineHeight, EmotionFont.lineHeight/(attachMent.image.size.width/attachMent.image.size.height));
    attachMent.bounds = CGRectMake(0, EmotionFont.descender, (EmotionFont.lineHeight/attachMent.image.size.height)* attachMent.image.size.width, EmotionFont.lineHeight);
    
    
    NSAttributedString *matchStr = [NSAttributedString attributedStringWithAttachment:attachMent];
    NSMutableAttributedString *emotionStr = [[NSMutableAttributedString alloc]initWithAttributedString:matchStr];
    [emotionStr addAttribute:NSFontAttributeName value:EmotionFont range:NSMakeRange(0, 1)];
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithAttributedString:str];
    [attrStr replaceCharactersInRange:NSMakeRange(index, 0) withAttributedString:emotionStr];
    return attrStr;
    
//    NSString *emotionPath = [e]
    
    
    
    
}

+ (NSString *)emotionIconPath:(NSString *)emotionKey {
    NSString *emotionIconPath = [[NSBundle mainBundle]pathForResource:@"Emoticons" ofType:@"bundle"];
    NSString *emotionPath = [emotionIconPath stringByAppendingPathComponent:emotionKey];
    return emotionPath;
}


@end
