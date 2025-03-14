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
        moko_dispatch_main_safe(^{
            NSError *error = [self errorWithErrorInfo:@"Username and password cannot be empty"
                                               domain:@"login"
                                                 code:RESULT_API_PARAMS_EMPTY];
            if (failBlock) {
                failBlock(error);
            }
        });
        return;
    }
    // 创建 URL
    NSString *urlString = (isHome ? MKRequstUrl(@"stage-api/auth/login") : MKTestRequstUrl(@"prod-api/auth/login"));
    NSURL *url = [NSURL URLWithString:urlString];
    if (!url) {
        moko_dispatch_main_safe(^{
            NSError *error = [self errorWithErrorInfo:@"Invalid URL"
                                               domain:@"login"
                                                 code:RESULT_API_PARAMS_EMPTY];
            if (failBlock) {
                failBlock(error);
            }
        });
        return;
    }

    // 创建请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    // 设置请求体
    NSDictionary *params = @{
        @"username": username,
        @"password": password,
        @"source": @(1)
    };
    NSError *jsonError;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&jsonError];
    if (jsonError) {
        moko_dispatch_main_safe(^{
            if (failBlock) {
                failBlock(jsonError);
            }
        });
        return;
    }
    request.HTTPBody = jsonData;

    // 创建 NSURLSession
    NSURLSession *session = [NSURLSession sharedSession];
    @weakify(self);
    self.loginTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        @strongify(self);
        if (error) {
            [self handleRequestFailed:error failBlock:failBlock];
            return;
        }

        // 解析响应数据
        NSError *jsonParsingError;
        id responseObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonParsingError];
        if (jsonParsingError) {
            [self handleRequestFailed:jsonParsingError failBlock:failBlock];
            return;
        }

        [self handleRequestSuccess:responseObject sucBlock:sucBlock failBlock:failBlock];
    }];

    // 启动任务
    [self.loginTask resume];
}

- (void)cancelLogin {
    if (self.loginTask.state == NSURLSessionTaskStateRunning) { //如果要取消的请求正在运行中，才取消
        [self.loginTask cancel];
    }
}

@end
