//
//  MKPBFilterByMacModel.m
//  MKLoRaWAN-PB_Example
//
//  Created by aa on 2022/3/17.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKPBFilterByMacModel.h"

#import "MKMacroDefines.h"
#import "NSString+MKAdd.h"

#import "MKPBInterface.h"
#import "MKPBInterface+MKPBConfig.h"

@interface MKPBFilterByMacModel ()

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKPBFilterByMacModel

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self readFilterPreciseMatch]) {
            [self operationFailedBlockWithMsg:@"Read Filter Precise Match Error" block:failedBlock];
            return;
        }
        if (![self readReverseFilter]) {
            [self operationFailedBlockWithMsg:@"Read Reverse Filter Error" block:failedBlock];
            return;
        }
        if (![self readMacList]) {
            [self operationFailedBlockWithMsg:@"Read Mac List Error" block:failedBlock];
            return;
        }
        moko_dispatch_main_safe(^{
            if (sucBlock) {
                sucBlock();
            }
        });
    });
}

- (void)configDataWithMacList:(NSArray <NSString *>*)macList
                     sucBlock:(void (^)(void))sucBlock
                  failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self validParams:macList]) {
            [self operationFailedBlockWithMsg:@"Opps！Save failed. Please check the input characters and try again." block:failedBlock];
            return;
        }
        if (![self configFilterPreciseMatch]) {
            [self operationFailedBlockWithMsg:@"Config Filter Precise Match Error" block:failedBlock];
            return;
        }
        if (![self configReverseFilter]) {
            [self operationFailedBlockWithMsg:@"Config Reverse Filter Error" block:failedBlock];
            return;
        }
        if (![self configMacList:macList]) {
            [self operationFailedBlockWithMsg:@"Config Mac List Error" block:failedBlock];
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

- (BOOL)readFilterPreciseMatch {
    __block BOOL success = NO;
    [MKPBInterface pb_readFilterByMacPreciseMatchWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.match = [returnData[@"result"][@"isOn"] boolValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configFilterPreciseMatch {
    __block BOOL success = NO;
    [MKPBInterface pb_configFilterByMacPreciseMatch:self.match sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readReverseFilter {
    __block BOOL success = NO;
    [MKPBInterface pb_readFilterByMacReverseFilterWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.filter = [returnData[@"result"][@"isOn"] boolValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configReverseFilter {
    __block BOOL success = NO;
    [MKPBInterface pb_configFilterByMacReverseFilter:self.filter sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readMacList {
    __block BOOL success = NO;
    [MKPBInterface pb_readFilterMACAddressListWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.macList = returnData[@"result"][@"macList"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configMacList:(NSArray <NSString *>*)list {
    __block BOOL success = NO;
    [MKPBInterface pb_configFilterMACAddressList:list sucBlock:^{
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
        NSError *error = [[NSError alloc] initWithDomain:@"FilterByMacParams"
                                                    code:-999
                                                userInfo:@{@"errorInfo":msg}];
        block(error);
    })
}

- (BOOL)validParams:(NSArray <NSString *>*)macList {
    if (macList.count > 10) {
        return NO;
    }
    for (NSString *mac in macList) {
        if ((mac.length % 2 != 0) || !ValidStr(mac) || mac.length > 12 || ![mac regularExpressions:isHexadecimal]) {
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
        _readQueue = dispatch_queue_create("FilterByMacQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _readQueue;
}

@end
