//
//  MKBaseService.h
//  MKIotCloudManager_Example
//
//  Created by aa on 2025/3/4.
//  Copyright © 2025 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MKNetworkDefine.h"

#define PL_ERROR_INFO_KEY   @"errorInfo"
#define PL_ERROR_CODE       @"errorCode"

NS_ASSUME_NONNULL_BEGIN

@interface MKBaseService : NSObject

/**
 *  单例
 */
+ (instancetype)share;

/**
 *  判断网络是否连接
 *
 *  @return YES or NO
 */
+ (BOOL)isConnectNetwork;

/**
 *  根据错误code，得到对应的错误描述信息字符串
 *
 *  @param errorCode 错误code
 *
 *  @return 错误描述信息字符串
 */
+ (NSString *)errorWithCode:(NSInteger)errorCode;

/**
 生产NSError的方法

 @param errorInfo 错误信息
 @param domain    error.domain
 @param code      code码

 @return NSError对象
 */
- (NSError *) errorWithErrorInfo:(NSString *)errorInfo
                          domain:(NSString *)domain
                            code:(NSInteger)code;

/**
 *  请求数据成功的处理
 *
 *  @param dictionary   请求回来的数据
 *  @param requestInfoModel      请求task
 *  @param sucBlock  如果一切正常则会执行该block
 *  @param failBlock 出现其它错误时执行(例如:请求虽然成功,但出现必填参数为空)
 */
- (void)handleRequestSuccess:(NSDictionary *)dictionary
                    sucBlock:(MKNetworkRequestSuccessBlock)sucBlock
                   failBlock:(MKNetworkRequestFailureBlock)failBlock;

/**
 *  请求数据失败后的处理
 *
 *  @param error     请求失败后返回DDError对象
 */
- (void)handleRequestFailed:(NSError *)error failBlock:(MKNetworkRequestFailureBlock)failBlock;

@end

NS_ASSUME_NONNULL_END
