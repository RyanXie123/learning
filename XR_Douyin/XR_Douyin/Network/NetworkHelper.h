//
//  NetworkHelper.h
//  XR_Douyin
//
//  Created by 谢汝 on 2018/9/6.
//  Copyright © 2018年 谢汝. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFHTTPSessionManager.h>
#import <AFNetworking/AFNetworkReachabilityManager.h>
#import "BaseRequest.h"
#import "Constants.h"

extern NSString *const NetworkStatusChangeNotification;
typedef enum  {
    HttpRequestFailed = -1000
} NetworkError;
#define NetworkDomain @"com.start.douyin"


typedef void(^UploadProgress) (CGFloat percent);
typedef void(^HttpSuccess)(id data);
typedef void(^HttpFailure)(NSError *error);


@interface NetworkHelper : NSObject


+ (AFHTTPSessionManager *)sharedManager;

+(NSURLSessionDataTask *)getWithUrlPath:(NSString *)urlPath request:(BaseRequest *)request success:(HttpSuccess)success failure:(HttpFailure)failure;
+(NSURLSessionDataTask *)uploadWithUrlPath:(NSString *)urlPath data:(NSData *)data request:(BaseRequest *)request progress:(UploadProgress)progress success:(HttpSuccess)success failure:(HttpFailure)failure;


//Reachability
+ (AFNetworkReachabilityManager *)sharedReachabilityManager;

+ (void)startListening;


+ (AFNetworkReachabilityStatus)networkStatus;




@end
