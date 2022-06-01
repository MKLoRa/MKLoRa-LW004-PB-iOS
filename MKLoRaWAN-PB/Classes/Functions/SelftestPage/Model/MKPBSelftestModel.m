//
//  MKPBSelftestModel.m
//  MKLoRaWAN-PB_Example
//
//  Created by aa on 2022/5/26.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKPBSelftestModel.h"

#import "MKMacroDefines.h"

#import "MKPBInterface.h"

@interface MKPBSelftestModel ()

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKPBSelftestModel
- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self readPCBAStatus]) {
            [self operationFailedBlockWithMsg:@"Read PCBA Status Error" block:failedBlock];
            return;
        }
        if (![self readSelftestStatus]) {
            [self operationFailedBlockWithMsg:@"Read Self Test Status Error" block:failedBlock];
            return;
        }
        moko_dispatch_main_safe(^{
            sucBlock();
        });
    });
}

#pragma mark - interface
- (BOOL)readPCBAStatus {
    __block BOOL success = NO;
    [MKPBInterface pb_readPCBAStatusWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.pcbaStatus = returnData[@"result"][@"status"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readSelftestStatus {
    __block BOOL success = NO;
    [MKPBInterface pb_readSelftestStatusWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.selftestStatus = returnData[@"result"][@"status"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (void)operationFailedBlockWithMsg:(NSString *)msg block:(void (^)(NSError *error))block {
    moko_dispatch_main_safe(^{
        NSError *error = [[NSError alloc] initWithDomain:@"selftest"
                                                    code:-999
                                                userInfo:@{@"errorInfo":msg}];
        block(error);
    });
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
        _readQueue = dispatch_queue_create("selftestQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _readQueue;
}

@end
