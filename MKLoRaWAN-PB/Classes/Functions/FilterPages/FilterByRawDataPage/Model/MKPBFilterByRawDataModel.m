//
//  MKPBFilterByRawDataModel.m
//  MKLoRaWAN-PB_Example
//
//  Created by aa on 2022/3/18.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKPBFilterByRawDataModel.h"

#import "MKMacroDefines.h"

#import "MKPBInterface.h"

@interface MKPBFilterByRawDataModel ()

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKPBFilterByRawDataModel

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self readFilterByRawDataStatus]) {
            [self operationFailedBlockWithMsg:@"Read Data Error" block:failedBlock];
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

- (BOOL)readFilterByRawDataStatus {
    __block BOOL success = NO;
    [MKPBInterface pb_readFilterTypeStatusWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.other = [returnData[@"result"][@"unknown"] boolValue];
        self.iBeacon = [returnData[@"result"][@"iBeacon"] boolValue];
        self.uid = [returnData[@"result"][@"uid"] boolValue];
        self.url = [returnData[@"result"][@"url"] boolValue];
        self.tlm = [returnData[@"result"][@"tlm"] boolValue];
        self.bxpAcc = [returnData[@"result"][@"bxp_acc"] boolValue];
        self.bxpTH = [returnData[@"result"][@"bxp_th"] boolValue];
        self.mk_iBeacon = [returnData[@"result"][@"mk_iBeacon"] boolValue];
        self.mk_iBeaconAcc = [returnData[@"result"][@"mk_iBeacon_acc"] boolValue];
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
        NSError *error = [[NSError alloc] initWithDomain:@"FilterByRawDataParams"
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
        _readQueue = dispatch_queue_create("FilterByRawDataQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _readQueue;
}

@end
