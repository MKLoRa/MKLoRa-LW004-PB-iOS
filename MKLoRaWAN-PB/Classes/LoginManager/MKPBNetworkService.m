//
//  MKPBNetworkService.m
//  MKLoRaWAN-PB_Example
//
//  Created by aa on 2025/3/11.
//  Copyright © 2025 aadyx2007@163.com. All rights reserved.
//

#import "MKPBNetworkService.h"

#import "MKMacroDefines.h"
#import "NSString+MKAdd.h"

#import "MKUrlDefinition.h"


@implementation MKPBCreateLoRaDeviceModel

- (NSString *)valid {
    self.macAddress = [self.macAddress stringByReplacingOccurrencesOfString:@":" withString:@""];
    if (![self.macAddress regularExpressions:isHexadecimal] || self.macAddress.length != 12) {
        return @"Mac error";
    }
    self.macAddress = [self.macAddress lowercaseString];
    if (ValidStr(self.gwId) && ![self.gwId regularExpressions:isHexadecimal] && self.gwId.length != 16) {
        return @"gwId error";
    }
    if (self.region < 0 || self.region > 5) {
        return @"Region error";
    }
    if (!ValidStr(self.username)) {
        return @"Username cannot be empty";
    }
    return @"";
}

- (NSDictionary *)params {
    NSString *valid = [self valid];
    if (ValidStr(valid)) {
        return @{
            @"error":valid
        };
    }
    NSString *devEui = [NSString stringWithFormat:@"%@%@%@",[self.macAddress substringToIndex:6],@"ffff",[self.macAddress substringFromIndex:6]];
    NSString *model = @"30";
    NSString *applicationIdFull = @"LW004_PB_V3";
    NSString *profilesType = @"004_PB_V3";
    NSString *devName = [NSString stringWithFormat:@"%@_%@",applicationIdFull,[[devEui substringFromIndex:(devEui.length - 4)] uppercaseString]];
    NSString *gwId = SafeStr([self.gwId lowercaseString]);
    NSString *gwName = @"";
    if (ValidStr(self.gwId)) {
        gwName = [NSString stringWithFormat:@"%@_%@",self.username,[[gwId substringFromIndex:(gwId.length - 4)] uppercaseString]];
    }
    NSString *joinEui = @"70b3d57ed0026b87";
    NSString *nwkKey = [@"2b7e151628aed2a6abf7" stringByAppendingFormat:self.macAddress];
    NSString *regionString = @"AS923";
    if (self.region == 1) {
        regionString = @"EU868";
    }else if (self.region == 2) {
        regionString = @"US915_0";
    }else if (self.region == 3) {
        regionString = @"US915_1";
    }else if (self.region == 4) {
        regionString = @"AU915_0";
    }else if (self.region == 5) {
        regionString = @"AU915_1";
    }
    NSString *devProfilesSearch = [NSString stringWithFormat:@"%@_%@",regionString,profilesType];
    
    return @{
        @"devEui":devEui,
        @"model":model,
        @"applicationIdFull":applicationIdFull,
        @"devName":devName,
        @"devDesc":self.username,
        @"gwId":gwId,
        @"gwName":gwName,
        @"gwSearch":gwName,
        @"gwDesc":gwName,
        @"joinEui":joinEui,
        @"nwkKey":nwkKey,
        @"devProfilesSearch":devProfilesSearch,
    };
}

@end

@interface MKPBNetworkService ()

@property (nonatomic, strong)NSURLSessionDataTask *addLoRaDeviceTask;

@end

@implementation MKPBNetworkService

+ (instancetype)share {
    static dispatch_once_t t;
    static MKPBNetworkService *service = nil;
    dispatch_once(&t, ^{
        service = [[MKPBNetworkService alloc] init];
    });
    return service;
}

- (void)addLoRaDeviceToCloud:(MKPBCreateLoRaDeviceModel *)deviceModel
                       token:(NSString *)token
                    sucBlock:(MKNetworkRequestSuccessBlock)sucBlock
                   failBlock:(MKNetworkRequestFailureBlock)failBlock {
    if (!ValidStr(token)) {
        NSError *error = [self errorWithErrorInfo:@"You should login first"
                                           domain:@"addDeviceToCloud"
                                             code:RESULT_API_PARAMS_EMPTY];
        if (failBlock) {
            failBlock(error);
        }
        return;
    }

    NSDictionary *params = [deviceModel params];
    if (ValidStr(params[@"error"])) {
        NSError *error = [self errorWithErrorInfo:params[@"error"]
                                           domain:@"addDeviceToCloud"
                                             code:RESULT_API_PARAMS_EMPTY];
        if (failBlock) {
            failBlock(error);
        }
        return;
    }

    // 创建 URL
    NSString *urlString = (deviceModel.isHome ? MKRequstUrl(@"stage-api/mqtt/lora/createLoraFromApp") : MKTestRequstUrl(@"prod-api/mqtt/lora/createLoraFromApp"));
    NSURL *url = [NSURL URLWithString:urlString];
    if (!url) {
        NSError *error = [self errorWithErrorInfo:@"Invalid URL"
                                           domain:@"addDeviceToCloud"
                                             code:RESULT_API_PARAMS_EMPTY];
        if (failBlock) {
            failBlock(error);
        }
        return;
    }

    // 创建 NSURLRequest
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";

    // 设置请求头
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:token forHTTPHeaderField:@"Authorization"];

    // 设置请求体
    NSMutableString *bodyString = [NSMutableString string];
    for (NSString *key in params) {
        NSString *value = [params[key] description];
        [bodyString appendFormat:@"%@=%@&", key, [value stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    }
    if (bodyString.length > 0) {
        [bodyString deleteCharactersInRange:NSMakeRange(bodyString.length - 1, 1)]; // 删除最后一个 "&"
    }
    request.HTTPBody = [bodyString dataUsingEncoding:NSUTF8StringEncoding];

    // 创建 NSURLSession
    NSURLSession *session = [NSURLSession sharedSession];

    @weakify(self);
    self.addLoRaDeviceTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        @strongify(self);
        if (error) {
            [self handleRequestFailed:error failBlock:failBlock];
            return;
        }

        // 解析响应数据
        NSError *jsonError;
        id responseObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
        if (jsonError) {
            [self handleRequestFailed:jsonError failBlock:failBlock];
            return;
        }

        [self handleRequestSuccess:responseObject sucBlock:sucBlock failBlock:failBlock];
    }];

    // 启动任务
    [self.addLoRaDeviceTask resume];
}

- (void)cancelAddLoRaDevice {
    if (self.addLoRaDeviceTask.state == NSURLSessionTaskStateRunning) { //如果要取消的请求正在运行中，才取消
        [self.addLoRaDeviceTask cancel];
    }
}

@end
