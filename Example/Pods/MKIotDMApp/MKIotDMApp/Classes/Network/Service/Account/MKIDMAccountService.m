//
//  MKIDMAccountService.m
//  MKIotDMApp_Example
//
//  Created by aa on 2025/11/30.
//  Copyright © 2025 lovexiaoxia. All rights reserved.
//

#import "MKIDMAccountService.h"

#import "MKMacroDefines.h"

#import "MKIDMUrlDefinition.h"
#import "MKIDMNetWorkRequest.h"

static dispatch_once_t onceToken;
static MKIDMAccountService *service = nil;

@interface MKIDMAccountService ()

@property (nonatomic, strong)NSURLSessionDataTask *loginTask;

@property (nonatomic, strong)NSURLSessionDataTask *logoutTask;

@property (nonatomic, strong)NSURLSessionDataTask *getUserInfoTask;

@property (nonatomic, strong)NSURLSessionDataTask *changePsdTask;

@end

@implementation MKIDMAccountService

- (void)dealloc {
    NSLog(@"MKIDMAccountService销毁");
}

+ (instancetype)share{
    dispatch_once(&onceToken, ^{
        service = [[MKIDMAccountService alloc] init];
    });
    return service;
}

+ (void)singleDealloc {
    [super singleDealloc];
    onceToken = 0;
    service = nil;
}

#pragma mark - interface method
- (void)loginWithUsername:(NSString *)username
                 password:(NSString *)password
                 sucBlock:(MKIDMNetworkRequestSuccessBlock)sucBlock
                failBlock:(MKIDMNetworkRequestFailureBlock)failBlock {
    if (!ValidStr(username) || !ValidStr(password)) {
        if (failBlock) {
            NSError *error = [self errorWithErrorInfo:@"Params cannot be empty"
                                               domain:@"accountService"
                                                 code:5001];
            failBlock (error);
        }
        return;
    }
    NSString *urlString = MKIDMRequstUrl(@"/auth/login");
    NSDictionary *parameters = @{
        @"username": username,
        @"password": password,
    };
    NSLog(@"%@",urlString);
    @weakify(self);
    self.loginTask = [[MKIDMNetWorkRequest shared] POST:urlString
                                             parameters:parameters
                                           successBlock:^(id returnData) {
        // 网络请求成功，使用基类方法处理业务逻辑
        @strongify(self);
        
        if (sucBlock) {
            sucBlock(returnData);
        }
        self.loginTask = nil;
    }
                                           failureBlock:^(NSError *error) {
        @strongify(self);
        // 网络请求失败，使用基类方法处理错误
        if (failBlock) {
            failBlock(error);
        }
        self.loginTask = nil;
    }];
}

- (void)cancelLogin {
    if (!self.loginTask) {
        return;
    }
    [[MKIDMNetWorkRequest shared] cancelRequest:self.loginTask];
    self.loginTask = nil;
}

- (void)logoutWithSucBlock:(MKIDMNetworkRequestSuccessBlock)sucBlock
                 failBlock:(MKIDMNetworkRequestFailureBlock)failBlock {
    NSString *urlString = MKIDMRequstUrl(@"/auth/logout");
    @weakify(self);
    self.logoutTask = [[MKIDMNetWorkRequest shared] DELETE:urlString
                                                parameters:nil
                                              successBlock:^(id returnData) {
        // 网络请求成功，使用基类方法处理业务逻辑
        @strongify(self);
        
        if (sucBlock) {
            sucBlock(returnData);
        }
        self.logoutTask = nil;
    }
                                              failureBlock:^(NSError *error) {
        @strongify(self);
        // 网络请求失败，使用基类方法处理错误
        if (failBlock) {
            failBlock(error);
        }
        self.logoutTask = nil;
    }];
}

- (void)cancelLogout {
    if (!self.logoutTask) {
        return;
    }
    [[MKIDMNetWorkRequest shared] cancelRequest:self.logoutTask];
    self.logoutTask = nil;
}

- (void)getUserInfoWithSucBlock:(MKIDMNetworkRequestSuccessBlock)sucBlock
                      failBlock:(MKIDMNetworkRequestFailureBlock)failBlock {
    NSString *urlString = MKIDMRequstUrl(@"/system/user/getInfo");
    @weakify(self);
    self.getUserInfoTask = [[MKIDMNetWorkRequest shared] GET:urlString
                                                  parameters:nil
                                                successBlock:^(id returnData) {
        // 网络请求成功，使用基类方法处理业务逻辑
        @strongify(self);
        
        if (sucBlock) {
            sucBlock(returnData);
        }
        self.getUserInfoTask = nil;
    }
                                                failureBlock:^(NSError *error) {
        @strongify(self);
        // 网络请求失败，使用基类方法处理错误
        if (failBlock) {
            failBlock(error);
        }
        self.getUserInfoTask = nil;
    }];
}

- (void)cancelGetUserInfo {
    if (!self.getUserInfoTask) {
        return;
    }
    [[MKIDMNetWorkRequest shared] cancelRequest:self.getUserInfoTask];
    self.getUserInfoTask = nil;
}

- (void)changePsd:(NSString *)oldPsd
           newPsd:(NSString *)newPsd
       comfirmPsd:(NSString *)comfirmPsd
           userId:(NSInteger)userId
         sucBlock:(MKIDMNetworkRequestSuccessBlock)sucBlock
        failBlock:(MKIDMNetworkRequestFailureBlock)failBlock {
    if (!ValidStr(oldPsd) || oldPsd.length < 5 || oldPsd.length > 20) {
        if (failBlock) {
            NSError *error = [self errorWithErrorInfo:@"Old password error"
                                               domain:@"accountService"
                                                 code:5001];
            failBlock (error);
        }
        return;
    }
    if (!ValidStr(newPsd) || newPsd.length < 5 || newPsd.length > 20 || ![newPsd isEqualToString:comfirmPsd]) {
        if (failBlock) {
            NSError *error = [self errorWithErrorInfo:@"Change password error"
                                               domain:@"accountService"
                                                 code:5001];
            failBlock (error);
        }
        return;
    }
    NSString *urlString = MKIDMRequstUrl(@"/mqtt/userManagement/userPasswordChange");
    NSDictionary *parameters = @{
        @"confirmPassword": comfirmPsd,
        @"oldPassword": oldPsd,
        @"password":newPsd,
        @"userId":@(userId)
    };
    @weakify(self);
    self.changePsdTask = [[MKIDMNetWorkRequest shared] POST:urlString
                                                 parameters:parameters
                                               successBlock:^(id returnData) {
        // 网络请求成功，使用基类方法处理业务逻辑
        @strongify(self);
        
        if (sucBlock) {
            sucBlock(returnData);
        }
        self.changePsdTask = nil;
    }
                                               failureBlock:^(NSError *error) {
        @strongify(self);
        // 网络请求失败，使用基类方法处理错误
        if (failBlock) {
            failBlock(error);
        }
        self.changePsdTask = nil;
    }];
}

- (void)cancelChangePassword {
    if (!self.changePsdTask) {
        return;
    }
    [[MKIDMNetWorkRequest shared] cancelRequest:self.changePsdTask];
    self.changePsdTask = nil;
}

@end
