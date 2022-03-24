//
//  MKPBFilterByBeaconModel.m
//  MKLoRaWAN-PB_Example
//
//  Created by aa on 2021/11/29.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKPBFilterByBeaconModel.h"

#import "MKMacroDefines.h"

#import "MKPBInterface.h"
#import "MKPBInterface+MKPBConfig.h"

@interface MKPBFilterByBeaconModel ()

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKPBFilterByBeaconModel

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    if (self.pageType == mk_pb_filterByBeaconPageType_beacon) {
        [self readBeaconDataWithSucBlock:sucBlock failedBlock:failedBlock];
        return;
    }
    if (self.pageType == mk_pb_filterByBeaconPageType_MKBeacon) {
        [self readMKBeaconDataWithSucBlock:sucBlock failedBlock:failedBlock];
        return;
    }
    if (self.pageType == mk_pb_filterByBeaconPageType_MKBeaconAcc) {
        [self readMKBeaconAccDataWithSucBlock:sucBlock failedBlock:failedBlock];
        return;
    }
    moko_dispatch_main_safe(^{
        if (sucBlock) {
            sucBlock();
        }
    });
}

- (void)configDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    if (self.pageType == mk_pb_filterByBeaconPageType_beacon) {
        [self configBeaconDataWithSucBlock:sucBlock failedBlock:failedBlock];
        return;
    }
    if (self.pageType == mk_pb_filterByBeaconPageType_MKBeacon) {
        [self configMKBeaconDataWithSucBlock:sucBlock failedBlock:failedBlock];
        return;
    }
    if (self.pageType == mk_pb_filterByBeaconPageType_MKBeaconAcc) {
        [self configMKBeaconAccDataWithSucBlock:sucBlock failedBlock:failedBlock];
        return;
    }
    moko_dispatch_main_safe(^{
        if (sucBlock) {
            sucBlock();
        }
    });
}

#pragma mark - interface

#pragma mark - iBeacon
- (void)readBeaconDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self readBeaconFilterStatus]) {
            [self operationFailedBlockWithMsg:@"Read Filter Status Error" block:failedBlock];
            return;
        }
        if (![self readBeaconFilterMajor]) {
            [self operationFailedBlockWithMsg:@"Read Beacon Major Error" block:failedBlock];
            return;
        }
        if (![self readBeaconFilterMinor]) {
            [self operationFailedBlockWithMsg:@"Read Beacon Minor Error" block:failedBlock];
            return;
        }
        if (![self readBeaconFilterUUID]) {
            [self operationFailedBlockWithMsg:@"Read Beacon UUID Error" block:failedBlock];
            return;
        }
        
        moko_dispatch_main_safe(^{
            if (sucBlock) {
                sucBlock();
            }
        });
    });
}

- (void)configBeaconDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self validParams]) {
            [self operationFailedBlockWithMsg:@"Opps！Save failed. Please check the input characters and try again." block:failedBlock];
            return;
        }
        if (![self configBeaconFilterStatus]) {
            [self operationFailedBlockWithMsg:@"Config Filter Status Error" block:failedBlock];
            return;
        }
        if (![self configBeaconFilterMajor]) {
            [self operationFailedBlockWithMsg:@"Config Beacon Major Error" block:failedBlock];
            return;
        }
        if (![self configBeaconFilterMinor]) {
            [self operationFailedBlockWithMsg:@"Config Beacon Minor Error" block:failedBlock];
            return;
        }
        if (![self configBeaconFilterUUID]) {
            [self operationFailedBlockWithMsg:@"Config Beacon UUID Error" block:failedBlock];
            return;
        }
        
        moko_dispatch_main_safe(^{
            if (sucBlock) {
                sucBlock();
            }
        });
    });
}

- (BOOL)readBeaconFilterStatus {
    __block BOOL success = NO;
    [MKPBInterface pb_readFilterByBeaconStatusWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.isOn = [returnData[@"result"][@"isOn"] boolValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configBeaconFilterStatus {
    __block BOOL success = NO;
    [MKPBInterface pb_configFilterByBeaconStatus:self.isOn sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readBeaconFilterMajor {
    __block BOOL success = NO;
    [MKPBInterface pb_readFilterByBeaconMajorRangeWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        BOOL isOn = [returnData[@"result"][@"isOn"] boolValue];
        if (isOn) {
            self.minMajor = returnData[@"result"][@"minValue"];
            self.maxMajor = returnData[@"result"][@"maxValue"];
        }
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configBeaconFilterMajor {
    __block BOOL success = NO;
    BOOL isOn = ValidStr(self.minMajor);
    NSInteger min = 0;
    if (ValidStr(self.minMajor)) {
        min = [self.minMajor integerValue];
    }
    NSInteger max = 0;
    if (ValidStr(self.maxMajor)) {
        max = [self.maxMajor integerValue];
    }
    [MKPBInterface pb_configFilterByBeaconMajor:isOn minValue:min maxValue:max sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readBeaconFilterMinor {
    __block BOOL success = NO;
    [MKPBInterface pb_readFilterByBeaconMinorRangeWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        BOOL isOn = [returnData[@"result"][@"isOn"] boolValue];
        if (isOn) {
            self.minMinor = returnData[@"result"][@"minValue"];
            self.maxMinor = returnData[@"result"][@"maxValue"];
        }
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configBeaconFilterMinor {
    __block BOOL success = NO;
    BOOL isOn = ValidStr(self.minMinor);
    NSInteger min = 0;
    if (ValidStr(self.minMinor)) {
        min = [self.minMinor integerValue];
    }
    NSInteger max = 0;
    if (ValidStr(self.maxMinor)) {
        max = [self.maxMinor integerValue];
    }
    [MKPBInterface pb_configFilterByBeaconMinor:isOn minValue:min maxValue:max sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readBeaconFilterUUID {
    __block BOOL success = NO;
    [MKPBInterface pb_readFilterByBeaconUUIDWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.uuid = returnData[@"result"][@"uuid"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configBeaconFilterUUID {
    __block BOOL success = NO;
    [MKPBInterface pb_configFilterByBeaconUUID:self.uuid sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

#pragma mark - MKiBeacon
- (void)readMKBeaconDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self readMKBeaconFilterStatus]) {
            [self operationFailedBlockWithMsg:@"Read Filter Status Error" block:failedBlock];
            return;
        }
        if (![self readMKBeaconFilterMajor]) {
            [self operationFailedBlockWithMsg:@"Read Beacon Major Error" block:failedBlock];
            return;
        }
        if (![self readMKBeaconFilterMinor]) {
            [self operationFailedBlockWithMsg:@"Read Beacon Minor Error" block:failedBlock];
            return;
        }
        if (![self readMKBeaconFilterUUID]) {
            [self operationFailedBlockWithMsg:@"Read Beacon UUID Error" block:failedBlock];
            return;
        }
        
        moko_dispatch_main_safe(^{
            if (sucBlock) {
                sucBlock();
            }
        });
    });
}

- (void)configMKBeaconDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self validParams]) {
            [self operationFailedBlockWithMsg:@"Opps！Save failed. Please check the input characters and try again." block:failedBlock];
            return;
        }
        if (![self configMKBeaconFilterStatus]) {
            [self operationFailedBlockWithMsg:@"Config Filter Status Error" block:failedBlock];
            return;
        }
        if (![self configMKBeaconFilterMajor]) {
            [self operationFailedBlockWithMsg:@"Config Beacon Major Error" block:failedBlock];
            return;
        }
        if (![self configMKBeaconFilterMinor]) {
            [self operationFailedBlockWithMsg:@"Config Beacon Minor Error" block:failedBlock];
            return;
        }
        if (![self configMKBeaconFilterUUID]) {
            [self operationFailedBlockWithMsg:@"Config Beacon UUID Error" block:failedBlock];
            return;
        }
        
        moko_dispatch_main_safe(^{
            if (sucBlock) {
                sucBlock();
            }
        });
    });
}

- (BOOL)readMKBeaconFilterStatus {
    __block BOOL success = NO;
    [MKPBInterface pb_readFilterByMKBeaconStatusWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.isOn = [returnData[@"result"][@"isOn"] boolValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configMKBeaconFilterStatus {
    __block BOOL success = NO;
    [MKPBInterface pb_configFilterByMKBeaconStatus:self.isOn sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readMKBeaconFilterMajor {
    __block BOOL success = NO;
    [MKPBInterface pb_readFilterByMKBeaconMajorRangeWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        BOOL isOn = [returnData[@"result"][@"isOn"] boolValue];
        if (isOn) {
            self.minMajor = returnData[@"result"][@"minValue"];
            self.maxMajor = returnData[@"result"][@"maxValue"];
        }
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configMKBeaconFilterMajor {
    __block BOOL success = NO;
    BOOL isOn = ValidStr(self.minMajor);
    NSInteger min = 0;
    if (ValidStr(self.minMajor)) {
        min = [self.minMajor integerValue];
    }
    NSInteger max = 0;
    if (ValidStr(self.maxMajor)) {
        max = [self.maxMajor integerValue];
    }
    [MKPBInterface pb_configFilterByMKBeaconMajor:isOn minValue:min maxValue:max sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readMKBeaconFilterMinor {
    __block BOOL success = NO;
    [MKPBInterface pb_readFilterByMKBeaconMinorRangeWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        BOOL isOn = [returnData[@"result"][@"isOn"] boolValue];
        if (isOn) {
            self.minMinor = returnData[@"result"][@"minValue"];
            self.maxMinor = returnData[@"result"][@"maxValue"];
        }
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configMKBeaconFilterMinor {
    __block BOOL success = NO;
    BOOL isOn = ValidStr(self.minMinor);
    NSInteger min = 0;
    if (ValidStr(self.minMinor)) {
        min = [self.minMinor integerValue];
    }
    NSInteger max = 0;
    if (ValidStr(self.maxMinor)) {
        max = [self.maxMinor integerValue];
    }
    [MKPBInterface pb_configFilterByMKBeaconMinor:isOn minValue:min maxValue:max sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readMKBeaconFilterUUID {
    __block BOOL success = NO;
    [MKPBInterface pb_readFilterByMKBeaconUUIDWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.uuid = returnData[@"result"][@"uuid"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configMKBeaconFilterUUID {
    __block BOOL success = NO;
    [MKPBInterface pb_configFilterByMKBeaconUUID:self.uuid sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

#pragma mark - iBeacon
- (void)readMKBeaconAccDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self readMKBeaconAccFilterStatus]) {
            [self operationFailedBlockWithMsg:@"Read Filter Status Error" block:failedBlock];
            return;
        }
        if (![self readMKBeaconAccFilterMajor]) {
            [self operationFailedBlockWithMsg:@"Read Beacon Major Error" block:failedBlock];
            return;
        }
        if (![self readMKBeaconAccFilterMinor]) {
            [self operationFailedBlockWithMsg:@"Read Beacon Minor Error" block:failedBlock];
            return;
        }
        if (![self readMKBeaconAccFilterUUID]) {
            [self operationFailedBlockWithMsg:@"Read Beacon UUID Error" block:failedBlock];
            return;
        }
        
        moko_dispatch_main_safe(^{
            if (sucBlock) {
                sucBlock();
            }
        });
    });
}

- (void)configMKBeaconAccDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self validParams]) {
            [self operationFailedBlockWithMsg:@"Opps！Save failed. Please check the input characters and try again." block:failedBlock];
            return;
        }
        if (![self configMKBeaconAccFilterStatus]) {
            [self operationFailedBlockWithMsg:@"Config Filter Status Error" block:failedBlock];
            return;
        }
        if (![self configMKBeaconAccFilterMajor]) {
            [self operationFailedBlockWithMsg:@"Config Beacon Major Error" block:failedBlock];
            return;
        }
        if (![self configMKBeaconAccFilterMinor]) {
            [self operationFailedBlockWithMsg:@"Config Beacon Minor Error" block:failedBlock];
            return;
        }
        if (![self configMKBeaconAccFilterUUID]) {
            [self operationFailedBlockWithMsg:@"Config Beacon UUID Error" block:failedBlock];
            return;
        }
        
        moko_dispatch_main_safe(^{
            if (sucBlock) {
                sucBlock();
            }
        });
    });
}

- (BOOL)readMKBeaconAccFilterStatus {
    __block BOOL success = NO;
    [MKPBInterface pb_readFilterByMKBeaconAccStatusWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.isOn = [returnData[@"result"][@"isOn"] boolValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configMKBeaconAccFilterStatus {
    __block BOOL success = NO;
    [MKPBInterface pb_configFilterByMKBeaconAccStatus:self.isOn sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readMKBeaconAccFilterMajor {
    __block BOOL success = NO;
    [MKPBInterface pb_readFilterByMKBeaconAccMajorRangeWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        BOOL isOn = [returnData[@"result"][@"isOn"] boolValue];
        if (isOn) {
            self.minMajor = returnData[@"result"][@"minValue"];
            self.maxMajor = returnData[@"result"][@"maxValue"];
        }
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configMKBeaconAccFilterMajor {
    __block BOOL success = NO;
    BOOL isOn = ValidStr(self.minMajor);
    NSInteger min = 0;
    if (ValidStr(self.minMajor)) {
        min = [self.minMajor integerValue];
    }
    NSInteger max = 0;
    if (ValidStr(self.maxMajor)) {
        max = [self.maxMajor integerValue];
    }
    [MKPBInterface pb_configFilterByMKBeaconAccMajor:isOn minValue:min maxValue:max sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readMKBeaconAccFilterMinor {
    __block BOOL success = NO;
    [MKPBInterface pb_readFilterByMKBeaconAccMinorRangeWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        BOOL isOn = [returnData[@"result"][@"isOn"] boolValue];
        if (isOn) {
            self.minMinor = returnData[@"result"][@"minValue"];
            self.maxMinor = returnData[@"result"][@"maxValue"];
        }
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configMKBeaconAccFilterMinor {
    __block BOOL success = NO;
    BOOL isOn = ValidStr(self.minMinor);
    NSInteger min = 0;
    if (ValidStr(self.minMinor)) {
        min = [self.minMinor integerValue];
    }
    NSInteger max = 0;
    if (ValidStr(self.maxMinor)) {
        max = [self.maxMinor integerValue];
    }
    [MKPBInterface pb_configFilterByMKBeaconAccMinor:isOn minValue:min maxValue:max sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readMKBeaconAccFilterUUID {
    __block BOOL success = NO;
    [MKPBInterface pb_readFilterByMKBeaconAccUUIDWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.uuid = returnData[@"result"][@"uuid"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configMKBeaconAccFilterUUID {
    __block BOOL success = NO;
    [MKPBInterface pb_configFilterByMKBeaconAccUUID:self.uuid sucBlock:^{
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
        NSError *error = [[NSError alloc] initWithDomain:@"filterBeaconParams"
                                                    code:-999
                                                userInfo:@{@"errorInfo":msg}];
        block(error);
    })
}

- (BOOL)validParams {
    if (self.uuid.length > 32 || self.uuid.length % 2 != 0) {
        return NO;
    }
    if (ValidStr(self.minMinor) && !ValidStr(self.maxMinor)) {
        return NO;
    }
    if (!ValidStr(self.minMinor) && ValidStr(self.maxMinor)) {
        return NO;
    }
    if (ValidStr(self.minMinor) && ValidStr(self.maxMinor)) {
        if ([self.minMinor integerValue] < 0 || [self.minMinor integerValue] > 65535) {
            return NO;
        }
        if ([self.maxMinor integerValue] < [self.minMinor integerValue] || [self.maxMinor integerValue] > 65535) {
            return NO;
        }
    }
    
    if (ValidStr(self.minMajor) && !ValidStr(self.maxMajor)) {
        return NO;
    }
    if (!ValidStr(self.minMajor) && ValidStr(self.maxMajor)) {
        return NO;
    }
    if (ValidStr(self.minMajor) && ValidStr(self.maxMajor)) {
        if ([self.minMajor integerValue] < 0 || [self.minMajor integerValue] > 65535) {
            return NO;
        }
        if ([self.maxMajor integerValue] < [self.minMajor integerValue] || [self.maxMajor integerValue] > 65535) {
            return NO;
        }
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
        _readQueue = dispatch_queue_create("filterBeaconQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _readQueue;
}

@end
