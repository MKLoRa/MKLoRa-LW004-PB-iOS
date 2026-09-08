//
//  MKIDMLoginManager.h
//  MKIotDMApp_Example
//
//  Created by aa on 2026/7/8.
//  Copyright © 2026 lovexiaoxia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKIDMLoginManager : NSObject

/// 单例
+ (instancetype)sharedManager;

/// 消除MKIDMLoginManager单例
+ (void)singleDealloc;

#pragma mark - 登录相关

/// 显示登录弹窗（无环境切换，壳工程使用）
/// 默认不跳转TabBar，如需跳转请使用带 navigateToTabBar 参数的方法
/// @param presentingVC 当前ViewController
/// @param completion 登录完成回调
- (void)showLoginFromViewController:(UIViewController *)presentingVC
                         completion:(nullable void(^)(void))completion;

/// 显示登录弹窗（无环境切换，壳工程使用）
/// @param presentingVC 当前ViewController
/// @param navigateToTabBar 登录成功后是否自动跳转到TabBar
/// @param completion 登录完成回调
- (void)showLoginFromViewController:(UIViewController *)presentingVC
                   navigateToTabBar:(BOOL)navigateToTabBar
                         completion:(nullable void(^)(void))completion;

/// 显示登录弹窗（带环境切换，子组件使用）
/// 默认不跳转TabBar，如需跳转请使用带 navigateToTabBar 参数的方法
/// @param presentingVC 当前ViewController
/// @param completion 登录完成回调
- (void)showLoginWithEnvFromViewController:(UIViewController *)presentingVC
                                completion:(nullable void(^)(void))completion;

/// 显示登录弹窗（带环境切换，子组件使用）
/// @param presentingVC 当前ViewController
/// @param navigateToTabBar 登录成功后是否自动跳转到TabBar
/// @param completion 登录完成回调
- (void)showLoginWithEnvFromViewController:(UIViewController *)presentingVC
                          navigateToTabBar:(BOOL)navigateToTabBar
                                completion:(nullable void(^)(void))completion;

/// 显示退出确认弹窗
/// @param presentingVC 当前ViewController
/// @param completion 退出完成回调
- (void)showExitAlertFromViewController:(UIViewController *)presentingVC
                              completion:(nullable void(^)(void))completion;

/// 检查是否已登录
@property (nonatomic, assign, readonly) BOOL isLoggedIn;

/// 当前用户信息（字典）
@property (nonatomic, strong, readonly, nullable) NSDictionary *userInfo;

/// 当前 Base URL
@property (nonatomic, copy, readonly) NSString *baseURL;

/// 退出登录（直接退出，不弹窗）
- (void)logout;

#pragma mark - 通用网络请求（自动拼接baseURL，自动携带Token）

/// POST请求
/// @param path 接口路径（如 @"/mqtt/mqttGateway/batchAdd"）
/// @param params 请求参数（字典或数组）
/// @param sucBlock 成功回调
/// @param failBlock 失败回调
- (void)postWithPath:(NSString *)path
              params:(nullable id)params
            sucBlock:(void(^)(id returnData))sucBlock
           failBlock:(void(^)(NSError *error))failBlock;

/// GET请求
/// @param path 接口路径
/// @param params 请求参数
/// @param sucBlock 成功回调
/// @param failBlock 失败回调
- (void)getWithPath:(NSString *)path
             params:(nullable NSDictionary *)params
           sucBlock:(void(^)(id returnData))sucBlock
          failBlock:(void(^)(NSError *error))failBlock;

/// PUT请求
/// @param path 接口路径
/// @param params 请求参数
/// @param sucBlock 成功回调
/// @param failBlock 失败回调
- (void)putWithPath:(NSString *)path
             params:(nullable NSDictionary *)params
           sucBlock:(void(^)(id returnData))sucBlock
          failBlock:(void(^)(NSError *error))failBlock;

/// DELETE请求
/// @param path 接口路径
/// @param params 请求参数
/// @param sucBlock 成功回调
/// @param failBlock 失败回调
- (void)deleteWithPath:(NSString *)path
                params:(nullable NSDictionary *)params
              sucBlock:(void(^)(id returnData))sucBlock
             failBlock:(void(^)(NSError *error))failBlock;

@end

NS_ASSUME_NONNULL_END
