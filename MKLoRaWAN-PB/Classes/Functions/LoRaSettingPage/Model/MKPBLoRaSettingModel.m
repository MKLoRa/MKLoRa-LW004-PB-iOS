//
//  MKPBLoRaSettingModel.m
//  MKLoRaWAN-PB_Example
//
//  Created by aa on 2022/3/16.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKPBLoRaSettingModel.h"

#import "MKMacroDefines.h"

#import "MKPBInterface.h"
#import "MKPBInterface+MKPBConfig.h"

@implementation MKPBLoRaSettingConfigModel

- (instancetype)init {
    if (self = [super init]) {
        _supportClassType = NO;
        _supportMessageType = YES;
        _supportServerPlatform = YES;
        _supportMaxRetransmissionTimes = NO;
    }
    return self;
}

@end

@interface MKPBLoRaSettingModel ()

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@property (nonatomic, strong)MKPBLoRaSettingConfigModel *configModel;

@end

@implementation MKPBLoRaSettingModel

- (instancetype)init {
    if (self = [super init]) {
        self.needAdvanceSetting = YES;
    }
    return self;
}

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self readModem]) {
            [self operationFailedBlockWithMsg:@"Read Modem Error" block:failedBlock];
            return;
        }
        if (![self readRegion]) {
            [self operationFailedBlockWithMsg:@"Read Region Error" block:failedBlock];
            return;
        }
        if (![self readDevEUI]) {
            [self operationFailedBlockWithMsg:@"Read DevEUI Error" block:failedBlock];
            return;
        }
        if (![self readAppEUI]) {
            [self operationFailedBlockWithMsg:@"Read AppEUI Error" block:failedBlock];
            return;
        }
        if (![self readAppKey]) {
            [self operationFailedBlockWithMsg:@"Read AppKey Error" block:failedBlock];
            return;
        }
        if (![self readDevAddr]) {
            [self operationFailedBlockWithMsg:@"Read Region Error" block:failedBlock];
            return;
        }
        if (![self readAppSkey]) {
            [self operationFailedBlockWithMsg:@"Read AppSKEY Error" block:failedBlock];
            return;
        }
        if (![self readNwkSkey]) {
            [self operationFailedBlockWithMsg:@"Read NWKSKEY Error" block:failedBlock];
            return;
        }
        if (![self readMessageType]) {
            [self operationFailedBlockWithMsg:@"Read Message Type Error" block:failedBlock];
            return;
        }
        if (![self readRetransmission]) {
            [self operationFailedBlockWithMsg:@"Read Max retransmission times Error" block:failedBlock];
            return;
        }
        if (!self.needAdvanceSetting) {
            moko_dispatch_main_safe(^{
                if (sucBlock) {
                    sucBlock();
                }
            });
            return;
        }
        if (self.currentRegion == 1 || self.currentRegion == 2 || self.currentRegion == 8) {
            //US915、AU915、CN470
            if (![self readCHValue]) {
                [self operationFailedBlockWithMsg:@"Read CH Error" block:failedBlock];
                return;
            }
        }
        //Duty-cycle
        if (self.currentRegion == 3 || self.currentRegion == 4 || self.currentRegion == 5 || self.currentRegion == 9) {
            //EU868,CN779, EU433,RU864
            if (![self readDutyStatus]) {
                [self operationFailedBlockWithMsg:@"Read Duty Cycle Error" block:failedBlock];
                return;
            }
        }
        if (self.currentRegion == 2 || self.currentRegion == 3
            || self.currentRegion == 4 || self.currentRegion == 5 || self.currentRegion == 6
            || self.currentRegion == 7 || self.currentRegion == 9) {
            //CN470, CN779, EU433, EU868,KR920, IN865, RU864
            if (![self readJoinValue]) {
                [self operationFailedBlockWithMsg:@"Read Dr For Join Error" block:failedBlock];
                return;
            }
        }
        if (![self readUplinkStrategy]) {
            [self operationFailedBlockWithMsg:@"Read Uplink  Strategy Error" block:failedBlock];
            return;
        }
        if (![self readACKLimit]) {
            [self operationFailedBlockWithMsg:@"Read ADR ACK LIMIT Error" block:failedBlock];
            return;
        }
        if (![self readACKDelay]) {
            [self operationFailedBlockWithMsg:@"Read ADR ACK DELAY Error" block:failedBlock];
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
        if (![self checkParams]) {
            [self operationFailedBlockWithMsg:@"Opps！Save failed. Please check the input characters and try again." block:failedBlock];
            return;
        }
        if (![self configModem]) {
            [self operationFailedBlockWithMsg:@"Config Modem Error" block:failedBlock];
            return;
        }
        if (![self configRegion]) {
            [self operationFailedBlockWithMsg:@"Config Region Error" block:failedBlock];
            return;
        }
        if (![self configDevEUI]) {
            [self operationFailedBlockWithMsg:@"Config DevEUI Error" block:failedBlock];
            return;
        }
        if (![self configAppEUI]) {
            [self operationFailedBlockWithMsg:@"Config AppEUI Error" block:failedBlock];
            return;
        }
        if (self.modem == 1) {
            //ABP
            if (![self configDevAddr]) {
                [self operationFailedBlockWithMsg:@"Config Region Error" block:failedBlock];
                return;
            }
            if (![self configAppSkey]) {
                [self operationFailedBlockWithMsg:@"Config AppSKEY Error" block:failedBlock];
                return;
            }
            if (![self configNwkSkey]) {
                [self operationFailedBlockWithMsg:@"Config NWKSKEY Error" block:failedBlock];
                return;
            }
        }else if (self.modem == 2) {
            //OTAA
            if (![self configAppKey]) {
                [self operationFailedBlockWithMsg:@"Config AppKey Error" block:failedBlock];
                return;
            }
        }
        
        if (![self configMessageType]) {
            [self operationFailedBlockWithMsg:@"Config Message Type Error" block:failedBlock];
            return;
        }
        if (!self.needAdvanceSetting) {
            if (![self restartDevice]) {
                [self operationFailedBlockWithMsg:@"Connect network error" block:failedBlock];
                return;
            }
            moko_dispatch_main_safe(^{
                if (sucBlock) {
                    sucBlock();
                }
            });
            return;
        }
        if (self.currentRegion == 1 || self.currentRegion == 2 || self.currentRegion == 8) {
            //AU915、CN470、US915
            if (![self configCHValue]) {
                [self operationFailedBlockWithMsg:@"Config CH Error" block:failedBlock];
                return;
            }
        }
        if (self.currentRegion == 3 || self.currentRegion == 4 || self.currentRegion == 5 || self.currentRegion == 9) {
            //EU868,CN779, EU433,RU864
            if (![self configDutyStatus]) {
                [self operationFailedBlockWithMsg:@"Config Duty Cycle Error" block:failedBlock];
                return;
            }
        }
        
        if (self.currentRegion == 2 || self.currentRegion == 3
            || self.currentRegion == 4 || self.currentRegion == 5 || self.currentRegion == 6
            || self.currentRegion == 7 || self.currentRegion == 9) {
            //CN470, CN779, EU433, EU868,KR920, IN865, RU864
            if (![self configJoinValue]) {
                [self operationFailedBlockWithMsg:@"Config DR For Join Error" block:failedBlock];
                return;
            }
        }
        if (![self configUplinkStrategy]) {
            [self operationFailedBlockWithMsg:@"Config Uplink  Strategy Error" block:failedBlock];
            return;
        }
        if (![self configRetransmission]) {
            [self operationFailedBlockWithMsg:@"Config Max retransmission times Error" block:failedBlock];
            return;
        }
        if (![self configACKLimit]) {
            [self operationFailedBlockWithMsg:@"Config ADR ACK LIMIT Error" block:failedBlock];
            return;
        }
        if (![self configACKDelay]) {
            [self operationFailedBlockWithMsg:@"Config ADR ACK DELAY Error" block:failedBlock];
            return;
        }
        if (![self restartDevice]) {
            [self operationFailedBlockWithMsg:@"Connect network error" block:failedBlock];
            return;
        }
        moko_dispatch_main_safe(^{
            if (sucBlock) {
                sucBlock();
            }
        });
    });
}

#pragma mark - public method
- (void)configAdvanceSettingDefaultParams {
    self.CHL = 0;
    if (self.platform == 0) {
        //Third Party NS
        if (self.currentRegion == 1 || self.currentRegion == 8) {
            //AU915、US915
            self.CHL = 8;
            self.CHH = 15;
        }else if (self.currentRegion == 2) {
            //CN470
            self.CHH = 7;
        }else if (self.currentRegion == 3 || self.currentRegion == 4 || self.currentRegion == 5 || self.currentRegion == 6 || self.currentRegion == 7) {
            //CN779、EU433、EU868、KR920、IN865
            self.CHH = 2;
        }else if (self.currentRegion == 0 || self.currentRegion == 9) {
            //RU864、AS923
            self.CHH = 1;
        }
    }else {
        //
        if (self.region == 2 || self.region == 4) {
            //MOKO IoT DM
            //US915 FSB1、AU915 FSB1
            self.CHL = 0;
            self.CHH = 7;
        }else if (self.region == 3 || self.region == 5) {
            //MOKO IoT DM
            //US915 FSB2、AU915 FSB2
            self.CHL = 8;
            self.CHH = 15;
        }
    }
    
    self.dutyIsOn = NO;
    
    self.adrIsOn = YES;
//    self.retransmission = 0;
    if (self.currentRegion == 0 || self.currentRegion == 1) {
        //AS923、AU915
        self.join = 2;
        self.DRL = 2;
        self.DRH = 2;
    }else {
        self.join = 0;
        self.DRL = 0;
        self.DRH = 0;
    }
}

- (NSInteger)currentRegion {
    if (self.platform == 0) {
        //Third Party NS
        return self.region;
    }
    //MOKO IoT DM
    if (self.region == 0) {
        //AS923
        return 0;
    }
    if (self.region == 1) {
        //EU868
        return 5;
    }
    if (self.region == 2 || self.region == 3) {
        //US915 FSB1、US915 FSB2
        return 8;
    }
    //AU915 FSB1、AU915 FSB2
    return 1;
}

- (NSArray <NSString *>*)RegionList {
    if (self.platform == 0) {
        //Third Party NS
        return @[@"AS923",@"AU915",@"CN470",@"CN779",@"EU433",@"EU868",@"KR920",@"IN865",@"US915",@"RU864"];
    }
    //MOKO IoT DM
    return @[@"AS923",@"EU868",@"US915 FSB1",@"US915 FSB2",@"AU915 FSB1",@"AU915 FSB2"];
}

- (NSArray <NSString *>*)CHLValueList {
    if (self.currentRegion == 1 || self.currentRegion == 8) {
        //AU915、US915
        return [self loadStringWithMaxValue:63];
    }
    if (self.currentRegion == 2) {
        //CN470
        return [self loadStringWithMaxValue:95];
    }
    if (self.currentRegion == 3 || self.currentRegion == 4 || self.currentRegion == 5 || self.currentRegion == 6 || self.currentRegion == 7) {
        //CN779、EU433、EU868、KR920、IN865
        return [self loadStringWithMaxValue:2];
    }
    //RU864、AS923
    return [self loadStringWithMaxValue:1];
}

- (NSArray <NSString *>*)CHHValueList {
    NSArray *chlList = [self CHLValueList];
    return [chlList subarrayWithRange:NSMakeRange(self.CHL, chlList.count - self.CHL)];
}

- (NSArray <NSString *>*)DRValueList; {
    if (self.currentRegion == 0) {
        //AS923
        return @[@"2",@"3",@"4",@"5"];
    }
    if (self.currentRegion == 1) {
        //AU915
        return @[@"2",@"3",@"4",@"5",@"6"];
    }
    if (self.currentRegion == 8) {
        //US915
        return [self loadStringWithMaxValue:4];
    }
    return [self loadStringWithMaxValue:5];
}

- (NSArray <NSString *>*)DRLValueList {
    return [self DRValueList];
}

- (NSArray <NSString *>*)DRHValueList {
    NSArray *drlList = [self DRLValueList];
    NSInteger lowIndex = 0;
    for (NSInteger i = 0; i < drlList.count; i ++) {
        if (self.DRL == [drlList[i] integerValue]) {
            lowIndex = i;
            break;
        }
    }

    return [drlList subarrayWithRange:NSMakeRange(lowIndex, drlList.count - lowIndex)];
}

#pragma mark - interface

- (BOOL)readModem {
    __block BOOL success = NO;
    [MKPBInterface pb_readLorawanModemWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.modem = [returnData[@"result"][@"modem"] integerValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configModem {
    __block BOOL success = NO;
    [MKPBInterface pb_configModem:(self.modem - 1) sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readRegion {
    __block BOOL success = NO;
    [MKPBInterface pb_readLorawanRegionWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.region = [returnData[@"result"][@"region"] integerValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configRegion {
    __block BOOL success = NO;
    [MKPBInterface pb_configRegion:self.currentRegion sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readDevEUI {
    __block BOOL success = NO;
    [MKPBInterface pb_readLorawanDEVEUIWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.devEUI = returnData[@"result"][@"devEUI"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configDevEUI {
    __block BOOL success = NO;
    [MKPBInterface pb_configDEVEUI:self.devEUI sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readAppEUI {
    __block BOOL success = NO;
    [MKPBInterface pb_readLorawanAPPEUIWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.appEUI = returnData[@"result"][@"appEUI"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configAppEUI {
    __block BOOL success = NO;
    [MKPBInterface pb_configAPPEUI:self.appEUI sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readAppKey {
    __block BOOL success = NO;
    [MKPBInterface pb_readLorawanAPPKEYWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.appKey = returnData[@"result"][@"appKey"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configAppKey {
    __block BOOL success = NO;
    [MKPBInterface pb_configAPPKEY:self.appKey sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readDevAddr {
    __block BOOL success = NO;
    [MKPBInterface pb_readLorawanDEVADDRWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.devAddr = returnData[@"result"][@"devAddr"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configDevAddr {
    __block BOOL success = NO;
    [MKPBInterface pb_configDEVADDR:self.devAddr sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readAppSkey {
    __block BOOL success = NO;
    [MKPBInterface pb_readLorawanAPPSKEYWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.appSKey = returnData[@"result"][@"appSkey"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configAppSkey {
    __block BOOL success = NO;
    [MKPBInterface pb_configAPPSKEY:self.appSKey sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readMessageType {
    __block BOOL success = NO;
    [MKPBInterface pb_readLorawanMessageTypeWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.messageType = [returnData[@"result"][@"messageType"] integerValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configMessageType {
    __block BOOL success = NO;
    [MKPBInterface pb_configMessageType:self.messageType sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readNwkSkey {
    __block BOOL success = NO;
    [MKPBInterface pb_readLorawanNWKSKEYWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.nwkSKey = returnData[@"result"][@"nwkSkey"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configNwkSkey {
    __block BOOL success = NO;
    [MKPBInterface pb_configNWKSKEY:self.nwkSKey sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readCHValue {
    __block BOOL success = NO;
    [MKPBInterface pb_readLorawanCHWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.CHL = [returnData[@"result"][@"CHL"] integerValue];
        self.CHH = [returnData[@"result"][@"CHH"] integerValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configCHValue {
    __block BOOL success = NO;
    [MKPBInterface pb_configCHL:self.CHL CHH:self.CHH sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readDutyStatus {
    __block BOOL success = NO;
    [MKPBInterface pb_readLorawanDutyCycleStatusWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.dutyIsOn = [returnData[@"result"][@"isOn"] boolValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configDutyStatus {
    __block BOOL success = NO;
    [MKPBInterface pb_configDutyCycleStatus:self.dutyIsOn sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readJoinValue {
    __block BOOL success = NO;
    [MKPBInterface pb_readLorawanDRWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.join = [returnData[@"result"][@"DR"] integerValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configJoinValue {
    __block BOOL success = NO;
    [MKPBInterface pb_configDR:self.join sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readUplinkStrategy {
    __block BOOL success = NO;
    [MKPBInterface pb_readLorawanUplinkStrategyWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.adrIsOn = [returnData[@"result"][@"isOn"] boolValue];
        self.DRL =  [returnData[@"result"][@"DRL"] integerValue];
        self.DRH = [returnData[@"result"][@"DRH"] integerValue];
        self.transmissions = [returnData[@"result"][@"transmissions"] integerValue] - 1;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configUplinkStrategy {
    __block BOOL success = NO;
    [MKPBInterface pb_configUplinkStrategy:self.adrIsOn transmissions:(self.transmissions + 1) DRL:self.DRL DRH:self.DRH sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readRetransmission {
    __block BOOL success = NO;
    [MKPBInterface pb_readLorawanMaxRetransmissionTimesWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.retransmission = [returnData[@"result"][@"number"] integerValue] - 1;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configRetransmission {
    __block BOOL success = NO;
    [MKPBInterface pb_configLorawanMaxRetransmissionTimes:(self.retransmission + 1) sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readACKLimit {
    __block BOOL success = NO;
    [MKPBInterface pb_readLorawanADRACKLimitWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.ackLimit = returnData[@"result"][@"value"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configACKLimit {
    __block BOOL success = NO;
    [MKPBInterface pb_configLorawanADRACKLimit:[self.ackLimit integerValue] sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readACKDelay {
    __block BOOL success = NO;
    [MKPBInterface pb_readLorawanADRACKDelayWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.ackDelay = returnData[@"result"][@"value"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configACKDelay {
    __block BOOL success = NO;
    [MKPBInterface pb_configLorawanADRACKDelay:[self.ackDelay integerValue] sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)restartDevice {
    __block BOOL success = NO;
    [MKPBInterface pb_restartDeviceWithSucBlock:^{
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
        NSError *error = [[NSError alloc] initWithDomain:@"loraParams"
                                                    code:-999
                                                userInfo:@{@"errorInfo":msg}];
        block(error);
    })
}

- (BOOL)checkParams {
    //0:ABP,1:OTAA
    if (self.modem != 1 && self.modem != 2) {
        return NO;
    }
    if (!ValidStr(self.devEUI) || self.devEUI.length != 16) {
        return NO;
    }
    if (!ValidStr(self.appEUI) || self.appEUI.length != 16) {
        return NO;
    }
    if (self.modem == 1) {
        //ABP
        if (!ValidStr(self.devAddr) || self.devAddr.length != 8) {
            return NO;
        }
        if (!ValidStr(self.nwkSKey) || self.nwkSKey.length != 32) {
            return NO;
        }
        if (!ValidStr(self.appSKey) || self.appSKey.length != 32) {
            return NO;
        }
    }else {
        //OTAA
        if (!ValidStr(self.appKey) || self.appKey.length != 32) {
            return NO;
        }
    }
    if (self.currentRegion < 0 || self.currentRegion > 9) {
        return NO;
    }

    if (self.messageType != 0 && self.messageType != 1) {
        return NO;
    }
    if (self.needAdvanceSetting) {
        if (self.currentRegion == 1 || self.currentRegion == 2 || self.currentRegion == 8) {
            if (self.CHL < 0 || self.CHL > 95 || self.CHH < self.CHL || self.CHH > 95) {
                return NO;
            }
        }
        if (self.currentRegion == 0 || self.currentRegion == 2 || self.currentRegion == 3
            || self.currentRegion == 4 || self.currentRegion == 5 || self.currentRegion == 6 || self.currentRegion == 7) {
            //CN470, CN779, EU433, EU868,KR920, IN865, RU864
            if (self.join < 0 || self.join > 5) {
                return NO;
            }
        }
        if (self.retransmission < 0 && self.retransmission > 7) {
            return NO;
        }
        if (self.DRL < 0 || self.DRL > 6 || self.DRH < self.DRL || self.DRH > 6) {
            return NO;
        }
        if (self.transmissions < 0 || self.transmissions > 1) {
            return NO;
        }
        if (!ValidStr(self.ackLimit) || [self.ackLimit integerValue] < 1 || [self.ackLimit integerValue] > 100) {
            return NO;
        }if (!ValidStr(self.ackDelay) || [self.ackDelay integerValue] < 1 || [self.ackDelay integerValue] > 100) {
            return NO;
        }
    }
    return YES;
}

- (NSDictionary *)RegionDic {
    return @{
        @"0":@"AS923",
        @"1":@"AU915",
        @"2":@"CN470",
        @"3":@"CN779",
        @"4":@"EU433",
        @"5":@"EU868",
        @"6":@"KR920",
        @"7":@"IN865",
        @"8":@"US915",
        @"9":@"RU864"
    };
}

- (NSArray *)loadStringWithMaxValue:(NSInteger)max {
    NSMutableArray *list = [NSMutableArray array];
    for (NSInteger i = 0; i <= max; i ++) {
        [list addObject:[NSString stringWithFormat:@"%ld",(long)i]];
    }
    return list;
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
        _readQueue = dispatch_queue_create("loraParamsQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _readQueue;
}

- (MKPBLoRaSettingConfigModel *)configModel {
    if (!_configModel) {
        _configModel = [[MKPBLoRaSettingConfigModel alloc] init];
    }
    return _configModel;
}

@end
