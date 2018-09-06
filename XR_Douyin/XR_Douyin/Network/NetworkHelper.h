//
//  NetworkHelper.h
//  XR_Douyin
//
//  Created by 谢汝 on 2018/9/6.
//  Copyright © 2018年 谢汝. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFHTTPSessionManager.h>
#import "BaseRequest.h"
#import "Constants.h"


typedef enum  {
    HttpRequestFailed = -1000
} NetworkError;
#define NetworkDomain @"com.start.douyin"

typedef void(^HttpSuccess)(id data);
typedef void(^HttpFailure)(NSError *error);


@interface NetworkHelper : NSObject


+ (AFHTTPSessionManager *)sharedManager;

+(NSURLSessionDataTask *)getWithUrlPath:(NSString *)urlPath request:(BaseRequest *)request success:(HttpSuccess)success failure:(HttpFailure)failure;
@end
