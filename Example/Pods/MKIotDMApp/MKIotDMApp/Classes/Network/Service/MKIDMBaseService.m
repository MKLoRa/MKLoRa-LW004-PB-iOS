//
//  MKIDMBaseService.m
//  MKIotDMApp_Example
//
//  Created by aa on 2025/11/25.
//  Copyright © 2025 lovexiaoxia. All rights reserved.
//

#import "MKIDMBaseService.h"

#import "MKMacroDefines.h"

#import "MKIDMNetworkingStatus.h"

static MKIDMBaseService *service = nil;
static dispatch_once_t onceToken;

@implementation MKIDMBaseService

- (void)dealloc {
    NSLog(@"MKIDMBaseService销毁");
}

+ (instancetype)share{
    dispatch_once(&onceToken, ^{
        service = [[MKIDMBaseService alloc] init];
    });
    return service;
}

/// 单例销毁
+ (void)singleDealloc {
    onceToken = 0;
    service = nil;
}

+ (BOOL)isConnectNetwork{
    return [[MKIDMNetworkingStatus shared] netWorkingStatus];
}

- (void)handleRequestSuccess:(NSDictionary *)dictionary
                    sucBlock:(MKIDMNetworkRequestSuccessBlock)sucBlock
                   failBlock:(MKIDMNetworkRequestFailureBlock)failBlock{
        
    if (!ValidDict(dictionary)) {
        if (failBlock) {
            NSError *error = [self errorWithErrorInfo:@"Network error " domain:@"BaseService" code:-1];
            failBlock (error);
        }
        return;
    }
    
    NSNumber *status = dictionary[@"code"];
    if ([status integerValue] == 200) {
        if (sucBlock){
            sucBlock (dictionary);
        }
        return;
    }
    if (failBlock) {
        NSString *msg = (ValidStr(dictionary[@"msg"]) ? dictionary[@"msg"] : @"Get data error");
        NSError *error = [self errorWithErrorInfo:msg domain:@"BaseService" code:-10001];
        failBlock (error);
    }
}

- (void)handleRequestFailed:(NSError *)error
                  failBlock:(MKIDMNetworkRequestFailureBlock)failBlock{
    
    //    NSLog(@"失败：requestInfoModel.requestParam==%@",requestInfoModel.requestParam);
    
    if (failBlock) {
        // 用户手动中断请求，一般会在离开界面的时候才会终止,故无需抛出错误
        if (error.code == -999) {
            return;
        }
        
        NSError *customError;
        if (![[self class] isConnectNetwork]) {
            customError = [self errorWithErrorInfo:@"Network request failed，please check out your network" domain:@"" code:-1];
        }else if (error.code == 1){
            customError = [self errorWithErrorInfo:@"Network error " domain:@"" code:-1];
        }else if (error.code == 2){
            customError = [self errorWithErrorInfo:@"Network error " domain:@"" code:-1];
        }else{
            NSString *errorInfo = @"Get data error，please try again.";
            customError = [self errorWithErrorInfo:errorInfo domain:error.domain code:error.code];
        }
        failBlock (customError);
    }
}

- (NSError *) errorWithErrorInfo:(NSString *)errorInfo
                          domain:(NSString *)domain
                            code:(NSInteger)code{
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:errorInfo
                                                         forKey:@"errorInfo"];
    NSError *resultError = [[NSError alloc] initWithDomain:domain
                                                      code:code
                                                  userInfo:userInfo];
    return resultError;
}

@end
