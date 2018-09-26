//
//  CommentListRequest.h
//  XR_Douyin
//
//  Created by 谢汝 on 2018/9/25.
//  Copyright © 2018年 谢汝. All rights reserved.
//

#import "BaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface CommentListRequest : BaseRequest
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger size;
@property (nonatomic, copy) NSString *aweme_id;
@end

NS_ASSUME_NONNULL_END
