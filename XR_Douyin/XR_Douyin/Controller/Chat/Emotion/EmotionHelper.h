//
//  EmotionHelper.h
//  XR_Douyin
//
//  Created by 谢汝 on 2018/9/9.
//  Copyright © 2018年 谢汝. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface EmotionHelper : NSObject



+ (NSAttributedString *)insertEmotion:(NSAttributedString *)str index:(NSInteger)index emotionKey:(NSString *)key;
@end
