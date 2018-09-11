//
//  AwemeListResponse.h
//  XR_Douyin
//
//  Created by 谢汝 on 2018/9/11.
//  Copyright © 2018年 谢汝. All rights reserved.
//

#import "BaseResponse.h"
#import "Aweme.h"
@interface AwemeListResponse : BaseResponse
@property (nonatomic, copy) NSArray<Aweme *> <Aweme>   *data;
@end
