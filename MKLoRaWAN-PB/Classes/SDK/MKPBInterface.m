//
//  MKPBInterface.m
//  MKLoRaWAN-PB_Example
//
//  Created by aa on 2022/3/15.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKPBInterface.h"

#import "MKBLEBaseSDKDefines.h"
#import "MKBLEBaseSDKAdopter.h"

#import "MKPBCentralManager.h"
#import "MKPBOperationID.h"
#import "MKPBOperation.h"
#import "CBPeripheral+MKPBAdd.h"
#import "MKPBSDKDataAdopter.h"

#define centralManager [MKPBCentralManager shared]
#define peripheral ([MKPBCentralManager shared].peripheral)

@implementation MKPBInterface

#pragma mark ****************************************Device Service Information************************************************

+ (void)pb_readDeviceModelWithSucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_pb_taskReadDeviceModelOperation
                           characteristic:peripheral.pb_deviceModel
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)pb_readFirmwareWithSucBlock:(void (^)(id returnData))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_pb_taskReadFirmwareOperation
                           characteristic:peripheral.pb_firmware
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)pb_readHardwareWithSucBlock:(void (^)(id returnData))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_pb_taskReadHardwareOperation
                           characteristic:peripheral.pb_hardware
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)pb_readSoftwareWithSucBlock:(void (^)(id returnData))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_pb_taskReadSoftwareOperation
                           characteristic:peripheral.pb_software
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)pb_readManufacturerWithSucBlock:(void (^)(id returnData))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_pb_taskReadManufacturerOperation
                           characteristic:peripheral.pb_manufacturer
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

#pragma mark ****************************************System************************************************

+ (void)pb_readBatteryVoltageWithSucBlock:(void (^)(id returnData))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_pb_taskReadBatteryVoltageOperation
                     cmdFlag:@"05"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)pb_readTurnOffDeviceByButtonStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                           failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_pb_taskReadTurnOffDeviceByButtonStatusOperation
                     cmdFlag:@"06"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)pb_readLowPowerPromptWithSucBlock:(void (^)(id returnData))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_pb_taskReadLowPowerPromptOperation
                     cmdFlag:@"07"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)pb_readLowPowerPayloadWithSucBlock:(void (^)(id returnData))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_pb_taskReadLowPowerPayloadOperation
                     cmdFlag:@"08"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)pb_readDeviceNameWithSucBlock:(void (^)(id returnData))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_pb_taskReadDeviceNameOperation
                     cmdFlag:@"09"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)pb_readAdvIntervalWithSucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_pb_taskReadAdvIntervalOperation
                     cmdFlag:@"0a"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)pb_readTxPowerWithSucBlock:(void (^)(id returnData))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_pb_taskReadTxPowerOperation
                     cmdFlag:@"0b"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)pb_readBroadcastTimeoutWithSucBlock:(void (^)(id returnData))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_pb_taskReadBroadcastTimeoutOperation
                     cmdFlag:@"0c"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)pb_readConnectationNeedPasswordWithSucBlock:(void (^)(id returnData))sucBlock
                                        failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_pb_taskReadConnectationNeedPasswordOperation
                     cmdFlag:@"0d"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)pb_readPasswordWithSucBlock:(void (^)(id returnData))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_pb_taskReadPasswordOperation
                     cmdFlag:@"0e"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)pb_readTimeZoneWithSucBlock:(void (^)(id returnData))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_pb_taskReadTimeZoneOperation
                     cmdFlag:@"0f"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)pb_readThreeAxisWakeupThresholdWithSucBlock:(void (^)(id returnData))sucBlock
                                        failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_pb_taskReadThreeAxisWakeupThresholdOperation
                     cmdFlag:@"11"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)pb_readThreeAxisWakeupDurationWithSucBlock:(void (^)(id returnData))sucBlock
                                       failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_pb_taskReadThreeAxisWakeupDurationOperation
                     cmdFlag:@"12"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)pb_readThreeAxisMotionThresholdWithSucBlock:(void (^)(id returnData))sucBlock
                                        failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_pb_taskReadThreeAxisMotionThresholdOperation
                     cmdFlag:@"13"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)pb_readThreeAxisMotionDurationWithSucBlock:(void (^)(id returnData))sucBlock
                                       failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_pb_taskReadThreeAxisMotionDurationOperation
                     cmdFlag:@"14"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)pb_readMotionModeTripEndTimeoutWithSucBlock:(void (^)(id returnData))sucBlock
                                        failedBlock:(void (^)(NSError * error))failedBlock {
    [self readDataWithTaskID:mk_pb_taskReadMotionModeTripEndTimeoutOperation
                     cmdFlag:@"15"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)pb_readMacAddressWithSucBlock:(void (^)(id returnData))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_pb_taskReadMacAddressOperation
                     cmdFlag:@"17"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)pb_readPCBAStatusWithSucBlock:(void (^)(id returnData))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_pb_taskReadPCBAStatusOperation
                     cmdFlag:@"1b"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)pb_readSelftestStatusWithSucBlock:(void (^)(id returnData))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_pb_taskReadSelftestStatusOperation
                     cmdFlag:@"1c"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

#pragma mark ****************************************Work Mode************************************************

+ (void)pb_readShutDownPayloadStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                     failedBlock:(void (^)(NSError * error))failedBlock {
    [self readDataWithTaskID:mk_pb_taskReadShutDownPayloadStatusOperation
                     cmdFlag:@"20"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)pb_readWorkModeWithSucBlock:(void (^)(id returnData))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_pb_taskReadWorkModeOperation
                     cmdFlag:@"21"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)pb_readHeartbeatIntervalWithSucBlock:(void (^)(id returnData))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_pb_taskReadHeartbeatIntervalOperation
                     cmdFlag:@"22"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)pb_readPeriodicModeReportIntervalWithSucBlock:(void (^)(id returnData))sucBlock
                                          failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_pb_taskReadPeriodicModeReportIntervalOperation
                     cmdFlag:@"23"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)pb_readPeriodicModePositioningStrategyWithSucBlock:(void (^)(id returnData))sucBlock
                                               failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_pb_taskReadPeriodicModePositioningStrategyOperation
                     cmdFlag:@"24"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)pb_readTimingModeReportingTimePointWithSucBlock:(void (^)(id returnData))sucBlock
                                            failedBlock:(void (^)(NSError * error))failedBlock {
    [self readDataWithTaskID:mk_pb_taskReadTimingModeReportingTimePointOperation
                     cmdFlag:@"25"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)pb_readTimingModePositioningStrategyWithSucBlock:(void (^)(id returnData))sucBlock
                                             failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_pb_taskReadTimingModePositioningStrategyOperation
                     cmdFlag:@"26"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)pb_readMotionModeEventsWithSucBlock:(void (^)(id returnData))sucBlock
                                failedBlock:(void (^)(NSError * error))failedBlock {
    [self readDataWithTaskID:mk_pb_taskReadMotionModeEventsOperation
                     cmdFlag:@"27"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)pb_readMotionModePosStrategyOnStartWithSucBlock:(void (^)(id returnData))sucBlock
                                            failedBlock:(void (^)(NSError * error))failedBlock {
    [self readDataWithTaskID:mk_pb_taskReadMotionModePosStrategyOnStartOperation
                     cmdFlag:@"28"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)pb_readMotionModeNumberOfFixOnStartWithSucBlock:(void (^)(id returnData))sucBlock
                                            failedBlock:(void (^)(NSError * error))failedBlock {
    [self readDataWithTaskID:mk_pb_taskReadMotionModeNumberOfFixOnStartOperation
                     cmdFlag:@"29"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)pb_readMotionModePosStrategyInTripWithSucBlock:(void (^)(id returnData))sucBlock
                                           failedBlock:(void (^)(NSError * error))failedBlock {
    [self readDataWithTaskID:mk_pb_taskReadMotionModePosStrategyInTripOperation
                     cmdFlag:@"2a"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)pb_readMotionModeReportIntervalInTripWithSucBlock:(void (^)(id returnData))sucBlock
                                              failedBlock:(void (^)(NSError * error))failedBlock {
    [self readDataWithTaskID:mk_pb_taskReadMotionModeReportIntervalInTripOperation
                     cmdFlag:@"2b"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)pb_readMotionModePosStrategyOnEndWithSucBlock:(void (^)(id returnData))sucBlock
                                          failedBlock:(void (^)(NSError * error))failedBlock {
    [self readDataWithTaskID:mk_pb_taskReadMotionModePosStrategyOnEndOperation
                     cmdFlag:@"2c"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)pb_readMotionModeNumberOfFixOnEndWithSucBlock:(void (^)(id returnData))sucBlock
                                          failedBlock:(void (^)(NSError * error))failedBlock {
    [self readDataWithTaskID:mk_pb_taskReadMotionModeNumberOfFixOnEndOperation
                     cmdFlag:@"2d"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)pb_readMotionModeReportIntervalOnEndWithSucBlock:(void (^)(id returnData))sucBlock
                                             failedBlock:(void (^)(NSError * error))failedBlock {
    [self readDataWithTaskID:mk_pb_taskReadMotionModeReportIntervalOnEndOperation
                     cmdFlag:@"2e"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

#pragma mark ****************************************Auxiliary************************************************

+ (void)pb_readDownlinkPositioningStrategyWithSucBlock:(void (^)(id returnData))sucBlock
                                           failedBlock:(void (^)(NSError * error))failedBlock {
    [self readDataWithTaskID:mk_pb_taskReadDownlinkPositioningStrategyOperation
                     cmdFlag:@"30"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)pb_readManDownDetectionWithSucBlock:(void (^)(id returnData))sucBlock
                                failedBlock:(void (^)(NSError * error))failedBlock {
    [self readDataWithTaskID:mk_pb_taskReadManDownDetectionOperation
                     cmdFlag:@"31"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)pb_readManDownPositioningStrategyWithSucBlock:(void (^)(id returnData))sucBlock
                                          failedBlock:(void (^)(NSError * error))failedBlock {
    [self readDataWithTaskID:mk_pb_taskReadManDownPositioningStrategyOperation
                     cmdFlag:@"32"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)pb_readManDownDetectionTimeoutWithSucBlock:(void (^)(id returnData))sucBlock
                                       failedBlock:(void (^)(NSError * error))failedBlock {
    [self readDataWithTaskID:mk_pb_taskReadManDownDetectionTimeoutOperation
                     cmdFlag:@"33"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)pb_readManDownReportIntervalWithSucBlock:(void (^)(id returnData))sucBlock
                                     failedBlock:(void (^)(NSError * error))failedBlock {
    [self readDataWithTaskID:mk_pb_taskReadManDownReportIntervalOperation
                     cmdFlag:@"34"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)pb_readNotifyEventOnManDownStartWithSucBlock:(void (^)(id returnData))sucBlock
                                         failedBlock:(void (^)(NSError * error))failedBlock {
    [self readDataWithTaskID:mk_pb_taskReadNotifyEventOnManDownStartOperation
                     cmdFlag:@"35"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)pb_readNotifyEventOnManDownEndWithSucBlock:(void (^)(id returnData))sucBlock
                                       failedBlock:(void (^)(NSError * error))failedBlock {
    [self readDataWithTaskID:mk_pb_taskReadNotifyEventOnManDownEndOperation
                     cmdFlag:@"36"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)pb_readMotorVibrationIntensityWithSucBlock:(void (^)(id returnData))sucBlock
                                       failedBlock:(void (^)(NSError * error))failedBlock {
    [self readDataWithTaskID:mk_pb_taskReadMotorVibrationIntensityOperation
                     cmdFlag:@"37"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)pb_readAlarmTypeWithSucBlock:(void (^)(id returnData))sucBlock
                         failedBlock:(void (^)(NSError * error))failedBlock {
    [self readDataWithTaskID:mk_pb_taskReadAlarmTypeOperation
                     cmdFlag:@"38"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)pb_readExitAlarmTypeLongPressTimeWithSucBlock:(void (^)(id returnData))sucBlock
                                          failedBlock:(void (^)(NSError * error))failedBlock {
    [self readDataWithTaskID:mk_pb_taskReadExitAlarmTypeLongPressTimeOperation
                     cmdFlag:@"39"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)pb_readNotifyEventOnSOSStartWithSucBlock:(void (^)(id returnData))sucBlock
                                     failedBlock:(void (^)(NSError * error))failedBlock {
    [self readDataWithTaskID:mk_pb_taskReadNotifyEventOnSOSStartOperation
                     cmdFlag:@"3a"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)pb_readNotifyEventOnSOSEndWithSucBlock:(void (^)(id returnData))sucBlock
                                   failedBlock:(void (^)(NSError * error))failedBlock {
    [self readDataWithTaskID:mk_pb_taskReadNotifyEventOnSOSEndOperation
                     cmdFlag:@"3b"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)pb_readSOSPositioningStrategyWithSucBlock:(void (^)(id returnData))sucBlock
                                      failedBlock:(void (^)(NSError * error))failedBlock {
    [self readDataWithTaskID:mk_pb_taskReadSOSPositioningStrategyOperation
                     cmdFlag:@"3c"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)pb_readSOSReportIntervalWithSucBlock:(void (^)(id returnData))sucBlock
                                 failedBlock:(void (^)(NSError * error))failedBlock {
    [self readDataWithTaskID:mk_pb_taskReadSOSReportIntervalOperation
                     cmdFlag:@"3d"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)pb_readSOSTriggerModeWithSucBlock:(void (^)(id returnData))sucBlock
                              failedBlock:(void (^)(NSError * error))failedBlock {
    [self readDataWithTaskID:mk_pb_taskReadSOSTriggerModeOperation
                     cmdFlag:@"3e"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)pb_readNotifyEventOnAlertStartWithSucBlock:(void (^)(id returnData))sucBlock
                                       failedBlock:(void (^)(NSError * error))failedBlock {
    [self readDataWithTaskID:mk_pb_taskReadNotifyEventOnAlertStartOperation
                     cmdFlag:@"3f"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)pb_readNotifyEventOnAlertEndWithSucBlock:(void (^)(id returnData))sucBlock
                                     failedBlock:(void (^)(NSError * error))failedBlock {
    [self readDataWithTaskID:mk_pb_taskReadNotifyEventOnAlertEndOperation
                     cmdFlag:@"40"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)pb_readAlertPositioningStrategyWithSucBlock:(void (^)(id returnData))sucBlock
                                        failedBlock:(void (^)(NSError * error))failedBlock {
    [self readDataWithTaskID:mk_pb_taskReadAlertPositioningStrategyOperation
                     cmdFlag:@"41"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)pb_readAlertTriggerModeWithSucBlock:(void (^)(id returnData))sucBlock
                                failedBlock:(void (^)(NSError * error))failedBlock {
    [self readDataWithTaskID:mk_pb_taskReadAlertTriggerModeOperation
                     cmdFlag:@"42"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

#pragma mark **************************************** Position ************************************************

+ (void)pb_readGpsPositioningTimeoutWithSucBlock:(void (^)(id returnData))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_pb_taskReadGpsPositioningTimeoutOperation
                     cmdFlag:@"50"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)pb_readPDOPOfGpsWithSucBlock:(void (^)(id returnData))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_pb_taskReadPDOPOfGpsOperation
                     cmdFlag:@"51"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)pb_readBlePositioningTimeoutWithSucBlock:(void (^)(id returnData))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_pb_taskReadBlePositioningTimeoutOperation
                     cmdFlag:@"52"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)pb_readBlePositioningNumberOfMacWithSucBlock:(void (^)(id returnData))sucBlock
                                         failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_pb_taskReadBlePositioningNumberOfMacOperation
                     cmdFlag:@"53"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)pb_readRssiFilterValueWithSucBlock:(void (^)(id returnData))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_pb_taskReadRssiFilterValueOperation
                     cmdFlag:@"54"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)pb_readFilterRelationshipWithSucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_pb_taskReadFilterRelationshipOperation
                     cmdFlag:@"55"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)pb_readFilterByMacPreciseMatchWithSucBlock:(void (^)(id returnData))sucBlock
                                       failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_pb_taskReadFilterByMacPreciseMatchOperation
                     cmdFlag:@"56"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)pb_readFilterByMacReverseFilterWithSucBlock:(void (^)(id returnData))sucBlock
                                        failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_pb_taskReadFilterByMacReverseFilterOperation
                     cmdFlag:@"57"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)pb_readFilterMACAddressListWithSucBlock:(void (^)(id returnData))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_pb_taskReadFilterMACAddressListOperation
                     cmdFlag:@"58"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)pb_readFilterByAdvNamePreciseMatchWithSucBlock:(void (^)(id returnData))sucBlock
                                           failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_pb_taskReadFilterByAdvNamePreciseMatchOperation
                     cmdFlag:@"59"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)pb_readFilterByAdvNameReverseFilterWithSucBlock:(void (^)(id returnData))sucBlock
                                            failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_pb_taskReadFilterByAdvNameReverseFilterOperation
                     cmdFlag:@"5a"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)pb_readFilterAdvNameListWithSucBlock:(void (^)(id returnData))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ee005b00";
    [centralManager addTaskWithTaskID:mk_pb_taskReadFilterAdvNameListOperation
                       characteristic:peripheral.pb_custom
                          commandData:commandString
                         successBlock:^(id  _Nonnull returnData) {
        NSArray *advList = [MKPBSDKDataAdopter parseFilterAdvNameList:returnData[@"result"]];
        NSDictionary *resultDic = @{@"msg":@"success",
                                    @"code":@"1",
                                    @"result":@{
                                        @"nameList":advList,
                                    },
                                    };
        MKBLEBase_main_safe(^{
            if (sucBlock) {
                sucBlock(resultDic);
            }
        });
        
    } failureBlock:failedBlock];
}

+ (void)pb_readFilterTypeStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_pb_taskReadFilterTypeStatusOperation
                     cmdFlag:@"5c"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)pb_readFilterByBeaconStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_pb_taskReadFilterByBeaconStatusOperation
                     cmdFlag:@"5d"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)pb_readFilterByBeaconMajorRangeWithSucBlock:(void (^)(id returnData))sucBlock
                                        failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_pb_taskReadFilterByBeaconMajorRangeOperation
                     cmdFlag:@"5e"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)pb_readFilterByBeaconMinorRangeWithSucBlock:(void (^)(id returnData))sucBlock
                                        failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_pb_taskReadFilterByBeaconMinorRangeOperation
                     cmdFlag:@"5f"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)pb_readFilterByBeaconUUIDWithSucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_pb_taskReadFilterByBeaconUUIDOperation
                     cmdFlag:@"60"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)pb_readFilterByMKBeaconStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                      failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_pb_taskReadFilterByMKBeaconStatusOperation
                     cmdFlag:@"61"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)pb_readFilterByMKBeaconMajorRangeWithSucBlock:(void (^)(id returnData))sucBlock
                                          failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_pb_taskReadFilterByMKBeaconMajorRangeOperation
                     cmdFlag:@"62"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)pb_readFilterByMKBeaconMinorRangeWithSucBlock:(void (^)(id returnData))sucBlock
                                          failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_pb_taskReadFilterByMKBeaconMinorRangeOperation
                     cmdFlag:@"63"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)pb_readFilterByMKBeaconUUIDWithSucBlock:(void (^)(id returnData))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_pb_taskReadFilterByMKBeaconUUIDOperation
                     cmdFlag:@"64"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)pb_readFilterByMKBeaconAccStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                         failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_pb_taskReadFilterByMKBeaconAccStatusOperation
                     cmdFlag:@"65"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)pb_readFilterByMKBeaconAccMajorRangeWithSucBlock:(void (^)(id returnData))sucBlock
                                             failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_pb_taskReadFilterByMKBeaconAccMajorRangeOperation
                     cmdFlag:@"66"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)pb_readFilterByMKBeaconAccMinorRangeWithSucBlock:(void (^)(id returnData))sucBlock
                                             failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_pb_taskReadFilterByMKBeaconAccMinorRangeOperation
                     cmdFlag:@"67"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)pb_readFilterByMKBeaconAccUUIDWithSucBlock:(void (^)(id returnData))sucBlock
                                       failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_pb_taskReadFilterByMKBeaconAccUUIDOperation
                     cmdFlag:@"68"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)pb_readFilterByUIDStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_pb_taskReadFilterByUIDStatusOperation
                     cmdFlag:@"69"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)pb_readFilterByUIDNamespaceIDWithSucBlock:(void (^)(id returnData))sucBlock
                                      failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_pb_taskReadFilterByUIDNamespaceIDOperation
                     cmdFlag:@"6a"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)pb_readFilterByUIDInstanceIDWithSucBlock:(void (^)(id returnData))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_pb_taskReadFilterByUIDInstanceIDOperation
                     cmdFlag:@"6b"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)pb_readFilterByURLStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_pb_taskReadFilterByURLStatusOperation
                     cmdFlag:@"6c"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)pb_readFilterByURLContentWithSucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_pb_taskReadFilterByURLContentOperation
                     cmdFlag:@"6d"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)pb_readFilterByTLMStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_pb_taskReadFilterByTLMStatusOperation
                     cmdFlag:@"6e"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)pb_readFilterByTLMVersionWithSucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_pb_taskReadFilterByTLMVersionOperation
                     cmdFlag:@"6f"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)pb_readBXPAccFilterStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_pb_taskReadBXPAccFilterStatusOperation
                     cmdFlag:@"70"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)pb_readBXPTHFilterStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_pb_taskReadBXPTHFilterStatusOperation
                     cmdFlag:@"71"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)pb_readFilterByOtherStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                   failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_pb_taskReadFilterByOtherStatusOperation
                     cmdFlag:@"72"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)pb_readFilterByOtherRelationshipWithSucBlock:(void (^)(id returnData))sucBlock
                                         failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_pb_taskReadFilterByOtherRelationshipOperation
                     cmdFlag:@"73"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)pb_readFilterByOtherConditionsWithSucBlock:(void (^)(id returnData))sucBlock
                                       failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_pb_taskReadFilterByOtherConditionsOperation
                     cmdFlag:@"74"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

#pragma mark **************************************** LoRaWAN ************************************************

+ (void)pb_readLorawanRegionWithSucBlock:(void (^)(id returnData))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_pb_taskReadLorawanRegionOperation
                     cmdFlag:@"80"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)pb_readLorawanModemWithSucBlock:(void (^)(id returnData))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_pb_taskReadLorawanModemOperation
                     cmdFlag:@"81"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)pb_readLorawanNetworkStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_pb_taskReadLorawanNetworkStatusOperation
                     cmdFlag:@"82"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)pb_readLorawanDEVEUIWithSucBlock:(void (^)(id returnData))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_pb_taskReadLorawanDEVEUIOperation
                     cmdFlag:@"83"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)pb_readLorawanAPPEUIWithSucBlock:(void (^)(id returnData))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_pb_taskReadLorawanAPPEUIOperation
                     cmdFlag:@"84"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)pb_readLorawanAPPKEYWithSucBlock:(void (^)(id returnData))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_pb_taskReadLorawanAPPKEYOperation
                     cmdFlag:@"85"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)pb_readLorawanDEVADDRWithSucBlock:(void (^)(id returnData))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_pb_taskReadLorawanDEVADDROperation
                     cmdFlag:@"86"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)pb_readLorawanAPPSKEYWithSucBlock:(void (^)(id returnData))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_pb_taskReadLorawanAPPSKEYOperation
                     cmdFlag:@"87"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)pb_readLorawanNWKSKEYWithSucBlock:(void (^)(id returnData))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_pb_taskReadLorawanNWKSKEYOperation
                     cmdFlag:@"88"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)pb_readLorawanMessageTypeWithSucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_pb_taskReadLorawanMessageTypeOperation
                     cmdFlag:@"89"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)pb_readLorawanCHWithSucBlock:(void (^)(id returnData))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_pb_taskReadLorawanCHOperation
                     cmdFlag:@"8a"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)pb_readLorawanDRWithSucBlock:(void (^)(id returnData))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_pb_taskReadLorawanDROperation
                     cmdFlag:@"8b"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)pb_readLorawanUplinkStrategyWithSucBlock:(void (^)(id returnData))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_pb_taskReadLorawanUplinkStrategyOperation
                     cmdFlag:@"8c"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)pb_readLorawanDutyCycleStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                      failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_pb_taskReadLorawanDutyCycleStatusOperation
                     cmdFlag:@"8d"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)pb_readLorawanTimeSyncIntervalWithSucBlock:(void (^)(id returnData))sucBlock
                                       failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_pb_taskReadLorawanDevTimeSyncIntervalOperation
                     cmdFlag:@"8e"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)pb_readLorawanNetworkCheckIntervalWithSucBlock:(void (^)(id returnData))sucBlock
                                           failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_pb_taskReadLorawanNetworkCheckIntervalOperation
                     cmdFlag:@"8f"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)pb_readLorawanMaxRetransmissionTimesWithSucBlock:(void (^)(id returnData))sucBlock
                                             failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_pb_taskReadLorawanMaxRetransmissionTimesOperation
                     cmdFlag:@"90"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)pb_readLorawanADRACKLimitWithSucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_pb_taskReadLorawanADRACKLimitOperation
                     cmdFlag:@"91"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)pb_readLorawanADRACKDelayWithSucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_pb_taskReadLorawanADRACKDelayOperation
                     cmdFlag:@"92"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

#pragma mark - private method

+ (void)readDataWithTaskID:(mk_pb_taskOperationID)taskID
                   cmdFlag:(NSString *)flag
                  sucBlock:(void (^)(id returnData))sucBlock
               failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ed00",flag,@"00"];
    [centralManager addTaskWithTaskID:taskID
                       characteristic:peripheral.pb_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

@end
