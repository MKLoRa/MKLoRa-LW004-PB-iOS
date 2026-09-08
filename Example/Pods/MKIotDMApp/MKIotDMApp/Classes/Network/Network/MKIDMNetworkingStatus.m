//
//  MKIDMNetworkingStatus.m
//  MKIotDMApp
//
//  Created by aa on 2025/11/25.
//  Copyright © 2025 lovexiaoxia. All rights reserved.
//

#import "MKIDMNetworkingStatus.h"

#import <SystemConfiguration/SystemConfiguration.h>
#import <netinet/in.h>
#import <arpa/inet.h>

static MKIDMNetworkingStatus *status = nil;
static dispatch_once_t onceToken;

NSString *const MKIDMNetworkingStatusChangedNotification = @"MKIDMNetworkingStatusChangedNotification";

@interface MKIDMNetworkingStatus ()

@property (nonatomic, assign) SCNetworkReachabilityRef reachabilityRef;

@end

@implementation MKIDMNetworkingStatus

- (void)dealloc {
    // 停止监控并释放资源
    if (_reachabilityRef) {
        SCNetworkReachabilityUnscheduleFromRunLoop(_reachabilityRef, CFRunLoopGetMain(), kCFRunLoopCommonModes);
        CFRelease(_reachabilityRef);
    }
    NSLog(@"MKIDMNetworkingStatus销毁");
}

+ (MKIDMNetworkingStatus *)shared{
    dispatch_once(&onceToken,^{
        if (!status) {
            status = [[self alloc] init];
        }
    });
    return status;
}

+ (void)singleDealloc {
    onceToken = 0;
    status = nil;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        // 初始化网络监控
        [self startMonitoring];
    }
    return self;
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
    MKIDMNetworkingStatus *networkStatus = (__bridge MKIDMNetworkingStatus *)info;
    [networkStatus handleReachabilityChange:flags];
}

- (void)handleReachabilityChange:(SCNetworkReachabilityFlags)flags {
    MKIDMNetworkReachabilityStatus status = [self networkStatusForFlags:flags];
    if (self.currentNetStatus != status) {
        self.currentNetStatus = status;
        [[NSNotificationCenter defaultCenter] postNotificationName:MKIDMNetworkingStatusChangedNotification object:nil];
    }
}

#pragma mark - 获取当前网络状态
- (MKIDMNetworkReachabilityStatus)networkStatusForFlags:(SCNetworkReachabilityFlags)flags {
    if ((flags & kSCNetworkReachabilityFlagsReachable) == 0) {
        return MKIDMNetworkReachabilityStatusNotReachable;
    }

    if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) == 0) {
        return MKIDMNetworkReachabilityStatusReachableViaWiFi;
    }
    if (((flags & kSCNetworkReachabilityFlagsConnectionOnDemand) != 0) ||
        ((flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0)) {
        if ((flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0) {
            return MKIDMNetworkReachabilityStatusReachableViaWiFi;
        }
    }
    if ((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN) {
        return MKIDMNetworkReachabilityStatusReachableViaWWAN;
    }
    return MKIDMNetworkReachabilityStatusUnknown;
}

- (BOOL)netWorkingStatus {
    if (self.currentNetStatus == MKIDMNetworkReachabilityStatusUnknown || self.currentNetStatus == MKIDMNetworkReachabilityStatusNotReachable) {
        return NO;
    }
    return YES;
}

@end
