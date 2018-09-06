//
//  NetworkHelper.h
//  XR_Douyin
//
//  Created by 谢汝 on 2018/9/6.
//  Copyright © 2018年 谢汝. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^HttpSuccess)(id data);
typedef void(^HttpFailure)(NSError *error);


@interface NetworkHelper : NSObject

@end
