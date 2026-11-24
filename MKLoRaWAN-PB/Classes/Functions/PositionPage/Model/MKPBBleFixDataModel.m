//
//  MKPBBleFixDataModel.m
//  MKLoRaWAN-PB_Example
//
//  Created by aa on 2022/3/16.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKPBBleFixDataModel.h"

#import <UIKit/UIKit.h>

#import "MKMacroDefines.h"

#import "MKPBInterface.h"
#import "MKPBInterface+MKPBConfig.h"

#import "MKFilterByMacController.h"
#import "MKFilterByAdvNameController.h"

#import "MKPBFilterByMacModel.h"
#import "MKPBFilterByAdvNameModel.h"
#import "MKPBFilterByRawDataModel.h"
#import "MKFilterByRawDataController.h"

@interface MKPBBleFixDataModel ()

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKPBBleFixDataModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _pageTitle = @"Bluetooth Fix";
        // PB 硬件不支持 priority / phy，固定默认值
        _priority = 0;
        _phy = 0;
    }
    return self;
}

#pragma mark - MKFilterBleFixProtocol: section0 TextField 回调

- (void)timeoutTextFieldValueChanged:(NSString *)value {
    self.timeout = value;
}

- (void)numberOfMACTextFieldValueChanged:(NSString *)value {
    self.number = value;
}

#pragma mark - MKFilterBleFixProtocol: section1 FilterRelationship（priority / phy）

- (NSArray<NSString *> *)priorityDataList {
    // PB 硬件不支持，返回单选项
    return @[@"Time Priority"];
}

- (NSArray<NSString *> *)phyDataList {
    // PB 硬件不支持，返回单选项
    return @[@"1M PHY(BLE 4.x)"];
}

- (void)priorityChanged:(NSInteger)dataListIndex {
    self.priority = dataListIndex;
}

- (void)phyChanged:(NSInteger)dataListIndex {
    self.phy = dataListIndex;
}

#pragma mark - MKFilterBleFixProtocol: section2 Slider 回调

- (void)rssiSliderValueChanged:(NSInteger)value {
    self.rssi = value;
}

#pragma mark - MKFilterBleFixProtocol: section3 FilterRelationship

- (NSArray<NSString *> *)relationshipDataList {
    return @[@"Null", @"Only MAC", @"Only ADV Name", @"Only Raw Data",
             @"ADV Name & Raw Data", @"MAC & ADV Name & Raw Data", @"ADV Name | Raw Data"];
}

- (void)relationshipChanged:(NSInteger)dataListIndex {
    self.relationship = dataListIndex;
}

#pragma mark - MKFilterBleFixProtocol: section4 push 子 Controller

- (void)pushFilterByMACControllerWithNav:(UINavigationController *)nav {
    MKFilterByMacController *vc = [[MKFilterByMacController alloc] init];
    MKPBFilterByMacModel *model = [[MKPBFilterByMacModel alloc] init];
    model.pageTitle = @"Filter by MAC";
    vc.protocol = model;
    [nav pushViewController:vc animated:YES];
}

- (void)pushFilterByAdvNameControllerWithNav:(UINavigationController *)nav {
    MKFilterByAdvNameController *vc = [[MKFilterByAdvNameController alloc] init];
    MKPBFilterByAdvNameModel *model = [[MKPBFilterByAdvNameModel alloc] init];
    model.pageTitle = @"Filter by ADV Name";
    vc.protocol = model;
    [nav pushViewController:vc animated:YES];
}

- (void)pushFilterByRawDataControllerWithNav:(UINavigationController *)nav {
    MKPBFilterByRawDataModel *model = [[MKPBFilterByRawDataModel alloc] init];
    MKFilterByRawDataController *vc = [[MKFilterByRawDataController alloc] initWithProtocol:model];
    [nav pushViewController:vc animated:YES];
}

#pragma mark - MKFilterBleFixProtocol: section5 payload（PB 不支持）

- (BOOL)hasPayloadContentsSection {
    return NO;
}

- (NSString *)payloadContentsTitle {
    return @"";
}

- (void)pushPayloadContentsControllerWithNav:(UINavigationController *)nav {
    // PB 不支持，不做任何操作
}

#pragma mark - MKFilterBleFixProtocol: 核心 read / config

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self readBlePositioningTimeout]) {
            [self operationFailedBlockWithMsg:@"Read Timeout Error" block:failedBlock];
            return;
        }
        if (![self readBlePositioningMac]) {
            [self operationFailedBlockWithMsg:@"Read Number Error" block:failedBlock];
            return;
        }
        if (![self readFilterRssi]) {
            [self operationFailedBlockWithMsg:@"Read Filter Rssi Error" block:failedBlock];
            return;
        }
        if (![self readFilterRelationship]) {
            [self operationFailedBlockWithMsg:@"Read Filter Relationship Error" block:failedBlock];
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
        if (![self configBlePositioningTimeout]) {
            [self operationFailedBlockWithMsg:@"Config Timeout Error" block:failedBlock];
            return;
        }
        if (![self configBlePositioningMac]) {
            [self operationFailedBlockWithMsg:@"Config Number Error" block:failedBlock];
            return;
        }
        if (![self configFilterRssi]) {
            [self operationFailedBlockWithMsg:@"Config Filter Rssi Error" block:failedBlock];
            return;
        }
        if (![self configFilterRelationship]) {
            [self operationFailedBlockWithMsg:@"Config Filter Relationship Error" block:failedBlock];
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

- (BOOL)readBlePositioningTimeout {
    __block BOOL success = NO;
    [MKPBInterface pb_readBlePositioningTimeoutWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.timeout = returnData[@"result"][@"timeout"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configBlePositioningTimeout {
    __block BOOL success = NO;
    [MKPBInterface pb_configBlePositioningTimeout:[self.timeout integerValue] sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readBlePositioningMac {
    __block BOOL success = NO;
    [MKPBInterface pb_readBlePositioningNumberOfMacWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.number = returnData[@"result"][@"number"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configBlePositioningMac {
    __block BOOL success = NO;
    [MKPBInterface pb_configBlePositioningNumberOfMac:[self.number integerValue] sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readFilterRssi {
    __block BOOL success = NO;
    [MKPBInterface pb_readRssiFilterValueWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.rssi = [returnData[@"result"][@"rssi"] integerValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configFilterRssi {
    __block BOOL success = NO;
    [MKPBInterface pb_configRssiFilterValue:self.rssi sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readFilterRelationship {
    __block BOOL success = NO;
    [MKPBInterface pb_readFilterRelationshipWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.relationship = [returnData[@"result"][@"relationship"] integerValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configFilterRelationship {
    __block BOOL success = NO;
    [MKPBInterface pb_configFilterRelationship:self.relationship sucBlock:^{
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
        NSError *error = [[NSError alloc] initWithDomain:@"BleFixParams"
                                                    code:-999
                                                userInfo:@{@"errorInfo":msg}];
        block(error);
    })
}

- (BOOL)validParams {
    if (!ValidStr(self.timeout) || [self.timeout integerValue] < 1 || [self.timeout integerValue] > 10) {
        return NO;
    }
    if (!ValidStr(self.number) || [self.number integerValue] < 1 || [self.number integerValue] > 15) {
        return NO;
    }
    if (self.rssi < -127 || self.rssi > 0) {
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
        _readQueue = dispatch_queue_create("BleFixQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _readQueue;
}

@end
