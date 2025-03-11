//
//  MKIoTLoginService.h
//  MKIotCloudManager_Example
//
//  Created by aa on 2025/3/11.
//  Copyright © 2025 lovexiaoxia. All rights reserved.
//

#import "MKBaseService.h"

#import "MKNetworkDefine.h"
#import "MKNetworkingStatus.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKIoTLoginService : MKBaseService

/// 用户登录服务器
/// - Parameters:
///   - username: 用户名
///   - password: 密码
///   - isHome: YES:正式环境 NO:测试环境
///   - sucBlock: 成功回调
///   - failBlock: 失败回调
- (void)loginWithUsername:(NSString *)username
                 password:(NSString *)password
                   isHome:(BOOL)isHome
                 sucBlock:(MKNetworkRequestSuccessBlock)sucBlock
                failBlock:(MKNetworkRequestFailureBlock)failBlock;

/// 取消调用登陆接口
- (void)cancelLogin;

@end

NS_ASSUME_NONNULL_END
