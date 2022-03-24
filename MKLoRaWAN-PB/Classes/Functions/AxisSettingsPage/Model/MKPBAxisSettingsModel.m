//
//  MKPBAxisSettingsModel.m
//  MKLoRaWAN-PB_Example
//
//  Created by aa on 2022/3/23.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKPBAxisSettingsModel.h"

#import "MKMacroDefines.h"

#import "MKPBInterface.h"
#import "MKPBInterface+MKPBConfig.h"

@interface MKPBAxisSettingsModel ()

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKPBAxisSettingsModel

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self readWakeupThreshold]) {
            [self operationFailedBlockWithMsg:@"Read Wakeup Threshold Errro" block:failedBlock];
            return;
        }
        if (![self readWakeupDuration]) {
            [self operationFailedBlockWithMsg:@"Read Wakeup Duration Error" block:failedBlock];
            return;
        }
        if (![self readMotionThreshold]) {
            [self operationFailedBlockWithMsg:@"Read Motion Threshold Error" block:failedBlock];
            return;
        }
        if (![self readMotionDuration]) {
            [self operationFailedBlockWithMsg:@"Read Motion Duration Error" block:failedBlock];
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
        if (![self configWakeupThreshold]) {
            [self operationFailedBlockWithMsg:@"Config Wakeup Threshold Errro" block:failedBlock];
            return;
        }
        if (![self configWakeupDuration]) {
            [self operationFailedBlockWithMsg:@"Config Wakeup Duration Error" block:failedBlock];
            return;
        }
        if (![self configMotionThreshold]) {
            [self operationFailedBlockWithMsg:@"Config Motion Threshold Error" block:failedBlock];
            return;
        }
        if (![self configMotionDuration]) {
            [self operationFailedBlockWithMsg:@"Config Motion Duration Error" block:failedBlock];
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
- (BOOL)readWakeupThreshold {
    __block BOOL success = NO;
    [MKPBInterface pb_readThreeAxisWakeupThresholdWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.wakeupThreshold = returnData[@"result"][@"threshold"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configWakeupThreshold {
    __block BOOL success = NO;
    [MKPBInterface pb_configThreeAxisWakeupThreshold:[self.wakeupThreshold integerValue] sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readWakeupDuration {
    __block BOOL success = NO;
    [MKPBInterface pb_readThreeAxisWakeupDurationWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.wakeupDuration = returnData[@"result"][@"duration"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configWakeupDuration {
    __block BOOL success = NO;
    [MKPBInterface pb_configThreeAxisWakeupDuration:[self.wakeupDuration integerValue] sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readMotionThreshold {
    __block BOOL success = NO;
    [MKPBInterface pb_readThreeAxisMotionThresholdWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.motionThreshold = returnData[@"result"][@"threshold"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configMotionThreshold {
    __block BOOL success = NO;
    [MKPBInterface pb_configThreeAxisMotionThreshold:[self.motionThreshold integerValue] sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readMotionDuration {
    __block BOOL success = NO;
    [MKPBInterface pb_readThreeAxisMotionDurationWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.motionDuration = returnData[@"result"][@"duration"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configMotionDuration {
    __block BOOL success = NO;
    [MKPBInterface pb_configThreeAxisMotionDuration:[self.motionDuration integerValue] sucBlock:^{
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
        NSError *error = [[NSError alloc] initWithDomain:@"AxisSettingsParams"
                                                    code:-999
                                                userInfo:@{@"errorInfo":msg}];
        block(error);
    })
}

- (BOOL)validParams {
    if (!ValidStr(self.wakeupThreshold) || [self.wakeupThreshold integerValue] < 1 || [self.wakeupThreshold integerValue] > 20) {
        return NO;
    }
    if (!ValidStr(self.wakeupDuration) || [self.wakeupDuration integerValue] < 1 || [self.wakeupDuration integerValue] > 10) {
        return NO;
    }
    if (!ValidStr(self.motionThreshold) || [self.motionThreshold integerValue] < 10 || [self.motionThreshold integerValue] > 250) {
        return NO;
    }
    if (!ValidStr(self.motionDuration) || [self.motionDuration integerValue] < 1 || [self.motionDuration integerValue] > 50) {
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
        _readQueue = dispatch_queue_create("AxisSettingsQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _readQueue;
}

@end
