//
//  XRDGroupChatListRequest.h
//  XR_Douyin
//
//  Created by 谢汝 on 2018/9/6.
//  Copyright © 2018年 谢汝. All rights reserved.
//

#import "BaseRequest.h"

@interface XRDGroupChatListRequest : BaseRequest
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger size;

@end
