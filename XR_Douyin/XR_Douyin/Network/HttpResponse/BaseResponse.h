//
//  BaseResponse.h
//  XR_Douyin
//
//  Created by 谢汝 on 2018/9/6.
//  Copyright © 2018年 谢汝. All rights reserved.
//

#import "JSONModel.h"

@interface BaseResponse : JSONModel

@property (nonatomic, assign) NSInteger code;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, assign) NSInteger has_more;
@property (nonatomic, assign) NSInteger total_count;

@end
