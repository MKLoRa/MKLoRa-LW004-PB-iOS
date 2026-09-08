//
//  MKIDMUserManager.m
//  MKIotDMApp_Example
//
//  Created by aa on 2025/12/2.
//  Copyright © 2025 lovexiaoxia. All rights reserved.
//

#import "MKIDMUserManager.h"

#import "MKMacroDefines.h"

static MKIDMUserManager *instance = nil;
static dispatch_once_t onceToken;

static NSString *const kUserLoginInfoKey = @"MKIDMUserLoginInfo";

NSString *const kIDMUserLoginSuccessNotification = @"MKIDMUserLoginSuccessNotification";

NSString *const kIDMUserLogoutSuccessNotification = @"MKIDMUserLogoutSuccessNotification";

@implementation MKIDMUserModel

- (NSMutableArray *)permissions {
    if (!_permissions) {
        _permissions = [NSMutableArray array];
    }
    return _permissions;
}

@end

@interface MKIDMUserManager ()

@property (nonatomic, strong) MKIDMUserModel *currentUser;

@end

@implementation MKIDMUserManager

+ (instancetype)sharedManager {
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

+ (void)singleDealloc {
    onceToken = 0;
    instance = nil;
}

#pragma mark - Public Methods

- (BOOL)isLoggedIn {
    return self.currentUser.accessToken.length > 0;
}

- (BOOL)isTokenValid {
    if (!self.isLoggedIn) {
        return NO;
    }
    return [self checkTokenExpired];
}

- (void)handleLoginSuccessWithResponse:(NSDictionary *)response {
    self.currentUser.accessToken = response[@"data"][@"access_token"] ?: @"";
    self.currentUser.expiresIn = [response[@"data"][@"expires_in"] integerValue] ?: 0;
    self.currentUser.loginTime = [NSDate date];
    [self saveUserInfoToStorage];
    moko_dispatch_main_safe(^{
        // 通知登录状态变化
        [[NSNotificationCenter defaultCenter] postNotificationName:kIDMUserLoginSuccessNotification object:nil];
    });
}

- (void)logout {
    self.currentUser = nil;
    moko_dispatch_main_safe(^{
        // 通知登录状态变化
        [[NSNotificationCenter defaultCenter] postNotificationName:kIDMUserLogoutSuccessNotification object:nil];
    });
}

- (void)handleUserInfoWithData:(NSDictionary *)userInfo {
    self.currentUser.username = userInfo[@"user"][@"userName"];
    self.currentUser.userId = [userInfo[@"user"][@"userId"] integerValue];
    self.currentUser.email = userInfo[@"user"][@"email"];
    self.currentUser.createTime = userInfo[@"user"][@"createTime"];
    [self.currentUser.permissions removeAllObjects];
    if (ValidArray(userInfo[@"permissions"])) {
        [self.currentUser.permissions addObjectsFromArray:userInfo[@"permissions"]];
    }
    self.currentUser.permissionPsd = [self.currentUser.permissions containsObject:@"moko:userManagement:password"];
}

- (NSString *)currentToken {
    return self.currentUser.accessToken ?: @"";
}

- (BOOL)checkTokenExpired {
    if (!self.currentUser || !self.currentUser.loginTime) {
        return NO;
    }
    
    // 计算token是否过期（预留5分钟缓冲时间）
    NSTimeInterval elapsedTime = [[NSDate date] timeIntervalSinceDate:self.currentUser.loginTime];
    NSTimeInterval remainingTime = self.currentUser.expiresIn * 60 - elapsedTime; // expires_in是分钟数
    
    return remainingTime > 5 * 60; // 剩余时间大于5分钟则认为有效
}

#pragma mark - Private Methods

- (BOOL)checkTokenExpiredForUser:(MKIDMUserModel *)user {
    if (!user || !user.loginTime) {
        return NO;
    }
    
    NSTimeInterval elapsedTime = [[NSDate date] timeIntervalSinceDate:user.loginTime];
    NSTimeInterval remainingTime = user.expiresIn * 60 - elapsedTime;
    
    return remainingTime > 5 * 60;
}

- (void)saveUserInfoToStorage {
    if (!self.currentUser) {
        return;
    }
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[@"accessToken"] = self.currentUser.accessToken ?: @"";
    userInfo[@"expiresIn"] = @(self.currentUser.expiresIn);
    userInfo[@"loginTime"] = self.currentUser.loginTime;
    userInfo[@"userKey"] = self.currentUser.userKey ?: @"";
    userInfo[@"username"] = self.currentUser.username ?: @"";
    
    [[NSUserDefaults standardUserDefaults] setObject:userInfo forKey:kUserLoginInfoKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)loadUserInfoFromStorage {
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:kUserLoginInfoKey];
    if (!userInfo) {
        return;
    }
    
    MKIDMUserModel *user = [[MKIDMUserModel alloc] init];
    user.accessToken = userInfo[@"accessToken"] ?: @"";
    user.expiresIn = [userInfo[@"expiresIn"] integerValue];
    user.loginTime = userInfo[@"loginTime"];
    user.userKey = userInfo[@"userKey"] ?: @"";
    user.username = userInfo[@"username"] ?: @"";
    
    // 检查token是否过期
    if ([self checkTokenExpiredForUser:user]) {
        self.currentUser = user;
    } else {
        [self clearUserInfoFromStorage];
    }
}

- (void)clearUserInfoFromStorage {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserLoginInfoKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - getter
- (MKIDMUserModel *)currentUser {
    if (!_currentUser) {
        _currentUser = [[MKIDMUserModel alloc] init];
    }
    return _currentUser;
}

@end
