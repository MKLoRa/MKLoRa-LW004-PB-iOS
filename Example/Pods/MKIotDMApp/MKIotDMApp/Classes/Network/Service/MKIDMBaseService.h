//
//  MKIDMBaseService.h
//  MKIotDMApp_Example
//
//  Created by aa on 2025/11/25.
//  Copyright © 2025 lovexiaoxia. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MKIDMNetworkDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKIDMBaseService : NSObject

/**
 *  单例
 */
+ (instancetype)share;

/// 单例销毁
+ (void)singleDealloc;

/**
 *  判断网络是否连接
 *
 *  @return YES or NO
 */
+ (BOOL)isConnectNetwork;

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

@end

NS_ASSUME_NONNULL_END
