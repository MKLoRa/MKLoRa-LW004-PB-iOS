//
//  MKPBTimingModeModel.m
//  MKLoRaWAN-PB_Example
//
//  Created by aa on 2021/5/24.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKPBTimingModeModel.h"

#import "MKMacroDefines.h"

#import "MKPBInterface.h"
#import "MKPBInterface+MKPBConfig.h"

@implementation MKPBTimingModeTimePointModel
@end

@interface MKPBTimingModeModel ()

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKPBTimingModeModel

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self readStrategy]) {
            [self operationFailedBlockWithMsg:@"Read Positioning Strategy Error" block:failedBlock];
            return;
        }
        if (![self readReportingTimePoint]) {
            [self operationFailedBlockWithMsg:@"Read Reporting Time Point Error" block:failedBlock];
            return;
        }
        moko_dispatch_main_safe(^{
            if (sucBlock) {
                sucBlock();
            }
        });
    });
}

- (void)configData:(NSArray <MKPBTimingModeTimePointModel *>*)pointList
          sucBlock:(void (^)(void))sucBlock
       failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self configStrategy]) {
            [self operationFailedBlockWithMsg:@"Config Positioning Strategy Error" block:failedBlock];
            return;
        }
        if (![self configReportingTimePoint:pointList]) {
            [self operationFailedBlockWithMsg:@"Config Reporting Time Point Error" block:failedBlock];
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
- (BOOL)readStrategy {
    __block BOOL success = NO;
    [MKPBInterface pb_readTimingModePositioningStrategyWithSucBlock:^(id  _Nonnull returnData) {
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
    [MKPBInterface pb_configTimingModePositioningStrategy:self.strategy sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readReportingTimePoint {
    __block BOOL success = NO;
    [MKPBInterface pb_readTimingModeReportingTimePointWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        NSArray *pointList = returnData[@"result"][@"pointList"];
        NSMutableArray *tempList= [NSMutableArray array];
        for (NSInteger i = 0; i < pointList.count; i ++) {
            NSDictionary *params = pointList[i];
            MKPBTimingModeTimePointModel *pointModel = [[MKPBTimingModeTimePointModel alloc] init];
            pointModel.hour = [params[@"hour"] integerValue];
            pointModel.minuteGear = [params[@"minuteGear"] integerValue];
            [tempList addObject:pointModel];
        }
        self.pointList = [NSArray arrayWithArray:tempList];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configReportingTimePoint:(NSArray <MKPBTimingModeTimePointModel *>*)pointList {
    __block BOOL success = NO;
    [MKPBInterface pb_configTimingModeReportingTimePoint:pointList sucBlock:^{
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
        NSError *error = [[NSError alloc] initWithDomain:@"timingModeParams"
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
        _readQueue = dispatch_queue_create("timingModeQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _readQueue;
}

@end
