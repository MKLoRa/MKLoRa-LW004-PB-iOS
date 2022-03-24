//
//  MKPBLoRaAppSettingModel.m
//  MKLoRaWAN-PB_Example
//
//  Created by aa on 2022/3/16.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKPBLoRaAppSettingModel.h"

#import "MKMacroDefines.h"

#import "MKPBInterface.h"
#import "MKPBInterface+MKPBConfig.h"

@interface MKPBLoRaAppSettingModel ()

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKPBLoRaAppSettingModel

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self readTimeSyncInterval]) {
            [self operationFailedBlockWithMsg:@"Read Time Sync Interval Error" block:failedBlock];
            return;
        }
        if (![self readNetworkCheckInterval]) {
            [self operationFailedBlockWithMsg:@"Read Network Check Interval Error" block:failedBlock];
            return;
        }
        moko_dispatch_main_safe(^{
            if (sucBlock) {
                sucBlock();
            }
        });
    });
}

- (void)configDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self validParams]) {
            [self operationFailedBlockWithMsg:@"Opps！Save failed. Please check the input characters and try again." block:failedBlock];
            return;
        }
        if (![self configTimeSyncInterval]) {
            [self operationFailedBlockWithMsg:@"Config Time Sync Interval Error" block:failedBlock];
            return;
        }
        if (![self configNetworkCheckInterval]) {
            [self operationFailedBlockWithMsg:@"Config Network Check Interval Error" block:failedBlock];
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

- (BOOL)readTimeSyncInterval {
    __block BOOL success = NO;
    [MKPBInterface pb_readLorawanTimeSyncIntervalWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.timeSyncInterval = returnData[@"result"][@"interval"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configTimeSyncInterval {
    __block BOOL success = NO;
    [MKPBInterface pb_configTimeSyncInterval:[self.timeSyncInterval integerValue] sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readNetworkCheckInterval {
    __block BOOL success = NO;
    [MKPBInterface pb_readLorawanNetworkCheckIntervalWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.checkInterval = returnData[@"result"][@"interval"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configNetworkCheckInterval {
    __block BOOL success = NO;
    [MKPBInterface pb_configLorawanNetworkCheckInterval:[self.checkInterval integerValue] sucBlock:^{
        success = YES;
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
        NSError *error = [[NSError alloc] initWithDomain:@"LoRaAppSettingParams"
                                                    code:-999
                                                userInfo:@{@"errorInfo":msg}];
        block(error);
    })
}

- (BOOL)validParams {
    if (!ValidStr(self.timeSyncInterval) || [self.timeSyncInterval integerValue] < 0 || [self.timeSyncInterval integerValue] > 255) {
        return NO;
    }
    if (!ValidStr(self.checkInterval) || [self.checkInterval integerValue] < 0 || [self.checkInterval integerValue] > 255) {
        return NO;
    }
    return YES;
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
        _readQueue = dispatch_queue_create("LoRaAppSettingQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _readQueue;
}

@end
