//
//  MKIDMUserManager.h
//  MKIotDMApp_Example
//
//  Created by aa on 2025/12/2.
//  Copyright © 2025 lovexiaoxia. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString *const kIDMUserLoginSuccessNotification;
extern NSString *const kIDMUserLogoutSuccessNotification;

@interface MKIDMUserModel : NSObject

/// 用户密码
@property (nonatomic, copy)NSString *userKey;

/// 用户名
@property (nonatomic, copy)NSString *username;

/// 当前token
@property (nonatomic, copy)NSString *accessToken;

@property (nonatomic, assign)NSInteger expiresIn;

/// 登录账号的时间
@property (nonatomic, strong)NSDate *loginTime;

/// 当前用户id
@property (nonatomic, assign)NSInteger userId;

/// 权限列表
@property (nonatomic, strong)NSMutableArray *permissions;

/// 是否有修改密码的权限
@property (nonatomic, assign)BOOL permissionPsd;

/// 用户邮箱
@property (nonatomic, copy)NSString *email;

/// 用户创建的时间
@property (nonatomic, copy)NSString *createTime;

@end

@interface MKIDMUserManager : NSObject

@property (nonatomic, strong, readonly, nullable) MKIDMUserModel *currentUser;
@property (nonatomic, assign, readonly) BOOL isLoggedIn;

// 单例
+ (instancetype)sharedManager;

/// 单例销毁
+ (void)singleDealloc;

// 登录成功处理
- (void)handleLoginSuccessWithResponse:(NSDictionary *)response;

// 登出
- (void)logout;

/// 更新当前用户信息
/// - Parameter userInfo: 用户信息
/*
 {
     code = 200;
     msg = "\U64cd\U4f5c\U6210\U529f";
     permissions =     (
         "mqtt:gateway:filter",
         "mqtt:gateway:batch:operation",
         "mqtt:simulation:list",
         "moko:userManagement:password",        //是否有修改密码权限，包含该字段才有
         "mqtt:lora:add",
         "mqtt:gateway:cellular:subscribe",
         "mqtt:gateway:subscribe",
         "mqtt:gateway:rebot",
         "mqtt:device:export",
         "mqtt:gateway:cellular:export",
         "mqtt:gateway:cellular:reset",
         "mqtt:device:create",
         "mqtt:lora:remove",
         "mqtt:simulation:indoorPosition",
         "mqtt:simulation:sensor",
         "mqtt:gateway:delete",
         "mqtt:gateway:cellular:unsubscribe",
         "rssi:index:remove",
         "mqtt:gateway:cellular:delete",
         "mqtt:gateway:cellular:detail",
         "mqtt:gateway:reset",
         "mqtt:device:list",
         "asset:project:list",
         "rssi:index:add",
         "moko:userManagement:edit",
         "mqtt:gateway:create",
         "mqtt:gateway:list",
         "mqtt:lora:list",
         "mqtt:gateway:cellular:list",
         "moko:userManagement:view",
         "mqtt:gateway:cellular:filter",
         "mqtt:gateway:cellular:create",
         "mqtt:device:delete",
         "asset:project:add",
         "mqtt:gateway:unsubscribe",
         "mqtt:gateway:cellular:reboot",
         "moko:userManagement:list",
         "mqtt:gateway:detail"
     );
     roles =     (
         common
     );
     user =     {
         admin = 0;
         avatar = "";
         createBy = Administrator;
         createTime = "2023-05-09 19:40:41";
         delFlag = 0;
         dept =         {
             ancestors = 0;
             children =             (
             );
             deptId = 100;
             deptName = Moko;
             leader = "\U82e5\U4f9d";
             orderNum = 0;
             parentId = 0;
             status = 0;
         };
         deptId = 100;
         email = "329541594@qq.com";
         nickName = "lwz_test";
         phonenumber = 15038370757;
         roles =         (
                         {
                 admin = 0;
                 dataScope = 2;
                 deptCheckStrictly = 0;
                 flag = 0;
                 menuCheckStrictly = 0;
                 roleId = 2;
                 roleKey = common;
                 roleName = "Common Role";
                 roleSort = 2;
                 status = 0;
             }
         );
         sex = 0;
         status = 0;
         userId = 107;
         userName = "lwz_test";
     };
 }
 */
- (void)handleUserInfoWithData:(NSDictionary *)userInfo;

// 获取当前token
- (NSString *)currentToken;

@end

NS_ASSUME_NONNULL_END
