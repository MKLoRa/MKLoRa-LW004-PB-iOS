//
//  MKIDMEnvironmentManager.h
//  MKIotDMApp
//
//  Created by aa on 2026/7/8.
//  Copyright © 2026 lovexiaoxia. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, MKIDMEnvironmentType) {
    MKIDMEnvironmentTypeProduction = 0,   // 正式环境
    MKIDMEnvironmentTypeDevelopment,      // 开发/测试环境
};

/// 环境切换通知
extern NSString * const kMKIDMEnvironmentDidChangeNotification;

@interface MKIDMEnvironmentManager : NSObject

/// 单例
+ (instancetype)sharedManager;

/// 消除MKIDMEnvironmentManager单例
+ (void)singleDealloc;

/// 当前环境类型
@property (nonatomic, assign, readonly) MKIDMEnvironmentType currentEnvironment;

/// 当前 Base URL（外部可调用）
@property (nonatomic, copy, readonly) NSString *baseURL;

/// 是否允许切换环境（仅非 Release 允许）
@property (nonatomic, assign, readonly) BOOL canSwitchEnvironment;

/// 切换环境（仅本次运行有效，不保存）
- (void)switchToEnvironment:(MKIDMEnvironmentType)environment;

/// 获取所有环境列表
- (NSArray<NSDictionary *> *)allEnvironments;

/// 重置为默认环境（根据 APP_ENVIRONMENT 配置）
- (void)resetToDefaultEnvironment;

/// 判断是否为 Release 环境
- (BOOL)isReleaseEnvironment;

@end

NS_ASSUME_NONNULL_END
