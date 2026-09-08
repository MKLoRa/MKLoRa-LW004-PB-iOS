//
//  MKIDMAccountService.h
//  MKIotDMApp_Example
//
//  Created by aa on 2025/11/30.
//  Copyright © 2025 lovexiaoxia. All rights reserved.
//

#import "MKIDMBaseService.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKIDMAccountService : MKIDMBaseService

/// 登录接口
/// - Parameters:
///   - username: 用户名
///   - password: 密码
///   - sucBlock: 成功回调
///   - failBlock: 失败回调
- (void)loginWithUsername:(NSString *)username
                 password:(NSString *)password
                 sucBlock:(MKIDMNetworkRequestSuccessBlock)sucBlock
                failBlock:(MKIDMNetworkRequestFailureBlock)failBlock;

/// 取消登录接口请求
- (void)cancelLogin;

/// 退出登录
/// - Parameters:
///   - sucBlock: 成功回调
///   - failBlock: 失败回调
- (void)logoutWithSucBlock:(MKIDMNetworkRequestSuccessBlock)sucBlock
                 failBlock:(MKIDMNetworkRequestFailureBlock)failBlock;

/// 取消退出登录接口请求
- (void)cancelLogout;

/// 获取当前用户信息
/// - Parameters:
///   - sucBlock: 成功回调
///   - failBlock: 失败回调
- (void)getUserInfoWithSucBlock:(MKIDMNetworkRequestSuccessBlock)sucBlock
                      failBlock:(MKIDMNetworkRequestFailureBlock)failBlock;

/// 取消获取当前用户信息接口请求
- (void)cancelGetUserInfo;

/// 修改密码
/// - Parameters:
///   - oldPsd: 旧密码 5~20个字符
///   - newPsd: 新密码 5~20个字符
///   - comfirmPsd: 确定密码 5~20个字符
///   - userId: userId
///   - sucBlock: 成功回调
///   - failBlock: 失败回调
- (void)changePsd:(NSString *)oldPsd
           newPsd:(NSString *)newPsd
       comfirmPsd:(NSString *)comfirmPsd
           userId:(NSInteger)userId
         sucBlock:(MKIDMNetworkRequestSuccessBlock)sucBlock
        failBlock:(MKIDMNetworkRequestFailureBlock)failBlock;

/// 取消修改密码接口请求
- (void)cancelChangePassword;

@end

NS_ASSUME_NONNULL_END
