//
//  GroupChat.m
//  XR_Douyin
//
//  Created by 谢汝 on 2018/9/6.
//  Copyright © 2018年 谢汝. All rights reserved.
//

#import "GroupChat.h"



@implementation GroupChat



+ (BOOL)propertyIsIgnored:(NSString *)propertyName {
    if([propertyName isEqualToString:@"taskId"]
       ||[propertyName isEqualToString:@"isTemp"]
       ||[propertyName isEqualToString:@"picImage"]
       ||[propertyName isEqualToString:@"cellHeight"])
        return YES;
    return NO;
}


@end
