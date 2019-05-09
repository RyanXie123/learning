//
//  CommentListResponse.h
//  XR_Douyin
//
//  Created by 谢汝 on 2018/9/25.
//  Copyright © 2018年 谢汝. All rights reserved.
//

#import "BaseResponse.h"
#import "Comment.h"

@interface CommentListResponse : BaseResponse
@property (nonatomic, copy) NSArray<Comment>   *data;
@end


