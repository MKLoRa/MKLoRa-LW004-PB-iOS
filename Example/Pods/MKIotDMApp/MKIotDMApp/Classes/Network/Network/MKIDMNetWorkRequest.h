//
//  MKIDMNetWorkRequest.h
//  MKIotDMApp_Example
//
//  Created by aa on 2025/11/25.
//  Copyright © 2025 lovexiaoxia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MKIDMNetworkDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKIDMNetWorkRequest : NSObject

// 单例方法
+ (MKIDMNetWorkRequest *)shared;

/// 单例销毁
+ (void)singleDealloc;

/**
 * 是否自动移除服务端返回的 null 值（默认为 YES）
 * YES: 自动将 NSNull 转换为空字符串，避免取值崩溃
 * NO: 保持原始数据，不做处理
 */
@property (nonatomic, assign) BOOL autoRemoveNullValues;

#pragma mark - 基础网络请求方法
/**
 *  通用网络请求方法（支持 GET/POST/PUT/DELETE）
 *
 *  @param url                请求URL
 *  @param requestType        请求类型（GET/POST/PUT/DELETE）
 *  @param parameters         请求参数
 *  @param successBlock       成功回调
 *  @param failureBlock       失败回调
 *
 *  @return NSURLSessionDataTask 任务对象，可用于取消操作
 */
- (NSURLSessionDataTask *)requestWithURL:(NSString *)url
                                  method:(MKIDMNetworkRequestType)requestType
                         timeoutInterval:(NSTimeInterval)timeoutInterval
                              parameters:(NSDictionary * _Nullable)parameters
                            successBlock:(MKIDMNetworkRequestSuccessBlock)successBlock
                            failureBlock:(MKIDMNetworkRequestFailureBlock)failureBlock;

/**
 *  GET 网络请求
 *
 *  @param url                请求URL
 *  @param parameters         请求参数（会转为URL查询参数）
 *  @param successBlock       成功回调
 *  @param failureBlock       失败回调
 *
 *  @return NSURLSessionDataTask 任务对象
 */
- (NSURLSessionDataTask *)GET:(NSString *)url
                   parameters:(NSDictionary * _Nullable)parameters
                 successBlock:(MKIDMNetworkRequestSuccessBlock)successBlock
                 failureBlock:(MKIDMNetworkRequestFailureBlock)failureBlock;

/**
 *  POST 网络请求（JSON格式）
 *
 *  @param url                请求URL
 *  @param parameters         请求参数（JSON格式）
 *  @param successBlock       成功回调
 *  @param failureBlock       失败回调
 *
 *  @return NSURLSessionDataTask 任务对象
 */
- (NSURLSessionDataTask *)POST:(NSString *)url
                    parameters:(NSDictionary * _Nullable)parameters
                  successBlock:(MKIDMNetworkRequestSuccessBlock)successBlock
                  failureBlock:(MKIDMNetworkRequestFailureBlock)failureBlock;

/**
 *  POST 表单请求（x-www-form-urlencoded格式）
 *
 *  @param url                请求URL
 *  @param parameters         表单参数
 *  @param successBlock       成功回调
 *  @param failureBlock       失败回调
 *
 *  @return NSURLSessionDataTask 任务对象
 */
- (NSURLSessionDataTask *)POSTForm:(NSString *)url
                        parameters:(NSDictionary * _Nullable)parameters
                      successBlock:(MKIDMNetworkRequestSuccessBlock)successBlock
                      failureBlock:(MKIDMNetworkRequestFailureBlock)failureBlock;

#pragma mark - 专门处理参数在URL中的POST请求（解决编码问题）
/**
 * POST请求 - 参数放在URL查询字符串中，body为空（专门解决编码问题）
 * 用于处理那些要求参数在URL中而不是body中的特殊接口
 */
- (NSURLSessionDataTask *)POSTURLParams:(NSString *)url
                             parameters:(NSDictionary *)parameters
                           successBlock:(MKIDMNetworkRequestSuccessBlock)successBlock
                           failureBlock:(MKIDMNetworkRequestFailureBlock)failureBlock;

/**
 *  PUT 网络请求
 *
 *  @param url                请求URL
 *  @param parameters         请求参数（JSON格式）
 *  @param successBlock       成功回调
 *  @param failureBlock       失败回调
 *
 *  @return NSURLSessionDataTask 任务对象
 */
- (NSURLSessionDataTask *)PUT:(NSString *)url
                   parameters:(NSDictionary *)parameters
                 successBlock:(MKIDMNetworkRequestSuccessBlock)successBlock
                 failureBlock:(MKIDMNetworkRequestFailureBlock)failureBlock;

/**
 *  DELETE 网络请求
 *
 *  @param url                请求URL
 *  @param parameters         请求参数（JSON格式）
 *  @param successBlock       成功回调
 *  @param failureBlock       失败回调
 *
 *  @return NSURLSessionDataTask 任务对象
 */
- (NSURLSessionDataTask *)DELETE:(NSString *)url
                      parameters:(NSDictionary * _Nullable)parameters
                    successBlock:(MKIDMNetworkRequestSuccessBlock)successBlock
                    failureBlock:(MKIDMNetworkRequestFailureBlock)failureBlock;

/**
 * POST请求（查询参数，空body）
 * 用于处理特殊的POST接口，参数在URL查询字符串中，请求体为空
 * 这种设计不符合RESTful规范，但某些旧接口可能需要兼容
 *
 * @param url                请求URL
 * @param parameters         查询参数字典
 * @param successBlock       成功回调
 * @param failureBlock       失败回调
 *
 * @return NSURLSessionDataTask 任务对象
 */
- (NSURLSessionDataTask *)POSTWithQueryParams:(NSString *)url
                                   parameters:(NSDictionary * _Nullable)parameters
                                 successBlock:(MKIDMNetworkRequestSuccessBlock)successBlock
                                 failureBlock:(MKIDMNetworkRequestFailureBlock)failureBlock;

/**
 * PUT请求（查询参数，空body）
 * 类似POSTWithQueryParams，用于PUT方法
 *
 * @param url                请求URL
 * @param parameters         查询参数字典
 * @param successBlock       成功回调
 * @param failureBlock       失败回调
 *
 * @return NSURLSessionDataTask 任务对象
 */
- (NSURLSessionDataTask *)PUTWithQueryParams:(NSString *)url
                                  parameters:(NSDictionary * _Nullable)parameters
                                successBlock:(MKIDMNetworkRequestSuccessBlock)successBlock
                                failureBlock:(MKIDMNetworkRequestFailureBlock)failureBlock;

/**
 *  DFU升级专用PUT请求（超时时间5分钟）
 *  专门用于设备固件升级操作，需要较长的超时时间
 *
 *  @param url                升级URL
 *  @param parameters         升级参数（JSON格式）
 *  @param successBlock       成功回调
 *  @param failureBlock       失败回调
 *
 *  @return NSURLSessionDataTask 任务对象
 */
- (NSURLSessionDataTask *)PUTForDFU:(NSString *)url
                         parameters:(NSDictionary * _Nullable)parameters
                       successBlock:(MKIDMNetworkRequestSuccessBlock)successBlock
                       failureBlock:(MKIDMNetworkRequestFailureBlock)failureBlock;

/**
 * DELETE请求（查询参数，空body）
 * 用于处理特殊的DELETE接口，参数在URL查询字符串中，请求体为空
 * 这种设计不符合RESTful规范，但某些旧接口可能需要兼容
 *
 * @param url                请求URL
 * @param parameters         查询参数字典
 * @param successBlock       成功回调
 * @param failureBlock       失败回调
 *
 * @return NSURLSessionDataTask 任务对象
 */
- (NSURLSessionDataTask *)DELETEWithQueryParams:(NSString *)url
                                     parameters:(NSDictionary * _Nullable)parameters
                                   successBlock:(MKIDMNetworkRequestSuccessBlock)successBlock
                                   failureBlock:(MKIDMNetworkRequestFailureBlock)failureBlock;

#pragma mark - 文件上传方法
/**
 *  上传文件（通用方法）
 *
 *  @param url                请求URL
 *  @param parameters         文本参数字典
 *  @param fileData           文件二进制数据
 *  @param fileName           文件名（如：avatar.jpg），可选，默认使用时间戳生成
 *  @param mimeType           文件MIME类型（如：image/jpeg），可选，默认根据文件名推断
 *  @param progressBlock      上传进度回调（0.0 ~ 1.0）
 *  @param successBlock       成功回调
 *  @param failureBlock       失败回调
 *
 *  @return NSURLSessionDataTask 任务对象
 */
- (NSURLSessionDataTask *)uploadFile:(NSString *)url
                          parameters:(NSDictionary * _Nullable)parameters
                            fileData:(NSData *)fileData
                           fileName:(NSString * _Nullable)fileName
                           mimeType:(NSString * _Nullable)mimeType
                       progressBlock:(MKIDMNetworkUploadProgressBlock _Nullable)progressBlock
                        successBlock:(MKIDMNetworkRequestSuccessBlock)successBlock
                        failureBlock:(MKIDMNetworkRequestFailureBlock)failureBlock;

/**
 *  上传图片（便捷方法）
 *
 *  @param url                请求URL
 *  @param parameters         文本参数字典
 *  @param image              要上传的UIImage对象
 *  @param imageName          图片文件名（如：avatar.jpg），可选
 *  @param compressionQuality 图片压缩质量（0.0 ~ 1.0），可选，默认0.8
 *  @param progressBlock      上传进度回调（0.0 ~ 1.0）
 *  @param successBlock       成功回调
 *  @param failureBlock       失败回调
 *
 *  @return NSURLSessionDataTask 任务对象
 */
- (NSURLSessionDataTask *)uploadImage:(NSString *)url
                           parameters:(NSDictionary * _Nullable)parameters
                                image:(UIImage *)image
                            imageName:(NSString * _Nullable)imageName
                    compressionQuality:(CGFloat)compressionQuality
                         progressBlock:(MKIDMNetworkUploadProgressBlock _Nullable)progressBlock
                          successBlock:(MKIDMNetworkRequestSuccessBlock)successBlock
                          failureBlock:(MKIDMNetworkRequestFailureBlock)failureBlock;

/**
 *  上传多张图片
 *
 *  @param url                请求URL
 *  @param parameters         文本参数字典
 *  @param images             图片数组 [UIImage]
 *  @param imageNames         图片文件名数组 [NSString]，可选
 *  @param compressionQuality 图片压缩质量（0.0 ~ 1.0），可选，默认0.8
 *  @param progressBlock      上传进度回调（0.0 ~ 1.0）
 *  @param successBlock       成功回调
 *  @param failureBlock       失败回调
 *
 *  @return NSURLSessionDataTask 任务对象
 */
- (NSURLSessionDataTask *)uploadImages:(NSString *)url
                            parameters:(NSDictionary * _Nullable)parameters
                                images:(NSArray<UIImage *> *)images
                            imageNames:(NSArray<NSString *> * _Nullable)imageNames
                     compressionQuality:(CGFloat)compressionQuality
                          progressBlock:(MKIDMNetworkUploadProgressBlock _Nullable)progressBlock
                           successBlock:(MKIDMNetworkRequestSuccessBlock)successBlock
                           failureBlock:(MKIDMNetworkRequestFailureBlock)failureBlock;

/**
 *  上传多个文件
 *
 *  @param url                请求URL
 *  @param parameters         文本参数字典
 *  @param files              文件数组，每个元素为字典：@{@"data": NSData, @"name": @"file1", @"fileName": @"file1.jpg", @"mimeType": @"image/jpeg"}
 *  @param progressBlock      上传进度回调（0.0 ~ 1.0）
 *  @param successBlock       成功回调
 *  @param failureBlock       失败回调
 *
 *  @return NSURLSessionDataTask 任务对象
 */
- (NSURLSessionDataTask *)uploadMultipleFiles:(NSString *)url
                                   parameters:(NSDictionary * _Nullable)parameters
                                        files:(NSArray<NSDictionary *> *)files
                                progressBlock:(MKIDMNetworkUploadProgressBlock _Nullable)progressBlock
                                 successBlock:(MKIDMNetworkRequestSuccessBlock)successBlock
                                 failureBlock:(MKIDMNetworkRequestFailureBlock)failureBlock;

#pragma mark - 取消请求方法
/**
 *  取消所有网络请求
 */
- (void)cancelAllRequests;

/**
 *  取消指定网络请求
 *
 *  @param task 需要被取消的请求task
 */
- (void)cancelRequest:(NSURLSessionTask *)task;

/**
 *  清空进度回调缓存
 */
- (void)clearProgressBlocks;

@end

NS_ASSUME_NONNULL_END
