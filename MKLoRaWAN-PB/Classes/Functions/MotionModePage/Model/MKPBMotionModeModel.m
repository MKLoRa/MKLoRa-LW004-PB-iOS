//
//  MKPBMotionModeModel.m
//  MKLoRaWAN-PB_Example
//
//  Created by aa on 2021/5/24.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKPBMotionModeModel.h"

#import "MKMacroDefines.h"

#import "MKPBInterface.h"
#import "MKPBInterface+MKPBConfig.h"

@implementation MKPBMotionModeEventsModel
@end

@interface MKPBMotionModeModel ()

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKPBMotionModeModel

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self readMotionModeEvents]) {
            [self operationFailedBlockWithMsg:@"Read Motion Mode Events Error" block:failedBlock];
            return;
        }
        if (![self readNumberOfFixOnStart]) {
            [self operationFailedBlockWithMsg:@"Read Number Of Fix On Start Error" block:failedBlock];
            return;
        }
        if (![self readPosStrategyOnStart]) {
            [self operationFailedBlockWithMsg:@"Read Pos-Strategy On Start Error" block:failedBlock];
            return;
        }
        if (![self readReportIntervalInTrip]) {
            [self operationFailedBlockWithMsg:@"Read Report Interval In Trip Error" block:failedBlock];
            return;
        }
        if (![self readPosStrategyInTrip]) {
            [self operationFailedBlockWithMsg:@"Read Pos-Strategy In Trip Error" block:failedBlock];
            return;
        }
        if (![self readTripEndTimeout]) {
            [self operationFailedBlockWithMsg:@"Read Trip End Timeout Error" block:failedBlock];
            return;
        }
        if (![self readNumberOfFixOnEnd]) {
            [self operationFailedBlockWithMsg:@"Read Number Of Fix On End Error" block:failedBlock];
            return;
        }
        if (![self readReportIntervalOnEnd]) {
            [self operationFailedBlockWithMsg:@"Read Report Interval On End Error" block:failedBlock];
            return;
        }
        if (![self readPosStrategyOnEnd]) {
            [self operationFailedBlockWithMsg:@"Read Pos-Strategy On End Error" block:failedBlock];
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
        if (![self configMotionModeEvents]) {
            [self operationFailedBlockWithMsg:@"Config Motion Mode Events Error" block:failedBlock];
            return;
        }
        if (![self configNumberOfFixOnStart]) {
            [self operationFailedBlockWithMsg:@"Config Number Of Fix On Start Error" block:failedBlock];
            return;
        }
        if (![self configPosStrategyOnStart]) {
            [self operationFailedBlockWithMsg:@"Config Pos-Strategy On Start Error" block:failedBlock];
            return;
        }
        if (![self configReportIntervalInTrip]) {
            [self operationFailedBlockWithMsg:@"Config Report Interval In Trip Error" block:failedBlock];
            return;
        }
        if (![self configPosStrategyInTrip]) {
            [self operationFailedBlockWithMsg:@"Config Pos-Strategy In Trip Error" block:failedBlock];
            return;
        }
        if (![self configTripEndTimeout]) {
            [self operationFailedBlockWithMsg:@"Config Trip End Timeout Error" block:failedBlock];
            return;
        }
        if (![self configNumberOfFixOnEnd]) {
            [self operationFailedBlockWithMsg:@"Config Number Of Fix On End Error" block:failedBlock];
            return;
        }
        if (![self configReportIntervalOnEnd]) {
            [self operationFailedBlockWithMsg:@"Config Report Interval On End Error" block:failedBlock];
            return;
        }
        if (![self configPosStrategyOnEnd]) {
            [self operationFailedBlockWithMsg:@"Config Pos-Strategy On End Error" block:failedBlock];
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
- (BOOL)readMotionModeEvents {
    __block BOOL success = NO;
    [MKPBInterface pb_readMotionModeEventsWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.notifyEventOnStart = [returnData[@"result"][@"notifyEventOnStart"] boolValue];
        self.fixOnStart = [returnData[@"result"][@"fixOnStart"] boolValue];
        self.notifyEventInTrip = [returnData[@"result"][@"notifyEventInTrip"] boolValue];
        self.fixInTrip = [returnData[@"result"][@"fixInTrip"] boolValue];
        self.notifyEventOnEnd = [returnData[@"result"][@"notifyEventOnEnd"] boolValue];
        self.fixOnEnd = [returnData[@"result"][@"fixOnEnd"] boolValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configMotionModeEvents {
    __block BOOL success = NO;
    MKPBMotionModeEventsModel *eventModel = [[MKPBMotionModeEventsModel alloc] init];
    eventModel.notifyEventOnStart = self.notifyEventOnStart;
    eventModel.fixOnStart = self.fixOnStart;
    eventModel.notifyEventInTrip = self.notifyEventInTrip;
    eventModel.fixInTrip = self.fixInTrip;
    eventModel.notifyEventOnEnd = self.notifyEventOnEnd;
    eventModel.fixOnEnd = self.fixOnEnd;
    [MKPBInterface pb_configMotionModeEvents:eventModel sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readNumberOfFixOnStart {
    __block BOOL success = NO;
    [MKPBInterface pb_readMotionModeNumberOfFixOnStartWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.numberOfFixOnStart = returnData[@"result"][@"number"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configNumberOfFixOnStart {
    __block BOOL success = NO;
    [MKPBInterface pb_configMotionModeNumberOfFixOnStart:[self.numberOfFixOnStart integerValue] sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readPosStrategyOnStart {
    __block BOOL success = NO;
    [MKPBInterface pb_readMotionModePosStrategyOnStartWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.posStrategyOnStart = [returnData[@"result"][@"strategy"] integerValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configPosStrategyOnStart {
    __block BOOL success = NO;
    [MKPBInterface pb_configMotionModePosStrategyOnStart:self.posStrategyOnStart sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readReportIntervalInTrip {
    __block BOOL success = NO;
    [MKPBInterface pb_readMotionModeReportIntervalInTripWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.reportIntervalInTrip = returnData[@"result"][@"interval"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configReportIntervalInTrip {
    __block BOOL success = NO;
    [MKPBInterface pb_configMotionModeReportIntervalInTrip:[self.reportIntervalInTrip longLongValue] sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readPosStrategyInTrip {
    __block BOOL success = NO;
    [MKPBInterface pb_readMotionModePosStrategyInTripWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.posStrategyInTrip = [returnData[@"result"][@"strategy"] integerValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configPosStrategyInTrip {
    __block BOOL success = NO;
    [MKPBInterface pb_configMotionModePosStrategyInTrip:self.posStrategyInTrip sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readTripEndTimeout {
    __block BOOL success = NO;
    [MKPBInterface pb_readMotionModeTripEndTimeoutWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.tripEndTimeout = returnData[@"result"][@"time"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configTripEndTimeout {
    __block BOOL success = NO;
    [MKPBInterface pb_configMotionModeTripEndTimeout:[self.tripEndTimeout integerValue] sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readNumberOfFixOnEnd {
    __block BOOL success = NO;
    [MKPBInterface pb_readMotionModeNumberOfFixOnEndWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.numberOfFixOnEnd = returnData[@"result"][@"number"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configNumberOfFixOnEnd {
    __block BOOL success = NO;
    [MKPBInterface pb_configMotionModeNumberOfFixOnEnd:[self.numberOfFixOnEnd integerValue] sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readReportIntervalOnEnd {
    __block BOOL success = NO;
    [MKPBInterface pb_readMotionModeReportIntervalOnEndWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.reportIntervalOnEnd = returnData[@"result"][@"interval"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configReportIntervalOnEnd {
    __block BOOL success = NO;
    [MKPBInterface pb_configMotionModeReportIntervalOnEnd:[self.reportIntervalOnEnd integerValue] sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readPosStrategyOnEnd {
    __block BOOL success = NO;
    [MKPBInterface pb_readMotionModePosStrategyOnEndWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.posStrategyOnEnd = [returnData[@"result"][@"strategy"] integerValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configPosStrategyOnEnd {
    __block BOOL success = NO;
    [MKPBInterface pb_configMotionModePosStrategyOnEnd:self.posStrategyOnEnd sucBlock:^{
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
        NSError *error = [[NSError alloc] initWithDomain:@"motionModeParams"
                                                    code:-999
                                                userInfo:@{@"errorInfo":msg}];
        block(error);
    })
}

- (BOOL)validParams {
    if (!ValidStr(self.numberOfFixOnStart) || [self.numberOfFixOnStart integerValue] < 1 || [self.numberOfFixOnStart integerValue] > 255) {
        return NO;
    }
    if (!ValidStr(self.reportIntervalInTrip) || [self.reportIntervalInTrip integerValue] < 10 || [self.reportIntervalInTrip integerValue] > 86400) {
        return NO;
    }
    if (!ValidStr(self.tripEndTimeout) || [self.tripEndTimeout integerValue] < 3 || [self.tripEndTimeout integerValue] > 180) {
        return NO;
    }
    if (!ValidStr(self.numberOfFixOnEnd) || [self.numberOfFixOnEnd integerValue] < 1 || [self.numberOfFixOnEnd integerValue] > 255) {
        return NO;
    }
    if (!ValidStr(self.reportIntervalOnEnd) || [self.reportIntervalOnEnd integerValue] < 10 || [self.reportIntervalOnEnd integerValue] > 300) {
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
        _readQueue = dispatch_queue_create("motionModeQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _readQueue;
}

@end
