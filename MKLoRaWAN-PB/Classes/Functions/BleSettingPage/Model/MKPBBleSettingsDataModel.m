//
//  MKPBBleSettingsDataModel.m
//  MKLoRaWAN-PB_Example
//
//  Created by aa on 2021/10/21.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKPBBleSettingsDataModel.h"

#import "MKMacroDefines.h"

#import "MKPBInterface.h"
#import "MKPBInterface+MKPBConfig.h"

@interface MKPBBleSettingsDataModel ()

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKPBBleSettingsDataModel

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self readAdvName]) {
            [self operationFailedBlockWithMsg:@"Read Device Name Error" block:failedBlock];
            return;
        }
        if (![self readAdvInterval]) {
            [self operationFailedBlockWithMsg:@"Read Adv Interval Error" block:failedBlock];
            return;
        }
        if (![self readBroadcastTimeout]) {
            [self operationFailedBlockWithMsg:@"Read Broadcast Timeout Error" block:failedBlock];
            return;
        }
        if (![self readNeedPassword]) {
            [self operationFailedBlockWithMsg:@"Read Need Password Error" block:failedBlock];
            return;
        }
        if (![self readTxPower]) {
            [self operationFailedBlockWithMsg:@"Read Tx Power Error" block:failedBlock];
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
        if (![self configAdvName]) {
            [self operationFailedBlockWithMsg:@"Config Device Name Error" block:failedBlock];
            return;
        }
        if (![self configAdvInterval]) {
            [self operationFailedBlockWithMsg:@"Config Adv Interval Error" block:failedBlock];
            return;
        }
        if (![self configBroadcastTimeout]) {
            [self operationFailedBlockWithMsg:@"Config Broadcast Timeout Error" block:failedBlock];
            return;
        }
        if (![self configNeedPassword]) {
            [self operationFailedBlockWithMsg:@"Config Need Password Error" block:failedBlock];
            return;
        }
        if (![self configTxPower]) {
            [self operationFailedBlockWithMsg:@"Config Tx Power Error" block:failedBlock];
            return;
        }
        moko_dispatch_main_safe(^{
            if (sucBlock) {
                sucBlock();
            }
        });
    });
}

#pragma mark - interfae
- (BOOL)readAdvName {
    __block BOOL success = NO;
    [MKPBInterface pb_readDeviceNameWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.advName = returnData[@"result"][@"deviceName"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configAdvName {
    __block BOOL success = NO;
    [MKPBInterface pb_configDeviceName:self.advName sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readAdvInterval {
    __block BOOL success = NO;
    [MKPBInterface pb_readAdvIntervalWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.advInterval = returnData[@"result"][@"interval"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configAdvInterval {
    __block BOOL success = NO;
    [MKPBInterface pb_configAdvInterval:[self.advInterval integerValue] sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readBroadcastTimeout {
    __block BOOL success = NO;
    [MKPBInterface pb_readBroadcastTimeoutWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.timeout = returnData[@"result"][@"timeout"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configBroadcastTimeout {
    __block BOOL success = NO;
    [MKPBInterface pb_configBroadcastTimeout:[self.timeout integerValue] sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readNeedPassword {
    __block BOOL success = NO;
    [MKPBInterface pb_readConnectationNeedPasswordWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.needPassword = [returnData[@"result"][@"need"] boolValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configNeedPassword {
    __block BOOL success = NO;
    [MKPBInterface pb_configNeedPassword:self.needPassword sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readTxPower {
    __block BOOL success = NO;
    [MKPBInterface pb_readTxPowerWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.txPower = [self fetchTxPowerValueString:returnData[@"result"][@"txPower"]];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configTxPower {
    __block BOOL success = NO;
    [MKPBInterface pb_configTxPower:self.txPower sucBlock:^{
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
        NSError *error = [[NSError alloc] initWithDomain:@"BleSettingsParams"
                                                    code:-999
                                                userInfo:@{@"errorInfo":msg}];
        block(error);
    })
}

- (BOOL)validParams {
    if (self.advName.length > 16) {
        return NO;
    }
    if (!ValidStr(self.timeout) || [self.timeout integerValue] < 1 || [self.timeout integerValue] > 60) {
        return NO;
    }
    if (!ValidStr(self.advInterval) || [self.advInterval integerValue] < 1 || [self.advInterval integerValue] > 100) {
        return NO;
    }
    return YES;
}

- (NSInteger)fetchTxPowerValueString:(NSString *)content {
    if ([content isEqualToString:@"-40dBm"]) {
        return 0;
    }
    if ([content isEqualToString:@"-20dBm"]) {
        return 1;
    }
    if ([content isEqualToString:@"-16dBm"]) {
        return 2;
    }
    if ([content isEqualToString:@"-12dBm"]) {
        return 3;
    }
    if ([content isEqualToString:@"-8dBm"]) {
        return 4;
    }
    if ([content isEqualToString:@"-4dBm"]) {
        return 5;
    }
    if ([content isEqualToString:@"0dBm"]) {
        return 6;
    }
    if ([content isEqualToString:@"3dBm"]) {
        return 7;
    }
    if ([content isEqualToString:@"4dBm"]) {
        return 8;
    }
    return 0;
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
        _readQueue = dispatch_queue_create("BleSettingsQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _readQueue;
}

@end
