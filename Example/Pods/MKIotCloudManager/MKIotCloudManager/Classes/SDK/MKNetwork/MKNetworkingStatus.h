//
//  MKNetworkingStatus.h
//  MKIotCloudManager_Example
//
//  Created by aa on 2025/3/4.
//  Copyright © 2025 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AFNetworking/AFNetworking.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString *const MKNetworkingStatusChangedNotification;

@interface MKNetworkingStatus : NSObject

/**
 *  类单利函数
 *
 *  @return MKNetworkingStatus
 */
+ (MKNetworkingStatus *)sharedNetworkingStatus;

/**
 AFNetworkReachabilityStatus
 */
@property(nonatomic, assign)AFNetworkReachabilityStatus currentNetStatus;

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
