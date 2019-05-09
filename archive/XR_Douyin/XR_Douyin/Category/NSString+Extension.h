//
//  NSString+Extension.h
//  XR_Douyin
//
//  Created by 谢汝 on 2018/9/7.
//  Copyright © 2018年 谢汝. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)


- (NSString *) md5;

- (NSURL *)urlScheme:(NSString *)scheme;
+ (NSDictionary *)readJson2DicWithFileName:(NSString *)fileName;
+ (NSString *)formatCount:(NSInteger)count;
@end
