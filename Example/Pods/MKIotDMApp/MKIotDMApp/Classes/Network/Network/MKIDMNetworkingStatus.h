//
//  MKIDMNetworkingStatus.h
//  MKIotDMApp
//
//  Created by aa on 2025/11/25.
//  Copyright © 2025 lovexiaoxia. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MKIDMNetworkDefine.h"

NS_ASSUME_NONNULL_BEGIN

extern NSString *const MKIDMNetworkingStatusChangedNotification;

@interface MKIDMNetworkingStatus : NSObject

/**
 *  类单利函数
 *
 *  @return MKIDMNetworkingStatus
 */
+ (MKIDMNetworkingStatus *)shared;

/// 单例销毁
+ (void)singleDealloc;

/**
 MKIDMNetworkReachabilityStatus
 */
@property(nonatomic, assign)MKIDMNetworkReachabilityStatus currentNetStatus;

/**
 *  启动网络状态监测的接口函数
 */
- (void)startMonitoring;

/**
 *  获取当前网络的状态，主要是看是否有网络。
 *
 *  @return 返回值 YES 说明当前网络可用， NO 说明当前网络不可用
 */
- (BOOL)netWorkingStatus;

@end

NS_ASSUME_NONNULL_END
