//
//  MKPBOnOffSettingsModel.m
//  MKLoRaWAN-PB_Example
//
//  Created by aa on 2022/3/24.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKPBOnOffSettingsModel.h"

#import "MKMacroDefines.h"

#import "MKPBInterface.h"

@interface MKPBOnOffSettingsModel ()

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKPBOnOffSettingsModel

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self readShutDownPayload]) {
            [self operationFailedBlockWithMsg:@"Read Shut-Down Payload Error" block:failedBlock];
            return;
        }
        if (![self readOffByButton]) {
            [self operationFailedBlockWithMsg:@"Read OFF by Button Error" block:failedBlock];
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
- (BOOL)readShutDownPayload {
    __block BOOL success = NO;
    [MKPBInterface pb_readShutDownPayloadStatusWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.payload = [returnData[@"result"][@"isOn"] boolValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readOffByButton {
    __block BOOL success = NO;
    [MKPBInterface pb_readTurnOffDeviceByButtonStatusWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.button = [returnData[@"result"][@"isOn"] boolValue];
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

#pragma mark - private method
- (void)operationFailedBlockWithMsg:(NSString *)msg block:(void (^)(NSError *error))block {
    moko_dispatch_main_safe(^{
        NSError *error = [[NSError alloc] initWithDomain:@"OnOffSettingParams"
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
        _readQueue = dispatch_queue_create("OnOffSettingQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _readQueue;
}

@end
