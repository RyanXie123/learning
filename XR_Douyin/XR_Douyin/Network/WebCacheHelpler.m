//
//  WebCache.m
//  XR_Douyin
//
//  Created by 谢汝 on 2018/9/19.
//  Copyright © 2018年 谢汝. All rights reserved.
//

#import "WebCacheHelpler.h"
#import <CommonCrypto/CommonDigest.h>




@implementation WebCombineOperation

- (void)cancel {
    if (self.cacheOperation) {
        [self.cacheOperation cancel];
        self.cacheOperation = nil;
    }
    
    if (self.downloadOperation) {
        [self.downloadOperation cancel];
        self.downloadOperation = nil;
    }
    if (self.cancelBlock) {
        self.cancelBlock();
        self.cancelBlock = nil;
    }
}

@end




@interface WebCache()
@property (nonatomic, strong) NSCache *memCache; //内存缓存
@property (nonatomic, strong) NSFileManager *fileManager;
@property (nonatomic, strong) NSURL *diskCacheDirectoryUrl;
@property (nonatomic, strong) dispatch_queue_t ioQueue; //查询缓存任务队列
@end

@implementation WebCache

+ (WebCache *)sharedWebCache {
    static dispatch_once_t onceToken;
    static id instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [self new];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        _memCache = [NSCache new];
        _memCache.name = @"webCache";
        _fileManager = [NSFileManager defaultManager];
        //获取本地磁盘缓存文件夹路径
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path = paths.lastObject;
        NSString *diskCachePath = [NSString stringWithFormat:@"%@%@",path,@"/webCache"];
        BOOL isDicrectory = NO;
        BOOL isExisted = [_fileManager fileExistsAtPath:diskCachePath isDirectory:&isDicrectory];
        if (!isExisted || !isDicrectory) {
            NSError *error;
            [_fileManager createDirectoryAtPath:diskCachePath withIntermediateDirectories:YES attributes:nil error:&error];
        }
        _diskCacheDirectoryUrl = [NSURL URLWithString:diskCachePath];
        
         //初始化查询缓存任务队列
        _ioQueue = dispatch_queue_create("com.start.webcache", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}



#pragma mark - 取出

- (NSOperation *)queryUrlFromDiskMemory:(NSString *)key cacheQueryCompletedBlock:(WebCacheQueryCompletedBlock)cacheQueryCompletedBlock {
    return [self queryUrlFromDiskMemory:key cacheQueryCompletedBlock:cacheQueryCompletedBlock extension:nil];
}

- (NSOperation *)queryUrlFromDiskMemory:(NSString *)key cacheQueryCompletedBlock:(WebCacheQueryCompletedBlock)cacheQueryCompletedBlock extension:(NSString *)extension {
    NSOperation *operation = [NSOperation new];
    dispatch_async(_ioQueue, ^{
        if (operation.isCancelled) {
            return;
        }
        NSString *path = [self diskCachePathForKey:key extension:extension];
        if ([self.fileManager fileExistsAtPath:path]) {
            cacheQueryCompletedBlock(path,YES);
        }else {
            cacheQueryCompletedBlock(path,NO);
        }
        
    });
    
    return operation;
    
}


- (NSOperation *)queryDataFromMemory:(NSString *)key cacheQueryCompletedBlock:(WebCacheQueryCompletedBlock)cacheQueryCompletedBlock {
    return [self queryDataFromMemory:key cacheQueryCompletedBlock:cacheQueryCompletedBlock extension:nil];
}


//根据key值从内存和本地磁盘中查询缓存数据，所查询缓存数据包含指定文件类型
- (NSOperation *)queryDataFromMemory:(NSString *)key cacheQueryCompletedBlock:(WebCacheQueryCompletedBlock)cacheQueryCompletedBlock extension:(NSString *)extension {
    NSOperation *operation = [NSOperation new];
    dispatch_async(_ioQueue, ^{
        if (operation.isCancelled) {
            return;
        }
        NSData *data = [self dataFromMemoryCache:key];
        if (!data) {
            data = [self dataFromDiskCache:key extension:extension];
            [self storeDataToMemoryCache:data forKey:key];
        }
        
        if (data) {
            cacheQueryCompletedBlock(data,YES);
        }else {
            cacheQueryCompletedBlock(nil,NO);
        }
        
    });
    return operation;
}

- (NSData *)dataFromMemoryCache:(NSString *)key {
    return [_memCache objectForKey:key];
}

- (NSData *)dataForeDiskCache:(NSString *)key {
    return [self dataFromDiskCache:key extension:nil];
}

- (NSData *)dataFromDiskCache:(NSString *)key extension:(NSString *)extension {
    return [NSData dataWithContentsOfFile:[self diskCachePathForKey:key extension:extension]];
}

#pragma mark - 存储
- (void)storeDataCache:(NSData *)data forKey:(NSString *)key {
    dispatch_async(_ioQueue, ^{
        [self storeDataToMemoryCache:data forKey:key];
        [self storeDataToDiskCache:data forKey:key];
    });
}

- (void)storeDataToMemoryCache:(NSData *)data forKey:(NSString *)key {
    if (data && key) {
        [_memCache setObject:data forKey:key];
    }
}


- (void)storeDataToDiskCache:(NSData *)data forKey:(NSString *)key {
    [self storeDataToDiskCache:data forKey:key extension:nil];
}
- (void)storeDataToDiskCache:(NSData *)data forKey:(NSString *)key extension:(NSString *)extension {
    if (data && key) {
        [_fileManager createFileAtPath:[self diskCachePathForKey:key extension:extension] contents:data attributes:nil];
    }
}


- (NSString *)diskCachePathForKey:(NSString *)key extension:(NSString *)extension {
    NSString *fileName = [self md5:key];
    NSString *cachePathForKey = [_diskCacheDirectoryUrl URLByAppendingPathComponent:fileName].path;
    if (extension) {
        cachePathForKey = [cachePathForKey stringByAppendingPathExtension:extension];
    }
    return cachePathForKey;
}

- (NSString *)clearDiskCache {
    NSArray *contents = [_fileManager contentsOfDirectoryAtPath:_diskCacheDirectoryUrl.path error:nil];
    CGFloat folderSize = 0.0f;
    for (NSString *fileName in contents) {
        NSString *filePath = [_diskCacheDirectoryUrl.path stringByAppendingPathComponent:fileName];
         folderSize += [_fileManager attributesOfItemAtPath:filePath error:nil].fileSize;
        [_fileManager removeItemAtPath:filePath error:nil];
    }
    return [NSString stringWithFormat:@"%.2f",folderSize/1024.f/1024.f];
    
}



//key值进行md5签名
- (NSString *)md5:(NSString *)key {
    if(!key) {
        return @"temp";
    }
    const char *str = [key UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), digest);
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    return output;
}
@end



@interface WebDownloadOperation ()
@property (nonatomic, copy) WebDownloaderProgressBlock progressBlock;     //下载进度回调block
@property (nonatomic, copy) WebDownloaderCompletedBlock completedBlock;   //下载完成回调block
@property (nonatomic, copy) WebDownloaderCancelBlock cancelBlock;         //取消下载回调block
@property (nonatomic, strong) NSMutableData *imageData;                   //用于存储网络资源数据
@property (assign, nonatomic) NSInteger expectedSize;                     //网络资源数据总大小


@property (assign, nonatomic) BOOL executing;//判断NSOperation是否执行
@property (assign, nonatomic) BOOL finished;//判断NSOperation是否结束
@end

@implementation WebDownloadOperation
@synthesize executing = _executing;      //指定executing别名为_executing
@synthesize finished = _finished;        //指定finished别名为_finished


//初始化数据
- (instancetype)initWithRequest:(NSURLRequest *)request progressBlock:(WebDownloaderProgressBlock)progressBlock completedBlock:(WebDownloaderCompletedBlock)completedBlock cancelBlock:(WebDownloaderCancelBlock)cancelBlock {
    if ((self = [super init])) {
        _request = [request copy];
        _progressBlock = [progressBlock copy];
        _completedBlock = [completedBlock copy];
        _cancelBlock = [cancelBlock copy];
    }
    return self;
}
- (void)start {
    [self willChangeValueForKey:@"isExecuting"];
    _executing = YES;
    [self didChangeValueForKey:@"isExecuting"];
    
    //判断任务执行前是否取消了任务
    if (self.isCancelled) {
        [self done];
        return;
    }
    @synchronized (self) {
        //创建网络资源下载请求，并设置网络请求代理
        NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        sessionConfig.timeoutIntervalForRequest = 15;
        _session = [NSURLSession sessionWithConfiguration:sessionConfig
                                                 delegate:self
                                            delegateQueue:nil];
        _dataTask = [_session dataTaskWithRequest:_request];
        [_dataTask resume];
    }
}
-(BOOL)isExecuting {
    return _executing;
}

- (BOOL)isFinished {
    return _finished;
}

- (BOOL)isAsynchronous {
    return YES;
}
//取消任务
-(void)cancel {
    @synchronized (self) {
        [self done];
    }
}
//更新任务状态
- (void)done {
    [super cancel];
    if(_executing) {
        [self willChangeValueForKey:@"isFinished"];
        [self willChangeValueForKey:@"isExecuting"];
        _finished = YES;
        _executing = NO;
        [self didChangeValueForKey:@"isFinished"];
        [self didChangeValueForKey:@"isExecuting"];
        [self reset];
    }
    
}
//重置请求数据
- (void)reset {
    if(self.dataTask) {
        [_dataTask cancel];
    }
    if (self.session) {
        [self.session invalidateAndCancel];
        self.session = nil;
    }
}
//网络资源下载请求获得响应
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    NSInteger code = [httpResponse statusCode];
    if(code == 200) {
        completionHandler(NSURLSessionResponseAllow);
        self.imageData = [NSMutableData new];
        NSInteger expected = response.expectedContentLength > 0 ? (NSInteger)response.expectedContentLength : 0;
        self.expectedSize = expected;
    }else {
        completionHandler(NSURLSessionResponseCancel);
    }
}
//网络资源下载请求完毕
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    if(_completedBlock) {
        if(error) {
            if (error.code == NSURLErrorCancelled) {
                _cancelBlock();
            }else {
                _completedBlock(nil, error, NO);
            }
        }else {
            _completedBlock(self.imageData, nil, YES);
        }
    }
    [self done];
}
//接收网络资源下载数据
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    [self.imageData appendData:data];
    if (self.progressBlock) {
        self.progressBlock(self.imageData.length, self.expectedSize);
    }
}

//网络缓存数据复用
-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask willCacheResponse:(NSCachedURLResponse *)proposedResponse completionHandler:(void (^)(NSCachedURLResponse * _Nullable))completionHandler {
    NSCachedURLResponse *cachedResponse = proposedResponse;
    if (self.request.cachePolicy == NSURLRequestReloadIgnoringLocalCacheData) {
        cachedResponse = nil;
    }
    if (completionHandler) {
        completionHandler(cachedResponse);
    }
}



@end



@implementation Webdownloader


+ (Webdownloader *)sharedDownloader {
    static dispatch_once_t onceToken;
    static id instance;
    dispatch_once(&onceToken, ^{
        instance = [self new];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        _downloadQueue = [NSOperationQueue new];
        _downloadQueue.name = @"com.start.webdownloader";
        _downloadQueue.maxConcurrentOperationCount = 8;
    }
    return self;
}

- (WebCombineOperation *)downloadWithUrl:(NSURL *)url progressBlock:(WebDownloaderProgressBlock)progressBlock completedBlock:(WebDownloaderCompletedBlock)completedBlock cancelBlock:(WebDownloaderCancelBlock)cancelBlock {
    
    //初始化网络下载请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60];
    request.HTTPShouldUsePipelining = YES;
    
    __block NSString *key = url.absoluteString;
    __block WebCombineOperation *operation = [WebCombineOperation new];
    __weak typeof(self) weakSelf = self;
    
    operation.cacheOperation = [[WebCache sharedWebCache]queryDataFromMemory:key cacheQueryCompletedBlock:^(id data, BOOL hasCache) {
        if (hasCache) {
            completedBlock(data,nil,YES);
        }else {
            operation.downloadOperation = [[WebDownloadOperation alloc]initWithRequest:request progressBlock:progressBlock completedBlock:^(NSData *data, NSError *error, BOOL finished) {
                if (completedBlock) {
                    if (finished && !error) {
                        [[WebCache sharedWebCache]storeDataCache:data forKey:key];
                        completedBlock(data,nil,YES);
                    }else {
                        completedBlock(data,error,NO);
                    }
                }
            } cancelBlock:^{
                if (cancelBlock) {
                    cancelBlock();
                }
            }];
        }
        
        [weakSelf.downloadQueue addOperation:operation.downloadOperation];
        
        
        
    }];
    
    return operation;
    
}

@end
