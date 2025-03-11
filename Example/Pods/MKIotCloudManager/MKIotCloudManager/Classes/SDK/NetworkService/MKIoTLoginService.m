//
//  MKIoTLoginService.m
//  MKIotCloudManager_Example
//
//  Created by aa on 2025/3/11.
//  Copyright © 2025 lovexiaoxia. All rights reserved.
//

#import "MKIoTLoginService.h"

#import "MKMacroDefines.h"
#import "NSString+MKAdd.h"

#import "MKUrlDefinition.h"

@interface MKIoTLoginService ()

@property (nonatomic, strong)NSURLSessionDataTask *loginTask;

@end

@implementation MKIoTLoginService

+ (instancetype)share {
    static dispatch_once_t t;
    static MKIoTLoginService *service = nil;
    dispatch_once(&t, ^{
        service = [[MKIoTLoginService alloc] init];
    });
    return service;
}

- (void)loginWithUsername:(NSString *)username
                 password:(NSString *)password
                   isHome:(BOOL)isHome
                 sucBlock:(MKNetworkRequestSuccessBlock)sucBlock
                failBlock:(MKNetworkRequestFailureBlock)failBlock {
    if (!ValidStr(username) || !ValidStr(password)) {
        NSError *error = [self errorWithErrorInfo:@"Username and password cannot be empty"
                                           domain:@"login"
                                             code:RESULT_API_PARAMS_EMPTY];
        if (failBlock) {
            failBlock(error);
        }
        return;
    }
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    // 设置请求头
    [sessionManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSString *urlString = (isHome ? MKRequstUrl(@"stage-api/auth/login") : MKTestRequstUrl(@"prod-api/auth/login"));
    NSDictionary *params = @{
        @"username":username,
        @"password":password,
        @"source":@(1)
    };
    @weakify(self);
    self.loginTask = [sessionManager POST:urlString parameters:params headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        @strongify(self);
        [self handleRequestSuccess:responseObject sucBlock:sucBlock failBlock:failBlock];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        @strongify(self);
        [self handleRequestFailed:error failBlock:failBlock];
    }];
}

- (void)cancelLogin {
    if (self.loginTask.state == NSURLSessionTaskStateRunning) { //如果要取消的请求正在运行中，才取消
        [self.loginTask cancel];
    }
}

@end
