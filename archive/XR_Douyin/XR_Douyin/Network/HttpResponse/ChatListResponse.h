//
//  ChatListResponse.h
//  XR_Douyin
//
//  Created by 谢汝 on 2018/9/6.
//  Copyright © 2018年 谢汝. All rights reserved.
//

#import "JSONModel.h"
#import "BaseResponse.h"
#import "GroupChat.h"


@interface ChatListResponse : BaseResponse
@property (nonatomic, copy) NSArray<GroupChat>  *data;
@end
