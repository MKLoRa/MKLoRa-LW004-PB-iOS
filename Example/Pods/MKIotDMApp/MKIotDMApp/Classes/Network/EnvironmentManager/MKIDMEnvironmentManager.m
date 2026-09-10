//
//  MKIDMEnvironmentManager.m
//  MKIotDMApp
//
//  Created by aa on 2026/7/8.
//  Copyright © 2026 lovexiaoxia. All rights reserved.
//

#import "MKIDMEnvironmentManager.h"

NSString * const kMKIDMEnvironmentDidChangeNotification = @"kMKIDMEnvironmentDidChangeNotification";

static MKIDMEnvironmentManager *manager = nil;
static dispatch_once_t onceToken;

@interface MKIDMEnvironmentManager ()

@property (nonatomic, assign, readwrite) MKIDMEnvironmentType currentEnvironment;
@property (nonatomic, copy, readwrite) NSString *baseURL;

@end

@implementation MKIDMEnvironmentManager

- (void)dealloc {
    NSLog(@"MKIDMEnvironmentManager销毁");
}

+ (instancetype)sharedManager {
    dispatch_once(&onceToken, ^{
        manager = [[MKIDMEnvironmentManager alloc] init];
        [manager resetToDefaultEnvironment];
    });
    return manager;
}

+ (void)singleDealloc {
    onceToken = 0;
    manager = nil;
}

- (BOOL)canSwitchEnvironment {
    return ![self isReleaseEnvironment];
}

- (BOOL)isReleaseEnvironment {
#if DEBUG
    return NO;
#elif POD_CONFIGURATION_RELEASE
    return YES;
#else
    return NO;
#endif
}

- (void)resetToDefaultEnvironment {
    if ([self isReleaseEnvironment]) {
        self.currentEnvironment = MKIDMEnvironmentTypeProduction;
    } else {
        self.currentEnvironment = MKIDMEnvironmentTypeDevelopment;
    }
    self.baseURL = [self urlForEnvironment:self.currentEnvironment];
}

- (NSString *)urlForEnvironment:(MKIDMEnvironmentType)environment {
    if ([self isReleaseEnvironment]) {
        return @"https://iotdm.mokocloud.com/stage-api";
    }
    switch (environment) {
        case MKIDMEnvironmentTypeDevelopment:
            return @"https://testiotdm.mokocloud.com/prod-api";
        case MKIDMEnvironmentTypeProduction:
            return @"https://iotdm.mokocloud.com/stage-api";
    }
}

- (void)switchToEnvironment:(MKIDMEnvironmentType)environment {
    if (!self.canSwitchEnvironment) {
        return;
    }
    
    if (self.currentEnvironment == environment) {
        return;
    }
    
    self.currentEnvironment = environment;
    self.baseURL = [self urlForEnvironment:environment];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:kMKIDMEnvironmentDidChangeNotification
                                                            object:nil];
    });
}

- (NSArray<NSDictionary *> *)allEnvironments {
    return @[
        @{@"type": @(MKIDMEnvironmentTypeDevelopment), @"name": @"测试环境"},
        @{@"type": @(MKIDMEnvironmentTypeProduction), @"name": @"正式环境"},
    ];
}

@end
