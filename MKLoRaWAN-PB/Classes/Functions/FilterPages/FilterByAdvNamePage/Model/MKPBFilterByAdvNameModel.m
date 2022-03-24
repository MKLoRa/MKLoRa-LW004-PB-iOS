//
//  MKPBFilterByAdvNameModel.m
//  MKLoRaWAN-PB_Example
//
//  Created by aa on 2022/3/17.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKPBFilterByAdvNameModel.h"

#import "MKMacroDefines.h"
#import "NSString+MKAdd.h"

#import "MKPBInterface.h"
#import "MKPBInterface+MKPBConfig.h"

@interface MKPBFilterByAdvNameModel ()

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKPBFilterByAdvNameModel

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
        if (![self readAdvNameList]) {
            [self operationFailedBlockWithMsg:@"Read Adv Name List Error" block:failedBlock];
            return;
        }
        moko_dispatch_main_safe(^{
            if (sucBlock) {
                sucBlock();
            }
        });
    });
}

- (void)configDataWithNameList:(NSArray <NSString *>*)nameList
                      sucBlock:(void (^)(void))sucBlock
                   failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self validParams:nameList]) {
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
        if (![self configAdvNameList:nameList]) {
            [self operationFailedBlockWithMsg:@"Config Adv Name List Error" block:failedBlock];
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
    [MKPBInterface pb_readFilterByAdvNamePreciseMatchWithSucBlock:^(id  _Nonnull returnData) {
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
    [MKPBInterface pb_configFilterByAdvNamePreciseMatch:self.match sucBlock:^{
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
    [MKPBInterface pb_readFilterByAdvNameReverseFilterWithSucBlock:^(id  _Nonnull returnData) {
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
    [MKPBInterface pb_configFilterByAdvNameReverseFilter:self.filter sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readAdvNameList {
    __block BOOL success = NO;
    [MKPBInterface pb_readFilterAdvNameListWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.nameList = returnData[@"result"][@"nameList"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configAdvNameList:(NSArray <NSString *>*)list {
    __block BOOL success = NO;
    [MKPBInterface pb_configFilterAdvNameList:list sucBlock:^{
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
        NSError *error = [[NSError alloc] initWithDomain:@"FilterByAdvNameParams"
                                                    code:-999
                                                userInfo:@{@"errorInfo":msg}];
        block(error);
    })
}

- (BOOL)validParams:(NSArray <NSString *>*)nameList {
    if (nameList.count > 10) {
        return NO;
    }
    for (NSString *name in nameList) {
        if (!ValidStr(name) || name.length > 20) {
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
        _readQueue = dispatch_queue_create("FilterByAdvNameQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _readQueue;
}

@end
