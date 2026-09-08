//
//  MKIDMNetWorkRequest.m
//  MKIotDMApp_Example
//
//  Created by aa on 2025/11/25.
//  Copyright © 2025 lovexiaoxia. All rights reserved.
//

#import "MKIDMNetWorkRequest.h"

#import <Foundation/Foundation.h>
#import <MobileCoreServices/MobileCoreServices.h>

#import "MKMacroDefines.h"

#import "MKIDMNetworkDefine.h"
#import "MKIDMUserManager.h"

static MKIDMNetWorkRequest *instance = nil;
static dispatch_once_t onceToken;

@interface MKIDMNetWorkRequest() <NSURLSessionTaskDelegate, NSURLSessionDataDelegate>

@property (nonatomic, strong) NSMutableArray<NSURLSessionTask *> *requests; // 所有请求
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, void (^)(double)> *progressBlocks; // 进度回调字典
@property (nonatomic, strong) NSProgress *progress; // 进度

@end

@implementation MKIDMNetWorkRequest

- (void)dealloc {
    NSLog(@"MKIDMNetWorkRequest销毁");
}

+ (MKIDMNetWorkRequest *)shared {
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

/// 单例销毁
+ (void)singleDealloc {
    onceToken = 0;
    instance = nil;
}

#pragma mark - 初始化
- (instancetype)init {
    self = [super init];
    if (self) {
        _requests = [NSMutableArray array];
        _progressBlocks = [NSMutableDictionary dictionary];
        _autoRemoveNullValues = YES; // 默认开启自动移除 null 值
    }
    return self;
}

#pragma mark - Null 值处理

/**
 * 递归处理字典/数组中的 NSNull，将其转换为空字符串
 * @param object 原始数据（可能是字典、数组或其他类型）
 * @return 处理后的数据
 */
- (id)removeNullValuesFromObject:(id)object {
    if ([object isKindOfClass:[NSDictionary class]]) {
        // 处理字典
        NSMutableDictionary *result = [NSMutableDictionary dictionary];
        [(NSDictionary *)object enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            id processedObj = [self removeNullValuesFromObject:obj];
            if (processedObj) {
                result[key] = processedObj;
            } else {
                // 将 NSNull 转换为空字符串，避免取值崩溃
                result[key] = @"";
            }
        }];
        return [result copy];
    }
    else if ([object isKindOfClass:[NSArray class]]) {
        // 处理数组
        NSMutableArray *result = [NSMutableArray array];
        [(NSArray *)object enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            id processedObj = [self removeNullValuesFromObject:obj];
            if (processedObj) {
                [result addObject:processedObj];
            } else {
                // 数组中的 null 添加空字符串
                [result addObject:@""];
            }
        }];
        return [result copy];
    }
    else if ([object isKindOfClass:[NSNull class]]) {
        // 遇到 NSNull 直接返回 nil
        return nil;
    }
    else {
        // 其他类型（字符串、数字等）直接返回
        return object;
    }
}

#pragma mark - 基础请求方法（公共方法）
/**
 * 通用网络请求方法（支持 GET/POST/PUT/DELETE）
 */
- (NSURLSessionDataTask *)requestWithURL:(NSString *)url
                                  method:(MKIDMNetworkRequestType)requestType
                         timeoutInterval:(NSTimeInterval)timeoutInterval
                              parameters:(NSDictionary * _Nullable)parameters
                            successBlock:(MKIDMNetworkRequestSuccessBlock)successBlock
                            failureBlock:(MKIDMNetworkRequestFailureBlock)failureBlock {
    
    // URL检查
    NSURL *requestURL = [NSURL URLWithString:url];
    if (!requestURL) {
        NSError *error = [NSError errorWithDomain:@"MKIDMNetWorkRequest"
                                             code:MKIDMNetworkErrorInvalidURL
                                         userInfo:@{@"errorInfo": @"无效的URL地址"}];
        if (failureBlock) failureBlock(error);
        return nil;
    }
    
    // 创建请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestURL];
    
    // 设置HTTP方法
    NSString *httpMethod = @"GET";
    switch (requestType) {
        case MKIDMNetworkRequestGet:
            httpMethod = @"GET";
            break;
        case MKIDMNetworkRequestPost:
            httpMethod = @"POST";
            break;
        case MKIDMNetworkRequestPut:
            httpMethod = @"PUT";
            break;
        case MKIDMNetworkRequestDelete:
            httpMethod = @"DELETE";
            break;
    }
    request.HTTPMethod = httpMethod;
    request.timeoutInterval = timeoutInterval;
    
    // 设置通用请求头
    [self setupCommonHeadersForRequest:request];
    
    // 处理请求参数
    if (parameters) {
        if ([httpMethod isEqualToString:@"GET"]) {
            // GET请求：参数放在URL中
            request.URL = [self URLWithString:url queryParameters:parameters];
        } else {
            // POST/PUT/DELETE请求：参数放在Body中
            [self setupBodyForRequest:request withParameters:parameters];
        }
    }
    
    // 创建并执行数据任务
    return [self createDataTaskWithRequest:request
                              successBlock:successBlock
                              failureBlock:failureBlock];
}

/**
 * 创建带查询参数的请求（空body）
 * 用于特殊的POST/PUT/DELETE请求，参数在URL查询字符串中，请求体为空
 */
- (NSURLSessionDataTask *)requestWithMethod:(NSString *)method
                                        url:(NSString *)url
                                 parameters:(NSDictionary * _Nullable)parameters
                               successBlock:(MKIDMNetworkRequestSuccessBlock)successBlock
                               failureBlock:(MKIDMNetworkRequestFailureBlock)failureBlock {
    
    // 1. URL有效性检查
    NSURL *requestURL = [NSURL URLWithString:url];
    if (!requestURL) {
        NSError *error = [NSError errorWithDomain:@"MKIDMNetWorkRequest"
                                             code:MKIDMNetworkErrorInvalidURL
                                         userInfo:@{@"errorInfo": @"无效的URL地址"}];
        if (failureBlock) failureBlock(error);
        return nil;
    }
    
    // 2. 如果有查询参数，构建包含查询参数的URL
    if (parameters && parameters.count > 0) {
        NSString *urlString = [self buildURLWithBase:url parameters:parameters];
        requestURL = [NSURL URLWithString:urlString];
        
        if (!requestURL) {
            NSError *error = [NSError errorWithDomain:@"MKIDMNetWorkRequest"
                                                 code:MKIDMNetworkErrorInvalidURL
                                             userInfo:@{@"errorInfo": @"URL拼接失败"}];
            if (failureBlock) failureBlock(error);
            return nil;
        }
    }
    
    // 3. 创建请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestURL];
    request.HTTPMethod = method;
    request.timeoutInterval = 30.0;
    
    // 4. 设置空 body（参数已在 URL 中）
    request.HTTPBody = [NSData data];
    
    // 5. 设置通用请求头（Content-Type 默认 application/json、User-Agent、Authorization）
    [self setupCommonHeadersForRequest:request];
    
    // 7. 创建并执行数据任务
    return [self createDataTaskWithRequest:request
                              successBlock:successBlock
                              failureBlock:failureBlock];
}

#pragma mark - 快捷请求方法（GET/POST/PUT/DELETE）
/**
 * GET网络请求
 */
- (NSURLSessionDataTask *)GET:(NSString *)url
                   parameters:(NSDictionary *)parameters
                 successBlock:(MKIDMNetworkRequestSuccessBlock)successBlock
                 failureBlock:(MKIDMNetworkRequestFailureBlock)failureBlock {
    return [self requestWithURL:url
                         method:MKIDMNetworkRequestGet
                timeoutInterval:30.f
                     parameters:parameters
                   successBlock:successBlock
                   failureBlock:failureBlock];
}

/**
 * POST网络请求（JSON格式）
 */
- (NSURLSessionDataTask *)POST:(NSString *)url
                    parameters:(NSDictionary *)parameters
                  successBlock:(MKIDMNetworkRequestSuccessBlock)successBlock
                  failureBlock:(MKIDMNetworkRequestFailureBlock)failureBlock {
    return [self requestWithURL:url
                         method:MKIDMNetworkRequestPost
                timeoutInterval:30.f
                     parameters:parameters
                   successBlock:successBlock
                   failureBlock:failureBlock];
}

/**
 * POST表单请求（x-www-form-urlencoded格式）
 * 参数放在HTTPBody中，格式为 key1=value1&key2=value2
 */
- (NSURLSessionDataTask *)POSTForm:(NSString *)url
                        parameters:(NSDictionary *)parameters
                      successBlock:(MKIDMNetworkRequestSuccessBlock)successBlock
                      failureBlock:(MKIDMNetworkRequestFailureBlock)failureBlock {

    NSURL *requestURL = [NSURL URLWithString:url];
    if (!requestURL) {
        NSError *error = [NSError errorWithDomain:@"MKIDMNetWorkRequest"
                                             code:MKIDMNetworkErrorInvalidURL
                                         userInfo:@{@"errorInfo": @"无效的URL地址"}];
        if (failureBlock) failureBlock(error);
        return nil;
    }

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestURL];
    request.HTTPMethod = @"POST";
    request.timeoutInterval = 30.0;

    [self setupCommonHeadersForRequest:request];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];

    if (parameters && parameters.count > 0) {
        NSMutableString *bodyString = [NSMutableString string];
        [parameters enumerateKeysAndObjectsUsingBlock:^(NSString *key, id value, BOOL *stop) {
            NSString *encodedValue = [[NSString stringWithFormat:@"%@", value]
                stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            [bodyString appendFormat:@"%@=%@&", key, encodedValue];
        }];
        if (bodyString.length > 0) {
            [bodyString deleteCharactersInRange:NSMakeRange(bodyString.length - 1, 1)];
        }
        request.HTTPBody = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
    }

    return [self createDataTaskWithRequest:request
                              successBlock:successBlock
                              failureBlock:failureBlock];
}

/**
 * PUT网络请求
 */
- (NSURLSessionDataTask *)PUT:(NSString *)url
                   parameters:(NSDictionary *)parameters
                 successBlock:(MKIDMNetworkRequestSuccessBlock)successBlock
                 failureBlock:(MKIDMNetworkRequestFailureBlock)failureBlock {
    return [self requestWithURL:url
                         method:MKIDMNetworkRequestPut
                timeoutInterval:30.f
                     parameters:parameters
                   successBlock:successBlock
                   failureBlock:failureBlock];
}

/**
 * DELETE网络请求
 */
- (NSURLSessionDataTask *)DELETE:(NSString *)url
                      parameters:(NSDictionary *)parameters
                    successBlock:(MKIDMNetworkRequestSuccessBlock)successBlock
                    failureBlock:(MKIDMNetworkRequestFailureBlock)failureBlock {
    return [self requestWithURL:url
                         method:MKIDMNetworkRequestDelete
                timeoutInterval:30.f
                     parameters:parameters
                   successBlock:successBlock
                   failureBlock:failureBlock];
}

#pragma mark - 特殊请求方法（查询参数，空body）
/**
 * POST请求 - 参数放在URL查询字符串中，body为空
 * 用于处理那些要求参数在URL中而不是body中的特殊接口
 */
- (NSURLSessionDataTask *)POSTURLParams:(NSString *)url
                             parameters:(NSDictionary *)parameters
                           successBlock:(MKIDMNetworkRequestSuccessBlock)successBlock
                           failureBlock:(MKIDMNetworkRequestFailureBlock)failureBlock {
    return [self requestWithMethod:@"POST"
                               url:url
                        parameters:parameters
                      successBlock:successBlock
                      failureBlock:failureBlock];
}

/**
 * POST请求（查询参数，空body）
 * 等价于 POSTURLParams:，保留是为了兼容已有调用方
 */
- (NSURLSessionDataTask *)POSTWithQueryParams:(NSString *)url
                                   parameters:(NSDictionary *)parameters
                                 successBlock:(MKIDMNetworkRequestSuccessBlock)successBlock
                                 failureBlock:(MKIDMNetworkRequestFailureBlock)failureBlock {
    return [self POSTURLParams:url
                     parameters:parameters
                   successBlock:successBlock
                   failureBlock:failureBlock];
}

/**
 * PUT请求（查询参数，空body）
 * 类似POSTWithQueryParams，用于PUT方法
 */
- (NSURLSessionDataTask *)PUTWithQueryParams:(NSString *)url
                                  parameters:(NSDictionary *)parameters
                                successBlock:(MKIDMNetworkRequestSuccessBlock)successBlock
                                failureBlock:(MKIDMNetworkRequestFailureBlock)failureBlock {
    return [self requestWithMethod:@"PUT"
                               url:url
                        parameters:parameters
                      successBlock:successBlock
                      failureBlock:failureBlock];
}

/**
 * DELETE请求（查询参数，空body）
 * 用于处理特殊的DELETE接口，参数在URL查询字符串中，请求体为空
 */
- (NSURLSessionDataTask *)DELETEWithQueryParams:(NSString *)url
                                     parameters:(NSDictionary * _Nullable)parameters
                                   successBlock:(MKIDMNetworkRequestSuccessBlock)successBlock
                                   failureBlock:(MKIDMNetworkRequestFailureBlock)failureBlock {
    return [self requestWithMethod:@"DELETE"
                               url:url
                        parameters:parameters
                      successBlock:successBlock
                      failureBlock:failureBlock];
}

/**
 * DFU升级专用PUT请求（超时时间5分钟）
 * 专门用于设备固件升级操作，需要较长的超时时间
 */
- (NSURLSessionDataTask *)PUTForDFU:(NSString *)url
                         parameters:(NSDictionary * _Nullable)parameters
                       successBlock:(MKIDMNetworkRequestSuccessBlock)successBlock
                       failureBlock:(MKIDMNetworkRequestFailureBlock)failureBlock {
    
    // URL检查
    NSURL *requestURL = [NSURL URLWithString:url];
    if (!requestURL) {
        NSError *error = [NSError errorWithDomain:@"MKIDMNetWorkRequest"
                                             code:MKIDMNetworkErrorInvalidURL
                                         userInfo:@{@"errorInfo": @"无效的URL地址"}];
        if (failureBlock) failureBlock(error);
        return nil;
    }
    
    // 创建请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestURL];
    request.HTTPMethod = @"PUT";
    request.timeoutInterval = 300.0; // 5分钟超时时间
    
    // 设置通用请求头
    [self setupCommonHeadersForRequest:request];
    
    // 处理请求参数
    if (parameters) {
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters
                                                           options:0
                                                             error:&error];
        if (!error && jsonData) {
            request.HTTPBody = jsonData;
        }
    }
    
    // 创建并执行数据任务
    return [self createDataTaskWithRequest:request
                              successBlock:successBlock
                              failureBlock:failureBlock];
}

#pragma mark - 文件上传方法
/**
 * 上传文件（通用方法）
 */
- (NSURLSessionDataTask *)uploadFile:(NSString *)url
                          parameters:(NSDictionary *)parameters
                            fileData:(NSData *)fileData
                           fileName:(NSString *)fileName
                           mimeType:(NSString *)mimeType
                       progressBlock:(MKIDMNetworkUploadProgressBlock)progressBlock
                        successBlock:(MKIDMNetworkRequestSuccessBlock)successBlock
                        failureBlock:(MKIDMNetworkRequestFailureBlock)failureBlock {
    
    // ==================== 1. 参数检查 ====================
    
    // 检查URL
    NSURL *requestURL = [NSURL URLWithString:url];
    if (!requestURL) {
        NSError *error = [NSError errorWithDomain:@"MKIDMNetWorkRequest"
                                             code:MKIDMNetworkErrorInvalidURL
                                         userInfo:@{@"errorInfo": @"无效的URL地址"}];
        if (failureBlock) failureBlock(error);
        return nil;
    }
    
    // 检查文件数据
    if (!fileData || fileData.length == 0) {
        NSError *error = [NSError errorWithDomain:@"MKIDMNetWorkRequest"
                                             code:MKIDMNetworkErrorInvalidParameters
                                         userInfo:@{@"errorInfo": @"文件数据为空"}];
        if (failureBlock) failureBlock(error);
        return nil;
    }
    
    // 限制文件大小（最大100MB）
    const NSUInteger maxFileSize = 100 * 1024 * 1024;
    if (fileData.length > maxFileSize) {
        NSError *error = [NSError errorWithDomain:@"MKIDMNetWorkRequest"
                                             code:MKIDMNetworkErrorFileTooLarge
                                         userInfo:@{@"errorInfo": @"文件大小超过100MB限制"}];
        if (failureBlock) failureBlock(error);
        return nil;
    }
    
    // ==================== 2. 准备文件名和MIME类型 ====================
    
    // 确定文件名
    NSString *actualFileName = fileName;
    if (!ValidStr(actualFileName)) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyyMMdd_HHmmss"];
        NSString *timestamp = [formatter stringFromDate:[NSDate date]];
        actualFileName = [NSString stringWithFormat:@"file_%@", timestamp];
    }
    
    // 确定MIME类型
    NSString *actualMimeType = mimeType;
    if (!ValidStr(actualMimeType)) {
        actualMimeType = [self mimeTypeForFileName:actualFileName];
    }
    
    // ==================== 3. 创建multipart/form-data请求 ====================
    
    // 创建请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestURL];
    request.HTTPMethod = @"POST";
    request.timeoutInterval = 180.0;
    
    // 设置请求头
    NSString *boundary = @"MKIDMNetWorkRequestBoundary";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
    [self setupCommonHeadersForRequest:request];
    
    // 构建请求体
    NSData *bodyData = [self createMultipartFormDataWithParameters:parameters
                                                          fileData:fileData
                                                          fileName:actualFileName
                                                          mimeType:actualMimeType
                                                          boundary:boundary];
    
    if (!bodyData) {
        NSError *error = [NSError errorWithDomain:@"MKIDMNetWorkRequest"
                                             code:MKIDMNetworkErrorInvalidParameters
                                         userInfo:@{@"errorInfo": @"创建请求体失败"}];
        if (failureBlock) failureBlock(error);
        return nil;
    }
    
    // ==================== 4. 创建上传任务 ====================
    
    // 根据是否需要进度回调创建不同的Session
    NSURLSession *session = nil;
    if (progressBlock) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        session = [NSURLSession sessionWithConfiguration:configuration
                                                delegate:self
                                           delegateQueue:[NSOperationQueue mainQueue]];
    } else {
        session = [NSURLSession sharedSession];
    }
    
    @weakify(self);
    NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request
                                                               fromData:bodyData
                                                      completionHandler:^(NSData * _Nullable data,
                                                                          NSURLResponse * _Nullable response,
                                                                          NSError * _Nullable error) {
        @strongify(self);
        [self handleUploadTaskCompletion:uploadTask
                                    data:data
                                response:response
                                   error:error
                           progressBlock:progressBlock
                            successBlock:successBlock
                            failureBlock:failureBlock];
    }];
    
    // 存储进度回调
    if (uploadTask && progressBlock) {
        self.progressBlocks[@(uploadTask.taskIdentifier)] = progressBlock;
    }
    
    // 添加到请求数组并开始执行
    [self.requests addObject:uploadTask];
    [uploadTask resume];
    
    return uploadTask;
}

/**
 * 上传图片（便捷方法）
 */
- (NSURLSessionDataTask *)uploadImage:(NSString *)url
                           parameters:(NSDictionary *)parameters
                                image:(UIImage *)image
                            imageName:(NSString *)imageName
                    compressionQuality:(CGFloat)compressionQuality
                         progressBlock:(MKIDMNetworkUploadProgressBlock)progressBlock
                          successBlock:(MKIDMNetworkRequestSuccessBlock)successBlock
                          failureBlock:(MKIDMNetworkRequestFailureBlock)failureBlock {
    
    // 检查图片
    if (!image) {
        NSError *error = [NSError errorWithDomain:@"MKIDMNetWorkRequest"
                                             code:MKIDMNetworkErrorInvalidParameters
                                         userInfo:@{@"errorInfo": @"图片对象不能为空"}];
        if (failureBlock) failureBlock(error);
        return nil;
    }
    
    // 设置压缩质量
    CGFloat actualCompression = compressionQuality;
    if (actualCompression <= 0 || actualCompression > 1.0) {
        actualCompression = 0.8;
    }
    
    // 压缩为JPEG数据
    NSData *imageData = UIImageJPEGRepresentation(image, actualCompression);
    if (!imageData || imageData.length == 0) {
        NSError *error = [NSError errorWithDomain:@"MKIDMNetWorkRequest"
                                             code:MKIDMNetworkErrorInvalidParameters
                                         userInfo:@{@"errorInfo": @"图片压缩失败"}];
        if (failureBlock) failureBlock(error);
        return nil;
    }
    
    // 限制图片大小（最大10MB）
    const NSUInteger maxImageSize = 10 * 1024 * 1024;
    if (imageData.length > maxImageSize) {
        // 尝试进一步压缩
        CGFloat reducedCompression = actualCompression * 0.7;
        imageData = UIImageJPEGRepresentation(image, reducedCompression);
        
        if (!imageData || imageData.length > maxImageSize) {
            NSError *error = [NSError errorWithDomain:@"MKIDMNetWorkRequest"
                                                 code:MKIDMNetworkErrorFileTooLarge
                                             userInfo:@{@"errorInfo": @"图片大小超过10MB限制"}];
            if (failureBlock) failureBlock(error);
            return nil;
        }
    }
    
    // 确定文件名
    NSString *actualImageName = imageName;
    if (!ValidStr(actualImageName)) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyyMMdd_HHmmss"];
        NSString *timestamp = [formatter stringFromDate:[NSDate date]];
        actualImageName = [NSString stringWithFormat:@"image_%@.jpg", timestamp];
    } else if (![actualImageName.pathExtension.lowercaseString isEqualToString:@"jpg"] &&
               ![actualImageName.pathExtension.lowercaseString isEqualToString:@"jpeg"]) {
        actualImageName = [actualImageName stringByDeletingPathExtension];
        actualImageName = [actualImageName stringByAppendingPathExtension:@"jpg"];
    }
    
    // 使用通用上传方法
    return [self uploadFile:url
                 parameters:parameters
                   fileData:imageData
                  fileName:actualImageName
                  mimeType:@"image/jpeg"
             progressBlock:progressBlock
              successBlock:successBlock
              failureBlock:failureBlock];
}

/**
 * 上传多张图片
 */
- (NSURLSessionDataTask *)uploadImages:(NSString *)url
                            parameters:(NSDictionary *)parameters
                                images:(NSArray<UIImage *> *)images
                            imageNames:(NSArray<NSString *> *)imageNames
                     compressionQuality:(CGFloat)compressionQuality
                          progressBlock:(MKIDMNetworkUploadProgressBlock)progressBlock
                           successBlock:(MKIDMNetworkRequestSuccessBlock)successBlock
                           failureBlock:(MKIDMNetworkRequestFailureBlock)failureBlock {
    
    if (!images || images.count == 0) {
        NSError *error = [NSError errorWithDomain:@"MKIDMNetWorkRequest"
                                             code:MKIDMNetworkErrorInvalidParameters
                                         userInfo:@{@"errorInfo": @"图片数组不能为空"}];
        if (failureBlock) failureBlock(error);
        return nil;
    }
    
    // 准备文件数组
    NSMutableArray<NSDictionary *> *files = [NSMutableArray array];
    [images enumerateObjectsUsingBlock:^(UIImage *image, NSUInteger idx, BOOL *stop) {
        @autoreleasepool {
            // 设置压缩质量
            CGFloat actualCompression = compressionQuality;
            if (actualCompression <= 0 || actualCompression > 1.0) {
                actualCompression = 0.8;
            }
            
            // 压缩为JPEG数据
            NSData *imageData = UIImageJPEGRepresentation(image, actualCompression);
            if (imageData) {
                // 确定文件名
                NSString *fileName = nil;
                if (imageNames && idx < imageNames.count) {
                    fileName = imageNames[idx];
                }
                
                if (!ValidStr(fileName)) {
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:@"yyyyMMdd_HHmmss"];
                    NSString *timestamp = [formatter stringFromDate:[NSDate date]];
                    fileName = [NSString stringWithFormat:@"image_%@_%lu.jpg", timestamp, (unsigned long)idx];
                }
                
                [files addObject:@{
                    @"data": imageData,
                    @"name": @"files",
                    @"fileName": fileName,
                    @"mimeType": @"image/jpeg"
                }];
            }
        }
    }];
    
    if (files.count == 0) {
        NSError *error = [NSError errorWithDomain:@"MKIDMNetWorkRequest"
                                             code:MKIDMNetworkErrorInvalidParameters
                                         userInfo:@{@"errorInfo": @"没有有效的图片数据"}];
        if (failureBlock) failureBlock(error);
        return nil;
    }
    
    return [self uploadMultipleFiles:url
                          parameters:parameters
                               files:files
                       progressBlock:progressBlock
                        successBlock:successBlock
                        failureBlock:failureBlock];
}

/**
 * 上传多个文件
 */
- (NSURLSessionDataTask *)uploadMultipleFiles:(NSString *)url
                                   parameters:(NSDictionary *)parameters
                                        files:(NSArray<NSDictionary *> *)files
                                progressBlock:(MKIDMNetworkUploadProgressBlock)progressBlock
                                 successBlock:(MKIDMNetworkRequestSuccessBlock)successBlock
                                 failureBlock:(MKIDMNetworkRequestFailureBlock)failureBlock {
    
    if (!files || files.count == 0) {
        NSError *error = [NSError errorWithDomain:@"MKIDMNetWorkRequest"
                                             code:MKIDMNetworkErrorInvalidParameters
                                         userInfo:@{@"errorInfo": @"文件数组不能为空"}];
        if (failureBlock) failureBlock(error);
        return nil;
    }
    
    // ==================== 1. 参数检查 ====================
    
    // 检查URL
    NSURL *requestURL = [NSURL URLWithString:url];
    if (!requestURL) {
        NSError *error = [NSError errorWithDomain:@"MKIDMNetWorkRequest"
                                             code:MKIDMNetworkErrorInvalidURL
                                         userInfo:@{@"errorInfo": @"无效的URL地址"}];
        if (failureBlock) failureBlock(error);
        return nil;
    }
    
    // 检查文件数据
    __block BOOL hasValidFile = NO;
    [files enumerateObjectsUsingBlock:^(NSDictionary *fileDict, NSUInteger idx, BOOL *stop) {
        NSData *fileData = fileDict[@"data"];
        if ([fileData isKindOfClass:[NSData class]] && fileData.length > 0) {
            hasValidFile = YES;
            *stop = YES;
        }
    }];
    
    if (!hasValidFile) {
        NSError *error = [NSError errorWithDomain:@"MKIDMNetWorkRequest"
                                             code:MKIDMNetworkErrorInvalidParameters
                                         userInfo:@{@"errorInfo": @"没有有效的文件数据"}];
        if (failureBlock) failureBlock(error);
        return nil;
    }
    
    // ==================== 2. 创建multipart/form-data请求 ====================
    
    // 创建请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestURL];
    request.HTTPMethod = @"POST";
    request.timeoutInterval = 300.0; // 多文件上传需要更长时间
    
    // 设置请求头
    NSString *boundary = @"MKIDMNetWorkRequestBoundary";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
    [self setupCommonHeadersForRequest:request];
    
    // 构建请求体
    NSData *bodyData = [self createMultipartFormDataWithParameters:parameters
                                                             files:files
                                                          boundary:boundary];
    
    if (!bodyData) {
        NSError *error = [NSError errorWithDomain:@"MKIDMNetWorkRequest"
                                             code:MKIDMNetworkErrorInvalidParameters
                                         userInfo:@{@"errorInfo": @"创建请求体失败"}];
        if (failureBlock) failureBlock(error);
        return nil;
    }
    
    // ==================== 3. 创建上传任务 ====================
    
    // 根据是否需要进度回调创建不同的Session
    NSURLSession *session = nil;
    if (progressBlock) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        session = [NSURLSession sessionWithConfiguration:configuration
                                                delegate:self
                                           delegateQueue:[NSOperationQueue mainQueue]];
    } else {
        session = [NSURLSession sharedSession];
    }
    
    @weakify(self);
    NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request
                                                               fromData:bodyData
                                                      completionHandler:^(NSData * _Nullable data,
                                                                          NSURLResponse * _Nullable response,
                                                                          NSError * _Nullable error) {
        @strongify(self);
        [self handleUploadTaskCompletion:uploadTask
                                    data:data
                                response:response
                                   error:error
                           progressBlock:progressBlock
                            successBlock:successBlock
                            failureBlock:failureBlock];
    }];
    
    // 存储进度回调
    if (uploadTask && progressBlock) {
        self.progressBlocks[@(uploadTask.taskIdentifier)] = progressBlock;
    }
    
    // 添加到请求数组并开始执行
    [self.requests addObject:uploadTask];
    [uploadTask resume];
    
    return uploadTask;
}

#pragma mark - 取消请求方法
- (void)cancelAllRequests {
    for (NSURLSessionTask *task in self.requests) {
        if (task.state == NSURLSessionTaskStateRunning) {
            [task cancel];
        }
    }
    [self.requests removeAllObjects];
    [self clearProgressBlocks];
}

- (void)cancelRequest:(NSURLSessionTask *)task {
    if (task && task.state == NSURLSessionTaskStateRunning) {
        [task cancel];
        [self.requests removeObject:task];
        [self.progressBlocks removeObjectForKey:@(task.taskIdentifier)];
    }
}

- (void)clearProgressBlocks {
    [self.progressBlocks removeAllObjects];
}

#pragma mark - 辅助方法
/**
 * 设置通用请求头
 */
- (void)setupCommonHeadersForRequest:(NSMutableURLRequest *)request {
    // 设置Content-Type
    if (![request valueForHTTPHeaderField:@"Content-Type"]) {
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    }
    
    // 设置User-Agent
    NSString *userAgent = [NSString stringWithFormat:@"%@/%@ (%@; iOS %@; Scale/%0.2f)",
                          [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleExecutableKey] ?:
                          [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleIdentifierKey],
                          [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"] ?:
                          [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleVersionKey],
                          [[UIDevice currentDevice] model],
                          [[UIDevice currentDevice] systemVersion],
                          [[UIScreen mainScreen] scale]];
    [request setValue:userAgent forHTTPHeaderField:@"User-Agent"];
    
    // 设置Authorization头
    if ([MKIDMUserManager sharedManager].isLoggedIn) {
        NSString *token = [MKIDMUserManager sharedManager].currentToken;
        if (ValidStr(token)) {
            [request setValue:[NSString stringWithFormat:@"Bearer %@", token]
           forHTTPHeaderField:@"Authorization"];
        }
    }
}

/**
 * 为请求设置Body参数
 */
- (void)setupBodyForRequest:(NSMutableURLRequest *)request withParameters:(NSDictionary *)parameters {
    if (!parameters || parameters.count == 0) {
        return;
    }
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters
                                                       options:0
                                                         error:&error];
    if (!error && jsonData) {
        request.HTTPBody = jsonData;
    }
}

/**
 * 创建包含查询参数的URL
 */
- (NSURL *)URLWithString:(NSString *)urlString queryParameters:(NSDictionary *)parameters {
    if (!parameters || parameters.count == 0) {
        return [NSURL URLWithString:urlString];
    }
    
    NSMutableString *urlWithQuery = [NSMutableString stringWithString:urlString];
    __block BOOL hasQuery = [urlString containsString:@"?"];
    
    [parameters enumerateKeysAndObjectsUsingBlock:^(NSString *key, id value, BOOL *stop) {
        NSString *encodedKey = [key stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSString *encodedValue = [[NSString stringWithFormat:@"%@", value] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        
        if (hasQuery) {
            [urlWithQuery appendFormat:@"&%@=%@", encodedKey, encodedValue];
        } else {
            [urlWithQuery appendFormat:@"?%@=%@", encodedKey, encodedValue];
            hasQuery = YES;
        }
    }];
    
    return [NSURL URLWithString:urlWithQuery];
}

/**
 * 从参数字典创建查询字符串
 */
- (NSString *)queryStringFromParameters:(NSDictionary *)parameters {
    if (!parameters || parameters.count == 0) {
        return @"";
    }
    
    NSMutableArray *queryPairs = [NSMutableArray array];
    [parameters enumerateKeysAndObjectsUsingBlock:^(NSString *key, id value, BOOL *stop) {
        NSString *encodedKey = [key stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSString *encodedValue = [[NSString stringWithFormat:@"%@", value] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [queryPairs addObject:[NSString stringWithFormat:@"%@=%@", encodedKey, encodedValue]];
    }];
    
    return [queryPairs componentsJoinedByString:@"&"];
}

/**
 * 创建multipart/form-data请求体（单个文件）
 */
- (NSData *)createMultipartFormDataWithParameters:(NSDictionary *)parameters
                                         fileData:(NSData *)fileData
                                         fileName:(NSString *)fileName
                                         mimeType:(NSString *)mimeType
                                         boundary:(NSString *)boundary {
    
    NSMutableData *body = [NSMutableData data];
    
    // 添加表单参数
    if (ValidDict(parameters)) {
        [parameters enumerateKeysAndObjectsUsingBlock:^(NSString *key, id value, BOOL *stop) {
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"%@\r\n", value] dataUsingEncoding:NSUTF8StringEncoding]];
        }];
    }
    
    // 添加文件数据
    if (fileData && fileData.length > 0 && ValidStr(fileName) && ValidStr(mimeType)) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"file\"; filename=\"%@\"\r\n", fileName] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", mimeType] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:fileData];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    // 添加结束标志
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    return [body copy];
}

/**
 * 创建multipart/form-data请求体（多个文件）
 */
- (NSData *)createMultipartFormDataWithParameters:(NSDictionary *)parameters
                                            files:(NSArray<NSDictionary *> *)files
                                         boundary:(NSString *)boundary {
    
    NSMutableData *body = [NSMutableData data];
    
    // 添加表单参数
    if (ValidDict(parameters)) {
        [parameters enumerateKeysAndObjectsUsingBlock:^(NSString *key, id value, BOOL *stop) {
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"%@\r\n", value] dataUsingEncoding:NSUTF8StringEncoding]];
        }];
    }
    
    // 添加多个文件数据
    [files enumerateObjectsUsingBlock:^(NSDictionary *fileDict, NSUInteger idx, BOOL *stop) {
        NSData *fileData = fileDict[@"data"];
        NSString *name = fileDict[@"name"] ?: @"files";
        NSString *fileName = fileDict[@"fileName"];
        NSString *mimeType = fileDict[@"mimeType"];
        
        if ([fileData isKindOfClass:[NSData class]] && fileData.length > 0 &&
            ValidStr(fileName) && ValidStr(mimeType)) {
            
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", name, fileName] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", mimeType] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:fileData];
            [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }];
    
    // 添加结束标志
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    return [body copy];
}

/**
 * 根据文件名推断MIME类型
 */
- (NSString *)mimeTypeForFileName:(NSString *)fileName {
    if (!ValidStr(fileName)) {
        return @"application/octet-stream";
    }
    
    NSString *extension = [[fileName pathExtension] lowercaseString];
    
    // MIME类型映射
    NSDictionary *mimeTypes = @{
        // 图片
        @"jpg": @"image/jpeg", @"jpeg": @"image/jpeg", @"png": @"image/png",
        @"gif": @"image/gif", @"bmp": @"image/bmp", @"tiff": @"image/tiff",
        @"tif": @"image/tiff", @"ico": @"image/x-icon", @"svg": @"image/svg+xml",
        @"webp": @"image/webp",
        
        // 文档
        @"pdf": @"application/pdf", @"doc": @"application/msword",
        @"docx": @"application/vnd.openxmlformats-officedocument.wordprocessingml.document",
        @"xls": @"application/vnd.ms-excel",
        @"xlsx": @"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
        @"ppt": @"application/vnd.ms-powerpoint",
        @"pptx": @"application/vnd.openxmlformats-officedocument.presentationml.presentation",
        @"txt": @"text/plain", @"rtf": @"application/rtf", @"csv": @"text/csv",
        
        // 压缩文件
        @"zip": @"application/zip", @"rar": @"application/x-rar-compressed",
        @"7z": @"application/x-7z-compressed", @"tar": @"application/x-tar",
        @"gz": @"application/gzip",
        
        // 音频
        @"mp3": @"audio/mpeg", @"wav": @"audio/wav", @"aac": @"audio/aac",
        @"ogg": @"audio/ogg", @"flac": @"audio/flac", @"m4a": @"audio/mp4",
        
        // 视频
        @"mp4": @"video/mp4", @"mov": @"video/quicktime",
        @"avi": @"video/x-msvideo", @"wmv": @"video/x-ms-wmv",
        @"flv": @"video/x-flv", @"mkv": @"video/x-matroska",
        @"webm": @"video/webm",
        
        // 其他
        @"json": @"application/json", @"xml": @"application/xml",
        @"html": @"text/html", @"htm": @"text/html",
        @"js": @"application/javascript", @"css": @"text/css"
    };
    
    return mimeTypes[extension] ?: @"application/octet-stream";
}

/**
 * 创建普通数据任务
 */
- (NSURLSessionDataTask *)createDataTaskWithRequest:(NSMutableURLRequest *)request
                                       successBlock:(MKIDMNetworkRequestSuccessBlock)successBlock
                                       failureBlock:(MKIDMNetworkRequestFailureBlock)failureBlock {
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    @weakify(self);
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData * _Nullable data,
                                                                    NSURLResponse * _Nullable response,
                                                                    NSError * _Nullable error) {
        @strongify(self);
        [self.requests removeObject:dataTask];
        
        if (error) {
            if (error.code == NSURLErrorCancelled) {
                return; // 取消的任务不回调
            }
            
            NSError *resultError = [self errorWithNetworkError:error];
            moko_dispatch_main_safe(^{
                if (failureBlock) failureBlock(resultError);
            });
            return;
        }
        
        // 处理响应数据
        [self handleResponseData:data
                    successBlock:successBlock
                    failureBlock:failureBlock];
    }];
    
    [self.requests addObject:dataTask];
    [dataTask resume];
    
    return dataTask;
}

/**
 * 处理上传任务完成
 */
- (void)handleUploadTaskCompletion:(NSURLSessionUploadTask *)uploadTask
                              data:(NSData *)data
                          response:(NSURLResponse *)response
                             error:(NSError *)error
                     progressBlock:(MKIDMNetworkUploadProgressBlock)progressBlock
                      successBlock:(MKIDMNetworkRequestSuccessBlock)successBlock
                      failureBlock:(MKIDMNetworkRequestFailureBlock)failureBlock {
    
    // 清除任务和进度回调
    [self.progressBlocks removeObjectForKey:@(uploadTask.taskIdentifier)];
    [self.requests removeObject:uploadTask];
    
    if (error) {
        if (error.code == NSURLErrorCancelled) {
            return; // 取消的任务不回调
        }
        
        NSError *resultError = [self errorWithNetworkError:error];
        moko_dispatch_main_safe(^{
            if (failureBlock) failureBlock(resultError);
        });
        return;
    }
    
    // 处理响应数据
    [self handleResponseData:data
                successBlock:successBlock
                failureBlock:failureBlock];
}

/**
 * 处理响应数据
 */
- (void)handleResponseData:(NSData *)data
              successBlock:(MKIDMNetworkRequestSuccessBlock)successBlock
              failureBlock:(MKIDMNetworkRequestFailureBlock)failureBlock {
    
    if (!data || data.length == 0) {
        NSError *error = [NSError errorWithDomain:@"MKIDMNetWorkRequest"
                                             code:MKIDMNetworkErrorSystemError
                                         userInfo:@{@"errorInfo": @"服务器响应空数据"}];
        moko_dispatch_main_safe(^{
            if (failureBlock) failureBlock(error);
        });
        return;
    }
    
    NSError *jsonError = nil;
    id responseObject = [NSJSONSerialization JSONObjectWithData:data
                                                       options:kNilOptions
                                                         error:&jsonError];
    
    if (jsonError) {
        // JSON解析失败，尝试将原始数据转为字符串
        NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        NSError *error = [NSError errorWithDomain:@"MKIDMNetWorkRequest"
                                             code:MKIDMNetworkErrorSystemError
                                         userInfo:@{
                                             @"errorInfo": @"服务器响应格式错误",
                                             @"rawResponse": responseString ?: @""
                                         }];
        
        moko_dispatch_main_safe(^{
            if (failureBlock) failureBlock(error);
        });
        return;
    }
    
    // ========== 关键修改：统一处理 null 值 ==========
    id safeResponseObject = responseObject;
    if (self.autoRemoveNullValues) {
        safeResponseObject = [self removeNullValuesFromObject:responseObject];
    }
    
    // 处理业务响应（使用处理后的数据）
    [self handleBusinessResponse:safeResponseObject
                    successBlock:successBlock
                    failureBlock:failureBlock];
}

/**
 * 处理业务响应
 */
- (void)handleBusinessResponse:(id)responseObject
                  successBlock:(MKIDMNetworkRequestSuccessBlock)successBlock
                  failureBlock:(MKIDMNetworkRequestFailureBlock)failureBlock {
    
    if (![responseObject isKindOfClass:[NSDictionary class]]) {
        NSError *error = [NSError errorWithDomain:@"MKIDMNetWorkRequest"
                                             code:MKIDMNetworkErrorSystemError
                                         userInfo:@{@"errorInfo": @"服务器响应数据结构错误"}];
        moko_dispatch_main_safe(^{
            if (failureBlock) failureBlock(error);
        });
        return;
    }
    
    NSDictionary *responseDict = (NSDictionary *)responseObject;
    NSNumber *statusCode = responseDict[@"code"];
    
    if (![statusCode isKindOfClass:[NSNumber class]]) {
        NSError *error = [NSError errorWithDomain:@"MKIDMNetWorkRequest"
                                             code:MKIDMNetworkErrorSystemError
                                         userInfo:@{@"errorInfo": @"服务器响应状态码格式错误"}];
        moko_dispatch_main_safe(^{
            if (failureBlock) failureBlock(error);
        });
        return;
    }
    
    NSInteger code = [statusCode integerValue];
    
    // 成功状态码（200）
    if (code == 200) {
        moko_dispatch_main_safe(^{
            if (successBlock) successBlock(responseObject);
        });
        return;
    }
    
    // Token失效处理（401, 403）
    if (code == 401 || code == 403) {
        [[MKIDMUserManager sharedManager] logout];
    }
    
    // 错误信息处理
    NSString *errorMessage = @"网络请求失败";
    if ([responseDict[@"msg"] isKindOfClass:[NSString class]]) {
        errorMessage = responseDict[@"msg"];
    } else if ([responseDict[@"message"] isKindOfClass:[NSString class]]) {
        errorMessage = responseDict[@"message"];
    }
    
    // 如果是OSS相关错误，替换为友好的提示
    if ([errorMessage containsString:@"OSS"] || [errorMessage containsString:@"Access Key"]) {
        errorMessage = @"服务器存储服务异常，请稍后重试";
    }
    
    MKIDMNetworkErrorType errorType = MKIDMNetworkErrorSystemError;
    if (code == 401) {
        errorType = MKIDMNetworkErrorUnauthorized;
    } else if (code == 403) {
        errorType = MKIDMNetworkErrorAuthorizationExpired;
    }
    
    NSError *error = [NSError errorWithDomain:@"MKIDMNetWorkRequest"
                                         code:errorType
                                     userInfo:@{
                                         @"errorInfo": errorMessage,
                                         @"rawResponse": responseDict
                                     }];
    
    moko_dispatch_main_safe(^{
        if (failureBlock) failureBlock(error);
    });
}

/**
 * 转换网络错误
 */
- (NSError *)errorWithNetworkError:(NSError *)error {
    if (!error) {
        return [NSError errorWithDomain:@"MKIDMNetWorkRequest"
                                   code:MKIDMNetworkErrorSystemError
                               userInfo:@{@"errorInfo": @"未知错误"}];
    }
    
    NSString *errorMessage = @"网络请求失败";
    MKIDMNetworkErrorType errorCode = MKIDMNetworkErrorSystemError;
    
    switch (error.code) {
        case NSURLErrorTimedOut:
            errorMessage = @"网络请求超时，请稍后重试";
            errorCode = MKIDMNetworkErrorNetworkTimeout;
            break;
        case NSURLErrorNotConnectedToInternet:
            errorMessage = @"网络连接失败，请检查网络设置";
            errorCode = MKIDMNetworkErrorNetworkUnavailable;
            break;
        case NSURLErrorCannotConnectToHost:
            errorMessage = @"无法连接到服务器";
            break;
        case NSURLErrorNetworkConnectionLost:
            errorMessage = @"网络连接中断，请重试";
            break;
        case NSURLErrorCancelled:
            errorMessage = @"网络请求已取消";
            break;
        case NSURLErrorBadURL:
            errorMessage = @"URL地址格式错误";
            errorCode = MKIDMNetworkErrorInvalidURL;
            break;
        case NSURLErrorUnsupportedURL:
            errorMessage = @"不支持的URL协议";
            break;
        case NSURLErrorCannotFindHost:
            errorMessage = @"找不到服务器";
            break;
        default:
            errorMessage = error.localizedDescription ?: @"网络请求失败";
            break;
    }
    
    return [NSError errorWithDomain:@"MKIDMNetWorkRequest"
                               code:errorCode
                           userInfo:@{@"errorInfo": errorMessage}];
}

/**
 * 构建包含查询参数的URL字符串（兼容处理URL参数）
 */
- (NSString *)buildURLWithBase:(NSString *)baseUrl parameters:(NSDictionary *)parameters {
    NSMutableString *urlString = [NSMutableString stringWithString:baseUrl];
    
    if (parameters.count > 0) {
        [urlString appendString:@"?"];
        
        __block BOOL isFirstParam = YES;
        [parameters enumerateKeysAndObjectsUsingBlock:^(NSString *key, id value, BOOL *stop) {
            // 对key进行URL编码
            NSString *encodedKey = [key stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            
            // 对value进行兼容处理
            NSString *stringValue = [NSString stringWithFormat:@"%@", value];
            NSString *encodedValue = nil;
            
            // 判断是否是URL格式参数
            if ([key.lowercaseString hasSuffix:@"url"] || [key.lowercaseString containsString:@"url"]) {
                // 对URL参数进行兼容编码处理
                encodedValue = [self encodeURLParameterForQuery:stringValue];
            } else {
                // 普通参数使用标准编码
                encodedValue = [stringValue stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            }
            
            if (!isFirstParam) {
                [urlString appendString:@"&"];
            }
            [urlString appendFormat:@"%@=%@", encodedKey, encodedValue];
            
            isFirstParam = NO;
        }];
    }
    
    return [urlString copy];
}

/**
 * 兼容编码URL格式参数的方
 */
- (NSString *)encodeURLParameterForQuery:(NSString *)urlString {
    if (!ValidStr(urlString)) {
        return @"";
    }
    
    // 移除可能已存在的百分号编码
    NSString *decoded = [urlString stringByRemovingPercentEncoding];
    if (decoded) {
        urlString = decoded;
    }
    
    // 使用更宽松的编码字符集：字母数字、冒号、点、减号、下划线
    NSMutableCharacterSet *allowedSet = [NSMutableCharacterSet alphanumericCharacterSet];
    [allowedSet addCharactersInString:@":.-_"];
    
    // 对URL进行编码（这种编码会保留冒号、点、减号、下划线）
    NSString *encoded = [urlString stringByAddingPercentEncodingWithAllowedCharacters:allowedSet];
    
    return encoded;
}

#pragma mark - NSURLSessionTaskDelegate (进度回调)
- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
   didSendBodyData:(int64_t)bytesSent
    totalBytesSent:(int64_t)totalBytesSent
totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend {
    
    if (totalBytesExpectedToSend <= 0) {
        return;
    }
    
    void (^progressBlock)(double) = self.progressBlocks[@(task.taskIdentifier)];
    if (progressBlock) {
        double progress = (double)totalBytesSent / (double)totalBytesExpectedToSend;
        progress = MAX(0.0, MIN(1.0, progress));
        
        moko_dispatch_main_safe(^{
            progressBlock(progress);
        });
    }
}

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didCompleteWithError:(NSError *)error {
    [self.progressBlocks removeObjectForKey:@(task.taskIdentifier)];
}

@end
