//
//  MKBaseService.m
//  MKIotCloudManager_Example
//
//  Created by aa on 2025/3/4.
//  Copyright © 2025 aadyx2007@163.com. All rights reserved.
//

#import "MKBaseService.h"

#import "MKNetworkingStatus.h"

@implementation MKBaseService

+ (instancetype)share{
    static dispatch_once_t t;
    static MKBaseService *service = nil;
    dispatch_once(&t, ^{
        service = [[MKBaseService alloc] init];
    });
    return service;
}

+ (BOOL)isConnectNetwork{
    return [[MKNetworkingStatus sharedNetworkingStatus] netWorkingStatus];
}

- (void)handleRequestSuccess:(NSDictionary *)dictionary
                    sucBlock:(MKNetworkRequestSuccessBlock)sucBlock
                   failBlock:(MKNetworkRequestFailureBlock)failBlock{
    
    //    NSLog(@"成功：requestInfoModel.requestParam==%@",requestInfoModel.requestParam);
    
    if (!dictionary || [[dictionary allKeys] count]==0) {
        if (failBlock) {
            NSError *error = [self errorWithErrorInfo:@"Network error " domain:@"Network error " code:-1];
            failBlock (error);
        }
        return;
    }
    
    NSString *status = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"code"]];
    if ([status isEqualToString:@"200"]) {
        if (dictionary) {
            if (sucBlock){
                sucBlock (dictionary);
            }
        }else{
            if (failBlock) {
                NSError *error = [self errorWithErrorInfo:dictionary[@"msg"] domain:@"Data error" code:RESULT_API_DATA_TYPE_ERROR];
                failBlock (error);
            }
        }
        return;
    }
    
    //其它异常：
    if (dictionary && ([dictionary objectForKey:@"code"] || [dictionary objectForKey:@"msg"])) {
        if (failBlock) {
            NSString *errorMessage = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"msg"]];
            if (!errorMessage || errorMessage.length == 0 || [errorMessage isEqualToString:@"(null)"]) {
                errorMessage = @"Network error ";
            }
            NSError *error = [self errorWithErrorInfo:errorMessage domain:errorMessage code:RESULT_API_DATA_TYPE_ERROR];
            failBlock (error);
            return;
        }
    }
    return;
}

- (void)handleRequestFailed:(NSError *)error failBlock:(MKNetworkRequestFailureBlock)failBlock{
    
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
            NSString *errorInfo = [MKBaseService errorWithCode:error.code];
            customError = [self errorWithErrorInfo:errorInfo domain:error.domain code:error.code];
        }
        failBlock (customError);
    }
}

+ (NSString *)errorWithCode:(NSInteger)errorCode
{
    NSString *err = nil;
    if (errorCode) {
        switch (errorCode) {
            case MKNetworkErrorDefault:
                return @"Get data errpr，please try again.";
                break;
            case MKNetworkErrorTimeOut:
                return @"Request timeout，please try again.";
                break;
            case MKNetworkErrorNoServer:
                return @"Cannot connect the server，please try again.";
                break;
            case MKNetworkErrorNoNetwork:
                return @"Network error ，please check out your network";
                break;
            default:
                return @"Get data errpr，please try again.";
                break;
        }
    }
    return err;
}

- (NSError *) errorWithErrorInfo:(NSString *)errorInfo
                          domain:(NSString *)domain
                            code:(NSInteger)code{
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:errorInfo
                                                         forKey:PL_ERROR_INFO_KEY];
    NSError *resultError = [[NSError alloc] initWithDomain:domain
                                                      code:code
                                                  userInfo:userInfo];
    return resultError;
}

@end
