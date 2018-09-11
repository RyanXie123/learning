//
//  UserResponse.h
//  XR_Douyin
//
//  Created by 谢汝 on 2018/9/10.
//  Copyright © 2018年 谢汝. All rights reserved.
//

#import "BaseResponse.h"
#import "User.h"
@interface UserResponse : BaseResponse
@property (nonatomic, strong) User *data;
@end
