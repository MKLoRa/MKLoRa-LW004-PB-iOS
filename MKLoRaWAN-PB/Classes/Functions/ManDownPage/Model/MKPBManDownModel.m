//
//  MKPBManDownModel.m
//  MKLoRaWAN-PB_Example
//
//  Created by aa on 2022/3/22.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKPBManDownModel.h"

#import "MKMacroDefines.h"

#import "MKPBInterface.h"
#import "MKPBInterface+MKPBConfig.h"

@interface MKPBManDownModel ()

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKPBManDownModel

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self readDetection]) {
            [self operationFailedBlockWithMsg:@"Read Man Down Detection Error" block:failedBlock];
            return;
        }
        if (![self readTimeout]) {
            [self operationFailedBlockWithMsg:@"Read Detection Timeout Error" block:failedBlock];
            return;
        }
        if (![self readStrategy]) {
            [self operationFailedBlockWithMsg:@"Read Positioning Strategy Error" block:failedBlock];
            return;
        }
        if (![self readInterval]) {
            [self operationFailedBlockWithMsg:@"Read Report Interval Error" block:failedBlock];
            return;
        }
        if (![self readEventStart]) {
            [self operationFailedBlockWithMsg:@"Read Notify Event On Man Down Start Error" block:failedBlock];
            return;
        }
        if (![self readEventEnd]) {
            [self operationFailedBlockWithMsg:@"Read Notify Event On Man Down End Error" block:failedBlock];
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
        if (![self configDetection]) {
            [self operationFailedBlockWithMsg:@"Config Man Down Detection Error" block:failedBlock];
            return;
        }
        if (![self configTimeout]) {
            [self operationFailedBlockWithMsg:@"Config Detection Timeout Error" block:failedBlock];
            return;
        }
        if (![self configStrategy]) {
            [self operationFailedBlockWithMsg:@"Config Positioning Strategy Error" block:failedBlock];
            return;
        }
        if (![self configInterval]) {
            [self operationFailedBlockWithMsg:@"Config Report Interval Error" block:failedBlock];
            return;
        }
        if (![self configEventStart]) {
            [self operationFailedBlockWithMsg:@"Config Notify Event On Man Down Start Error" block:failedBlock];
            return;
        }
        if (![self configEventEnd]) {
            [self operationFailedBlockWithMsg:@"Config Notify Event On Man Down End Error" block:failedBlock];
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
- (BOOL)readDetection {
    __block BOOL success = NO;
    [MKPBInterface pb_readManDownDetectionWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.detection = [returnData[@"result"][@"isOn"] boolValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configDetection {
    __block BOOL success = NO;
    [MKPBInterface pb_configManDownDetection:self.detection sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readTimeout {
    __block BOOL success = NO;
    [MKPBInterface pb_readManDownDetectionTimeoutWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.timeout = returnData[@"result"][@"timeout"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configTimeout {
    __block BOOL success = NO;
    [MKPBInterface pb_configManDownDetectionTimeout:[self.timeout integerValue] sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readStrategy {
    __block BOOL success = NO;
    [MKPBInterface pb_readManDownPositioningStrategyWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.strategy = [returnData[@"result"][@"strategy"] integerValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configStrategy {
    __block BOOL success = NO;
    [MKPBInterface pb_configManDownPositioningStrategy:self.strategy sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readInterval {
    __block BOOL success = NO;
    [MKPBInterface pb_readManDownReportIntervalWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.interval = returnData[@"result"][@"interval"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configInterval {
    __block BOOL success = NO;
    [MKPBInterface pb_configManDownReportInterval:[self.interval integerValue] sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readEventStart {
    __block BOOL success = NO;
    [MKPBInterface pb_readNotifyEventOnManDownStartWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.start = [returnData[@"result"][@"isOn"] boolValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configEventStart {
    __block BOOL success = NO;
    [MKPBInterface pb_configNotifyEventOnManDownStart:self.start sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readEventEnd {
    __block BOOL success = NO;
    [MKPBInterface pb_readNotifyEventOnManDownEndWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.end = [returnData[@"result"][@"isOn"] boolValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configEventEnd {
    __block BOOL success = NO;
    [MKPBInterface pb_configNotifyEventOnManDownEnd:self.end sucBlock:^{
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
        NSError *error = [[NSError alloc] initWithDomain:@"ManDownParams"
                                                    code:-999
                                                userInfo:@{@"errorInfo":msg}];
        block(error);
    })
}

- (BOOL)validParams {
    if (!ValidStr(self.timeout) || [self.timeout integerValue] < 1 || [self.timeout integerValue] > 120) {
        return NO;
    }
    if (!ValidStr(self.interval) || [self.interval integerValue] < 10 || [self.interval integerValue] > 600) {
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
        _readQueue = dispatch_queue_create("ManDownQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _readQueue;
}

@end
