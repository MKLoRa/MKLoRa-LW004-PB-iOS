//
//  MKNormalService.m
//  MKIotCloudManager_Example
//
//  Created by aa on 2025/3/4.
//  Copyright © 2025 aadyx2007@163.com. All rights reserved.
//

#import "MKNormalService.h"

#import "MKMacroDefines.h"
#import "NSString+MKAdd.h"

#import "MKUrlDefinition.h"

@implementation MKUserCreateLoRaDeviceModel

- (NSString *)valid {
    self.macAddress = [self.macAddress stringByReplacingOccurrencesOfString:@":" withString:@""];
    if (![self.macAddress regularExpressions:isHexadecimal] || self.macAddress.length != 12) {
        return @"Mac error";
    }
    self.macAddress = [self.macAddress lowercaseString];
    if (self.deviceType < 0 || self.deviceType > 5) {
        return @"Device type error";
    }
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
    NSString *model = @"20";
    NSString *applicationIdFull = @"LW001_BG";
    NSString *profilesType = @"001";
    if (self.deviceType == 1) {
        //LW004-PB
        model = @"30";
        applicationIdFull = @"LW004_PB_V3";
        profilesType = @"004_PB_V3";
    }else if (self.deviceType == 2) {
        //LW005-MP
        model = @"40";
        applicationIdFull = @"LW005_MP";
        profilesType = @"005_MP";
    }else if (self.deviceType == 3) {
        //LW006
        model = @"45";
        applicationIdFull = @"LW006";
        profilesType = @"006";
    }else if (self.deviceType == 4) {
        //LW007-PIR
        model = @"50";
        applicationIdFull = @"LW007_PIR";
        profilesType = @"007_PIR";
    }else if (self.deviceType == 5) {
        //LW008-MT
        model = @"60";
        applicationIdFull = @"LW008";
        profilesType = @"008";
    }
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


@implementation MKUserCreatScannerProDeviceModel

- (NSString *)valid {
    self.macAddress = [self.macAddress stringByReplacingOccurrencesOfString:@":" withString:@""];
    if (![self.macAddress regularExpressions:isHexadecimal] || self.macAddress.length != 12) {
        return @"Mac error";
    }
    self.macAddress = [self.macAddress lowercaseString];
    
    if (self.deviceType < 0 || self.deviceType > 8) {
        return @"Device type error";
    }
    
    if (!ValidStr(self.macName)) {
        return @"Mac name cannot be empty";
    }
    
    if (!ValidStr(self.publishTopic)) {
        return @"PublishTopic cannot be empty";
    }
    
    if (!ValidStr(self.subscribeTopic)) {
        return @"SubscribeTopic cannot be empty";
    }
    
    if (!ValidStr(self.lastWillTopic)) {
        return @"LastWillTopic cannot be empty";
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
    NSString *model = @"10";
    if (self.deviceType == 1) {
        //MK107
        model = @"20";
    }else if (self.deviceType == 2) {
        //MK110 Plus 01
        model = @"40";
    }else if (self.deviceType == 3) {
        //MKGW-min3 20-D
        model = @"11";
    }else if (self.deviceType == 4) {
        //MK107D Pro-35D
        model = @"30";
    }else if (self.deviceType == 5) {
        //MK110 Plus 02
        model = @"50";
    }else if (self.deviceType == 6) {
        //MK110 Plus 03
        model = @"60";
    }else if (self.deviceType == 7) {
        //MKGW3
        model = @"70";
    }else if (self.deviceType == 8) {
        //MKGW7
        model = @"85";
    }else if (self.deviceType == 9) {
        //MKGW4
        model = @"200";
    }
    return @{
        @"lastWill":self.lastWillTopic,
        @"mac":self.macAddress,
        @"macName":self.macName,
        @"model":model,
        @"publishTopic":self.publishTopic,
        @"subscribeTopic":self.subscribeTopic
    };
}

@end

@interface MKNormalService ()

@property (nonatomic, strong)NSURLSessionDataTask *loginTask;

@property (nonatomic, strong)NSURLSessionDataTask *addLoRaDeviceTask;

@property (nonatomic, strong)NSURLSessionDataTask *addScannerProDeviceTask;

@end

@implementation MKNormalService

+ (instancetype)share {
    static dispatch_once_t t;
    static MKNormalService *service = nil;
    dispatch_once(&t, ^{
        service = [[MKNormalService alloc] init];
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

- (void)addLoRaDeviceToCloud:(MKUserCreateLoRaDeviceModel *)deviceModel
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
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    // 设置请求头
    [sessionManager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [sessionManager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
    
    NSString *urlString = (deviceModel.isHome ? MKRequstUrl(@"stage-api/mqtt/lora/createLoraFromApp") : MKTestRequstUrl(@"prod-api/mqtt/lora/createLoraFromApp"));
    @weakify(self);
    self.addLoRaDeviceTask = [sessionManager POST:urlString parameters:params headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        @strongify(self);
        [self handleRequestSuccess:responseObject sucBlock:sucBlock failBlock:failBlock];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        @strongify(self);
        [self handleRequestFailed:error failBlock:failBlock];
    }];
}

- (void)cancelAddLoRaDevice {
    if (self.addLoRaDeviceTask.state == NSURLSessionTaskStateRunning) { //如果要取消的请求正在运行中，才取消
        [self.addLoRaDeviceTask cancel];
    }
}

- (void)addScannerProDevicesToCloud:(NSArray <MKUserCreatScannerProDeviceModel *>*)deviceList
                             isHome:(BOOL)isHome
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
    
    NSMutableArray *paramList = [NSMutableArray array];
    
    for (MKUserCreatScannerProDeviceModel *deviceModel in deviceList) {
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
        [paramList addObject:params];
    }
    
    
    
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    // 设置请求头
    [sessionManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [sessionManager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
    
    NSString *urlString = (isHome ? MKRequstUrl(@"stage-api/mqtt/mqttgateway/batchAdd") : MKTestRequstUrl(@"prod-api/mqtt/mqttgateway/batchAdd"));
    @weakify(self);
    self.addScannerProDeviceTask = [sessionManager POST:urlString parameters:paramList headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        @strongify(self);
        [self handleRequestSuccess:responseObject sucBlock:sucBlock failBlock:failBlock];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        @strongify(self);
        [self handleRequestFailed:error failBlock:failBlock];
    }];
}

- (void)cancelAddScannerProDevice {
    if (self.addScannerProDeviceTask.state == NSURLSessionTaskStateRunning) { //如果要取消的请求正在运行中，才取消
        [self.addScannerProDeviceTask cancel];
    }
}

@end
