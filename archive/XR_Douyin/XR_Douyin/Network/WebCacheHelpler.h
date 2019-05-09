//
//  WebCache.h
//  XR_Douyin
//
//  Created by 谢汝 on 2018/9/19.
//  Copyright © 2018年 谢汝. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//缓存清除完毕后的回调block
typedef void(^WebCacheClearCompletedBlock)(NSString *cacheSize);
//缓存查询完毕后的回调block，data返回类型包括NSString缓存文件路径、NSData格式缓存数据
typedef void(^WebCacheQueryCompletedBlock)(id data, BOOL hasCache);
//网络资源下载进度的回调block
typedef void(^WebDownloaderProgressBlock)(NSInteger receivedSize, NSInteger expectedSize);
//网络资源下载完毕后的回调block
typedef void(^WebDownloaderCompletedBlock)(NSData *data, NSError *error, BOOL finished);
//网络资源下载取消后的回调block
typedef void(^WebDownloaderCancelBlock)(void);


@class WebDownloadOperation;
@interface WebCombineOperation : NSObject
@property (nonatomic, copy) WebDownloaderCancelBlock cancelBlock;

@property (nonatomic, strong) NSOperation *cacheOperation;

@property (nonatomic, strong) WebDownloadOperation *downloadOperation;

- (void)cancel;
@end


@interface WebCache : NSObject
//单例
+ (WebCache *)sharedWebCache;


- (NSOperation *)queryUrlFromDiskMemory:(NSString *)key cacheQueryCompletedBlock:(WebCacheQueryCompletedBlock)cacheQueryCompletedBlock;
- (NSOperation *)queryUrlFromDiskMemory:(NSString *)key cacheQueryCompletedBlock:(WebCacheQueryCompletedBlock)cacheQueryCompletedBlock extension:(NSString *)extension;


- (NSOperation *)queryDataFromMemory:(NSString *)key cacheQueryCompletedBlock:(WebCacheQueryCompletedBlock)cacheQueryCompletedBlock extension:(NSString *)extension;

//存储缓存数据到内存和本地磁盘
- (void)storeDataCache:(NSData *)data forKey:(NSString *)key;

- (void)storeDataToDiskCache:(NSData *)data forKey:(NSString *)key extension:(NSString *)extension;
@end


//自定义用于下载网络资源的NSOperation任务
@interface WebDownloadOperation : NSOperation <NSURLSessionTaskDelegate, NSURLSessionDataDelegate>
@property (strong, nonatomic) NSURLSession *session;
@property (strong, nonatomic) NSURLSessionTask *dataTask;
@property (strong, nonatomic, readonly) NSURLRequest *request;
//初始化
- (instancetype)initWithRequest:(NSURLRequest *)request progressBlock:(WebDownloaderProgressBlock)progressBlock completedBlock:(WebDownloaderCompletedBlock)completedBlock cancelBlock:(WebDownloaderCancelBlock)cancelBlock;
@end




//自定义网络资源下载类
@interface Webdownloader : NSObject
//用于处理下载任务的NSOperationQueue队列
@property (nonatomic, strong) NSOperationQueue *downloadQueue;

+ (Webdownloader *)sharedDownloader;

- (WebCombineOperation *)downloadWithUrl:(NSURL *)url progressBlock:(WebDownloaderProgressBlock)progressBlock completedBlock:(WebDownloaderCompletedBlock)completedBlock cancelBlock:(WebDownloaderCancelBlock)cancelBlock;

@end
