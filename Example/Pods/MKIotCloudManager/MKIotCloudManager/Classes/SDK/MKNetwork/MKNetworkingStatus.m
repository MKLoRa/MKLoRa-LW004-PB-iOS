//
//  MKNetworkingStatus.m
//  MKIotCloudManager_Example
//
//  Created by aa on 2025/3/4.
//  Copyright © 2025 aadyx2007@163.com. All rights reserved.
//

#import "MKNetworkingStatus.h"

#import <SystemConfiguration/SystemConfiguration.h>
#import <netinet/in.h>
#import <arpa/inet.h>

#import "MKMacroDefines.h"

NSString *const MKNetworkingStatusChangedNotification = @"MKNetworkingStatusChangedNotification";

@interface MKNetworkingStatus ()

@property (nonatomic, assign) SCNetworkReachabilityRef reachabilityRef;

@end

@implementation MKNetworkingStatus

+ (MKNetworkingStatus *)sharedNetworkingStatus {
    static MKNetworkingStatus *status = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        status = [[self alloc] init];
    });
    return status;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        // 初始化网络监控
        [self startMonitoring];
    }
    return self;
}

- (void)dealloc {
    // 停止监控并释放资源
    if (_reachabilityRef) {
        SCNetworkReachabilityUnscheduleFromRunLoop(_reachabilityRef, CFRunLoopGetMain(), kCFRunLoopCommonModes);
        CFRelease(_reachabilityRef);
    }
}

#pragma mark - 开始监听网络连接
- (void)startMonitoring {
    // 创建 SCNetworkReachabilityRef
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;

    _reachabilityRef = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr *)&zeroAddress);
    if (!_reachabilityRef) {
        NSLog(@"Failed to create reachability reference");
        return;
    }

    // 设置回调
    SCNetworkReachabilityContext context = {0, (__bridge void *)self, NULL, NULL, NULL};
    if (!SCNetworkReachabilitySetCallback(_reachabilityRef, ReachabilityCallback, &context)) {
        NSLog(@"Failed to set reachability callback");
        CFRelease(_reachabilityRef);
        _reachabilityRef = NULL;
        return;
    }

    // 添加到 RunLoop
    if (!SCNetworkReachabilityScheduleWithRunLoop(_reachabilityRef, CFRunLoopGetMain(), kCFRunLoopCommonModes)) {
        NSLog(@"Failed to schedule reachability");
        CFRelease(_reachabilityRef);
        _reachabilityRef = NULL;
        return;
    }
}

#pragma mark - 网络状态回调
static void ReachabilityCallback(SCNetworkReachabilityRef target, SCNetworkReachabilityFlags flags, void* info) {
    MKNetworkingStatus *networkStatus = (__bridge MKNetworkingStatus *)info;
    [networkStatus handleReachabilityChange:flags];
}

- (void)handleReachabilityChange:(SCNetworkReachabilityFlags)flags {
    MKNetworkReachabilityStatus status = [self networkStatusForFlags:flags];
    if (self.currentNetStatus != status) {
        self.currentNetStatus = status;
        moko_dispatch_main_safe(^{
            [[NSNotificationCenter defaultCenter] postNotificationName:MKNetworkingStatusChangedNotification object:nil];
        });
    }
}

#pragma mark - 获取当前网络状态
- (MKNetworkReachabilityStatus)networkStatusForFlags:(SCNetworkReachabilityFlags)flags {
    if ((flags & kSCNetworkReachabilityFlagsReachable) == 0) {
        return MKNetworkReachabilityStatusNotReachable;
    }

    if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) == 0) {
        return MKNetworkReachabilityStatusReachableViaWiFi;
    }
    if (((flags & kSCNetworkReachabilityFlagsConnectionOnDemand) != 0) ||
        ((flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0)) {
        if ((flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0) {
            return MKNetworkReachabilityStatusReachableViaWiFi;
        }
    }
    if ((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN) {
        return MKNetworkReachabilityStatusReachableViaWWAN;
    }
    return MKNetworkReachabilityStatusUnknown;
}

- (BOOL)netWorkingStatus {
    if (self.currentNetStatus == MKNetworkReachabilityStatusUnknown || self.currentNetStatus == MKNetworkReachabilityStatusNotReachable) {
        return NO;
    }
    return YES;
}

@end
