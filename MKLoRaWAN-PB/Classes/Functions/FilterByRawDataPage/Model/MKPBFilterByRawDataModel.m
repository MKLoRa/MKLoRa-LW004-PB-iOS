//
//  MKPBFilterByRawDataModel.m
//  MKLoRaWAN-PB_Example
//
//  Created by aa on 2022/3/18.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKPBFilterByRawDataModel.h"

#import <UIKit/UIKit.h>

#import "MKMacroDefines.h"
#import "MKHudManager.h"

#import "MKPBInterface.h"
#import "MKPBInterface+MKPBConfig.h"

#import "MKFilterByBeaconController.h"
#import "MKFilterByBeaconProtocol.h"
#import "MKFilterByUIDController.h"
#import "MKFilterByURLController.h"
#import "MKFilterByTLMController.h"
#import "MKFilterByOtherController.h"

#import "MKPBFilterByBeaconModel.h"
#import "MKPBFilterByUIDModel.h"
#import "MKPBFilterByURLModel.h"
#import "MKPBFilterByTLMModel.h"
#import "MKPBFilterByOtherModel.h"

@interface MKPBFilterByRawDataModel ()

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

#pragma mark - Protocol required stored properties

@property (nonatomic, copy, readwrite) NSString *pageTitle;

// section0
@property (nonatomic, assign, readwrite) BOOL iBeacon;
@property (nonatomic, assign, readwrite) BOOL uid;
@property (nonatomic, assign, readwrite) BOOL url;
@property (nonatomic, assign, readwrite) BOOL tlm;
@property (nonatomic, assign, readwrite) BOOL bxpBeacon;

// section1
@property (nonatomic, assign, readwrite) BOOL bxpDeviceInfo;  // PB 硬件不支持，固定 NO
@property (nonatomic, assign, readwrite) BOOL bxpAcc;
@property (nonatomic, assign, readwrite) BOOL bxpTH;

// section2
@property (nonatomic, assign, readwrite) BOOL bxpButton;  // PB 硬件不支持，固定 NO
@property (nonatomic, assign, readwrite) BOOL bxpTag;     // PB 硬件不支持，固定 NO
@property (nonatomic, assign, readwrite) BOOL pir;        // PB 硬件不支持，固定 NO
@property (nonatomic, assign, readwrite) BOOL tof;        // PB 硬件不支持，固定 NO
@property (nonatomic, assign, readwrite) BOOL nanoBeacon; // PB 硬件不支持，固定 NO
@property (nonatomic, assign, readwrite) BOOL other;

@end

@implementation MKPBFilterByRawDataModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _pageTitle = @"Filter by Raw Data";
        _bxpDeviceInfo = NO;
        _bxpButton = NO;
        _bxpTag = NO;
        _pir = NO;
        _tof = NO;
        _nanoBeacon = NO;
    }
    return self;
}

#pragma mark - MKFilterByRawDataProtocol: section2 类型列表

- (NSArray<NSNumber *> *)supportedRawDataTypesForSection2 {
    // PB 只有 4 种，没有 TOF 和 NanoBeacon
    return @[
        @(mk_filterByRawDataType_BXPButton),
        @(mk_filterByRawDataType_BXPTag),
        @(mk_filterByRawDataType_PIR),
        @(mk_filterByRawDataType_Other),
    ];
}

#pragma mark - MKFilterByRawDataProtocol: section0 + section2 push

- (void)pushFilterControllerForRawType:(mk_filterByRawDataType)rawType
                          navController:(UINavigationController *)navController {
    switch (rawType) {
        case mk_filterByRawDataType_iBeacon: {
            MKFilterByBeaconController *vc = [[MKFilterByBeaconController alloc] init];
            MKPBFilterByBeaconModel *model = [[MKPBFilterByBeaconModel alloc] init];
            model.pageType = mk_filterByBeaconPageType_beacon;
            model.pageTitle = @"iBeacon Filter";
            vc.protocol = model;
            [navController pushViewController:vc animated:YES];
            break;
        }
        case mk_filterByRawDataType_EddystoneUID: {
            MKFilterByUIDController *vc = [[MKFilterByUIDController alloc] init];
            MKPBFilterByUIDModel *model = [[MKPBFilterByUIDModel alloc] init];
            model.pageTitle = @"Eddystone-UID Filter";
            vc.protocol = model;
            [navController pushViewController:vc animated:YES];
            break;
        }
        case mk_filterByRawDataType_EddystoneURL: {
            MKFilterByURLController *vc = [[MKFilterByURLController alloc] init];
            MKPBFilterByURLModel *model = [[MKPBFilterByURLModel alloc] init];
            model.pageTitle = @"Eddystone-URL Filter";
            vc.protocol = model;
            [navController pushViewController:vc animated:YES];
            break;
        }
        case mk_filterByRawDataType_EddystoneTLM: {
            MKFilterByTLMController *vc = [[MKFilterByTLMController alloc] init];
            MKPBFilterByTLMModel *model = [[MKPBFilterByTLMModel alloc] init];
            model.pageTitle = @"Eddystone-TLM Filter";
            vc.protocol = model;
            [navController pushViewController:vc animated:YES];
            break;
        }
        case mk_filterByRawDataType_BXPBeacon: {
            // BXP-iBeacon (MKiBeacon)
            MKFilterByBeaconController *vc = [[MKFilterByBeaconController alloc] init];
            MKPBFilterByBeaconModel *model = [[MKPBFilterByBeaconModel alloc] init];
            model.pageType = mk_filterByBeaconPageType_bxpBeacon;
            model.pageTitle = @"MKiBeacon Filter";
            vc.protocol = model;
            [navController pushViewController:vc animated:YES];
            break;
        }
        case mk_filterByRawDataType_BXPButton:
        case mk_filterByRawDataType_BXPTag:
        case mk_filterByRawDataType_PIR:
            // PB 硬件不支持，不做任何操作
            break;
        case mk_filterByRawDataType_Other: {
            MKFilterByOtherController *vc = [[MKFilterByOtherController alloc] init];
            MKPBFilterByOtherModel *model = [[MKPBFilterByOtherModel alloc] init];
            model.pageTitle = @"Other Type Filter";
            vc.protocol = model;
            [navController pushViewController:vc animated:YES];
            break;
        }
        default:
            break;
    }
}

#pragma mark - MKFilterByRawDataProtocol: section1 BXP 开关

- (void)configBXPDeviceInfoStatus:(BOOL)isOn
                         sucBlock:(void (^)(void))sucBlock
                      failedBlock:(void (^)(NSError *error))failedBlock {
    // PB 硬件不支持 BXP Device Info，直接成功
    moko_dispatch_main_safe(^{
        if (sucBlock) sucBlock();
    });
}

- (void)configBXPAccStatus:(BOOL)isOn
                  sucBlock:(void (^)(void))sucBlock
               failedBlock:(void (^)(NSError *error))failedBlock {
    [[MKHudManager share] showHUDWithTitle:@"Config..." isPenetration:NO];
    [MKPBInterface pb_configBXPAccFilterStatus:isOn sucBlock:^{
        [[MKHudManager share] hide];
        self.bxpAcc = isOn;
        moko_dispatch_main_safe(^{
            if (sucBlock) sucBlock();
        });
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        moko_dispatch_main_safe(^{
            if (failedBlock) failedBlock(error);
        });
    }];
}

- (void)configBXPTHStatus:(BOOL)isOn
                 sucBlock:(void (^)(void))sucBlock
              failedBlock:(void (^)(NSError *error))failedBlock {
    [[MKHudManager share] showHUDWithTitle:@"Config..." isPenetration:NO];
    [MKPBInterface pb_configBXPTHFilterStatus:isOn sucBlock:^{
        [[MKHudManager share] hide];
        self.bxpTH = isOn;
        moko_dispatch_main_safe(^{
            if (sucBlock) sucBlock();
        });
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        moko_dispatch_main_safe(^{
            if (failedBlock) failedBlock(error);
        });
    }];
}

#pragma mark - MKFilterByRawDataProtocol: read

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
        // PB 的 mk_iBeacon → Protocol 的 bxpBeacon
        self.bxpBeacon = [returnData[@"result"][@"mk_iBeacon"] boolValue];
        // PB 的 mk_iBeacon_acc 在 Protocol 中没有位置，忽略
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
