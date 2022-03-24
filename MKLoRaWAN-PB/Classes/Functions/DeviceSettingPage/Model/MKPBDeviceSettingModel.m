//
//  MKPBDeviceSettingModel.m
//  MKLoRaWAN-PB_Example
//
//  Created by aa on 2022/3/15.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKPBDeviceSettingModel.h"

#import "MKMacroDefines.h"

#import "MKPBInterface.h"

@interface MKPBDeviceSettingModel ()

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKPBDeviceSettingModel

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self readTimeZone]) {
            [self operationFailedBlockWithMsg:@"Read Time Zone Error" block:failedBlock];
            return;
        }
        if (![self readLowPowerPrompt]) {
            [self operationFailedBlockWithMsg:@"Read Low Power Prompt Error" block:failedBlock];
            return;
        }
        if (![self readLowPowerPayload]) {
            [self operationFailedBlockWithMsg:@"Read Low Power Payload Error" block:failedBlock];
            return;
        }
        if (![self readVibrationIntensity]) {
            [self operationFailedBlockWithMsg:@"Read Vibration Intensity Error" block:failedBlock];
            return;
        }
        moko_dispatch_main_safe(^{
            if (sucBlock) {
                sucBlock();
            }
        });
    });
}

#pragma mark - interface
- (BOOL)readTimeZone {
    __block BOOL success = NO;
    [MKPBInterface pb_readTimeZoneWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.timeZone = [returnData[@"result"][@"timeZone"] integerValue] + 24;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readLowPowerPrompt {
    __block BOOL success = NO;
    [MKPBInterface pb_readLowPowerPromptWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        NSInteger value = [returnData[@"result"][@"value"] integerValue];
        if (value > 0 && value <= 10) {
            self.lowPowerPrompt = 0;
        }else if (value > 10 && value <= 20) {
            self.lowPowerPrompt = 1;
        }else if (value > 20 && value <= 30) {
            self.lowPowerPrompt = 2;
        }else if (value > 30 && value <= 40) {
            self.lowPowerPrompt = 3;
        }else if (value > 40 && value <= 50) {
            self.lowPowerPrompt = 4;
        }else if (value > 50 && value <= 60) {
            self.lowPowerPrompt = 5;
        }else {
            self.lowPowerPrompt = 0;
        }
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readLowPowerPayload {
    __block BOOL success = NO;
    [MKPBInterface pb_readLowPowerPayloadWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.payload = [returnData[@"result"][@"isOn"] boolValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readVibrationIntensity {
    __block BOOL success = NO;
    [MKPBInterface pb_readMotorVibrationIntensityWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        NSInteger intensity = [returnData[@"result"][@"intensity"] integerValue];
        if (intensity > 0 && intensity < 10) {
            self.vibrationIntensity = 0;
        }else if (intensity >= 10 && intensity < 50) {
            self.vibrationIntensity = 1;
        }else if (intensity >= 50 && intensity < 80) {
            self.vibrationIntensity = 2;
        }else if (intensity >= 80 && intensity < 100) {
            self.vibrationIntensity = 3;
        }else {
            self.vibrationIntensity = 0;
        }
        
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

#pragma mark - private method
- (void)operationFailedBlockWithMsg:(NSString *)msg block:(void (^)(NSError *error))block {
    moko_dispatch_main_safe(^{
        NSError *error = [[NSError alloc] initWithDomain:@"DeviceSettingParams"
                                                    code:-999
                                                userInfo:@{@"errorInfo":msg}];
        block(error);
    })
}

#pragma mark - getter
- (dispatch_semaphore_t)semaphore {
    if (!_semaphore) {
        _semaphore = dispatch_semaphore_create(0);
    }
    return _semaphore;
}

- (dispatch_queue_t)readQueue {
    if (!_readQueue) {
        _readQueue = dispatch_queue_create("DeviceSettingQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _readQueue;
}

@end
