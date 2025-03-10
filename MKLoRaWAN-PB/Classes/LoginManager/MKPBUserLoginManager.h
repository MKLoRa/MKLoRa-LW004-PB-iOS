//
//  MKPBUserLoginManager.h
//  MKLoRaWAN-PB_Example
//
//  Created by aa on 2025/3/5.
//  Copyright © 2025 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKPBUserLoginManager : NSObject

/// 使用的是否是正式环境
@property (nonatomic, assign, readonly)BOOL isHome;

/// 登录的用户名
@property (nonatomic, copy, readonly)NSString *username;

/// 登录的密码
@property (nonatomic, copy, readonly)NSString *password;

+ (MKPBUserLoginManager *)shared;

- (void)syncLoginDataWithHome:(BOOL)isHome username:(NSString *)username password:(NSString *)password;

@end

NS_ASSUME_NONNULL_END
