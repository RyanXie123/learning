//
//  NetworkHelper.m
//  XR_Douyin
//
//  Created by 谢汝 on 2018/9/6.
//  Copyright © 2018年 谢汝. All rights reserved.
//

#import "NetworkHelper.h"

@implementation NetworkHelper


+ (AFHTTPSessionManager *)sharedManager {
    static dispatch_once_t onceToken;
    static AFHTTPSessionManager *manager;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPSessionManager manager];
        manager.requestSerializer.timeoutInterval = 15.0f;
    });
    return manager;
}


+ (NSURLSessionDataTask *)getWithUrlPath:(NSString *)urlPath request:(BaseRequest *)request success:(HttpSuccess)success failure:(HttpFailure)failure {
    NSDictionary *parameters = [request toDictionary];
    
    return [[NetworkHelper sharedManager]GET:[BaseUrl stringByAppendingString:urlPath] parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [NetworkHelper processResponseData:responseObject succes:success failure:failure];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}


+(void)processResponseData:(id)responseObject succes:(HttpSuccess)success failure:(HttpFailure)failure {
    NSInteger code = -1;
    NSString *message = @"";
    if ([responseObject isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dic = (NSDictionary *)responseObject;
        code = [(NSNumber *)[dic objectForKey:@"code"] integerValue];
        message = (NSString *)[dic objectForKey:@"message"];
    }
    
    if (code == 0) {
        success(responseObject);
    }else {
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:message forKey:NSLocalizedDescriptionKey];
        NSError *error = [NSError errorWithDomain:NetworkDomain code:HttpRequestFailed userInfo:userInfo];
        failure(error);
    }
    
}




@end
