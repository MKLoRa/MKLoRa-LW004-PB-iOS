//
//  MKPBInterface+MKPBConfig.m
//  MKLoRaWAN-PB_Example
//
//  Created by aa on 2022/3/15.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKPBInterface+MKPBConfig.h"

#import "MKBLEBaseSDKDefines.h"
#import "MKBLEBaseSDKAdopter.h"
#import "MKBLEBaseCentralManager.h"

#import "MKPBCentralManager.h"
#import "MKPBOperationID.h"
#import "MKPBOperation.h"
#import "CBPeripheral+MKPBAdd.h"
#import "MKPBSDKDataAdopter.h"

#define centralManager [MKPBCentralManager shared]

@implementation MKPBInterface (MKPBConfig)

#pragma mark ****************************************System************************************************

+ (void)pb_powerOffWithSucBlock:(void (^)(void))sucBlock
                    failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed010200";
    [self configDataWithTaskID:mk_pb_taskPowerOffOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)pb_restartDeviceWithSucBlock:(void (^)(void))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed010300";
    [self configDataWithTaskID:mk_pb_taskRestartDeviceOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)pb_factoryResetWithSucBlock:(void (^)(void))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed010400";
    [self configDataWithTaskID:mk_pb_taskFactoryResetOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)pb_configTurnOffDeviceByButtonStatus:(BOOL)isOn
                                    sucBlock:(void (^)(void))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed01060101" : @"ed01060100");
    [self configDataWithTaskID:mk_pb_taskConfigTurnOffDeviceByButtonStatusOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)pb_configLowPowerPrompt:(NSInteger)prompt
                       sucBlock:(void (^)(void))sucBlock
                    failedBlock:(void (^)(NSError *error))failedBlock {
    if (prompt < 10 || prompt > 60) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *value = [MKBLEBaseSDKAdopter fetchHexValue:prompt byteLen:1];
    NSString *commandString = [@"ed010701" stringByAppendingString:value];
    [self configDataWithTaskID:mk_pb_taskConfigLowPowerPromptOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)pb_configLowPowerPayload:(BOOL)isOn
                        sucBlock:(void (^)(void))sucBlock
                     failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed01080101" : @"ed01080100");
    [self configDataWithTaskID:mk_pb_taskConfigLowPowerPayloadOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)pb_configDeviceName:(NSString *)deviceName
                   sucBlock:(void (^)(void))sucBlock
                failedBlock:(void (^)(NSError *error))failedBlock {
    if (![deviceName isKindOfClass:NSString.class] || deviceName.length > 16) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *tempString = @"";
    for (NSInteger i = 0; i < deviceName.length; i ++) {
        int asciiCode = [deviceName characterAtIndex:i];
        tempString = [tempString stringByAppendingString:[NSString stringWithFormat:@"%1lx",(unsigned long)asciiCode]];
    }
    NSString *lenString = [NSString stringWithFormat:@"%1lx",(long)deviceName.length];
    if (lenString.length == 1) {
        lenString = [@"0" stringByAppendingString:lenString];
    }
    NSString *commandString = [NSString stringWithFormat:@"ed0109%@%@",lenString,tempString];
    [self configDataWithTaskID:mk_pb_taskConfigDeviceNameOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)pb_configAdvInterval:(NSInteger)interval
                    sucBlock:(void (^)(void))sucBlock
                 failedBlock:(void (^)(NSError *error))failedBlock {
    if (interval < 1 || interval > 100) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *value = [MKBLEBaseSDKAdopter fetchHexValue:interval byteLen:1];
    NSString *commandString = [@"ed010a01" stringByAppendingString:value];
    [self configDataWithTaskID:mk_pb_taskConfigAdvIntervalOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)pb_configTxPower:(mk_pb_txPower)txPower
                sucBlock:(void (^)(void))sucBlock
             failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = [@"ed010b01" stringByAppendingString:[MKPBSDKDataAdopter fetchTxPower:txPower]];
    [self configDataWithTaskID:mk_pb_taskConfigTxPowerOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)pb_configBroadcastTimeout:(NSInteger)timeout
                         sucBlock:(void (^)(void))sucBlock
                      failedBlock:(void (^)(NSError *error))failedBlock {
    if (timeout < 1 || timeout > 60) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *value = [MKBLEBaseSDKAdopter fetchHexValue:timeout byteLen:1];
    NSString *commandString = [@"ed010c01" stringByAppendingString:value];
    [self configDataWithTaskID:mk_pb_taskConfigBroadcastTimeoutOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)pb_configNeedPassword:(BOOL)need
                     sucBlock:(void (^)(void))sucBlock
                  failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (need ? @"ed010d0101" : @"ed010d0100");
    [self configDataWithTaskID:mk_pb_taskConfigNeedPasswordOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)pb_configPassword:(NSString *)password
                 sucBlock:(void (^)(void))sucBlock
              failedBlock:(void (^)(NSError *error))failedBlock {
    if (!MKValidStr(password) || password.length != 8) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *commandData = @"";
    for (NSInteger i = 0; i < password.length; i ++) {
        int asciiCode = [password characterAtIndex:i];
        commandData = [commandData stringByAppendingString:[NSString stringWithFormat:@"%1lx",(unsigned long)asciiCode]];
    }
    NSString *commandString = [@"ed010e08" stringByAppendingString:commandData];
    [self configDataWithTaskID:mk_pb_taskConfigPasswordOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)pb_configTimeZone:(NSInteger)timeZone
                 sucBlock:(void (^)(void))sucBlock
              failedBlock:(void (^)(NSError *error))failedBlock {
    if (timeZone < -24 || timeZone > 28) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *zoneString = [MKBLEBaseSDKAdopter hexStringFromSignedNumber:timeZone];
    NSString *commandString = [@"ed010f01" stringByAppendingString:zoneString];
    [self configDataWithTaskID:mk_pb_taskConfigTimeZoneOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)pb_configDeviceTime:(unsigned long)timestamp
                   sucBlock:(void (^)(void))sucBlock
                failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *value = [NSString stringWithFormat:@"%1lx",timestamp];
    NSString *commandString = [@"ed011004" stringByAppendingString:value];
    [self configDataWithTaskID:mk_pb_taskConfigDeviceTimeOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)pb_configThreeAxisWakeupThreshold:(NSInteger)threshold
                                 sucBlock:(void (^)(void))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock {
    if (threshold < 1 || threshold > 20) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *value = [MKBLEBaseSDKAdopter fetchHexValue:threshold byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@",@"ed011101",value];
    [self configDataWithTaskID:mk_pb_taskConfigThreeAxisWakeupThresholdOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)pb_configThreeAxisWakeupDuration:(NSInteger)duration
                                sucBlock:(void (^)(void))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock {
    if (duration < 1 || duration > 10) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *value = [MKBLEBaseSDKAdopter fetchHexValue:duration byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@",@"ed011201",value];
    [self configDataWithTaskID:mk_pb_taskConfigThreeAxisWakeupDurationOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)pb_configThreeAxisMotionThreshold:(NSInteger)threshold
                                 sucBlock:(void (^)(void))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock {
    if (threshold < 10 || threshold > 250) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *value = [MKBLEBaseSDKAdopter fetchHexValue:threshold byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@",@"ed011301",value];
    [self configDataWithTaskID:mk_pb_taskConfigThreeAxisMotionThresholdOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)pb_configThreeAxisMotionDuration:(NSInteger)duration
                                sucBlock:(void (^)(void))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock {
    if (duration < 1 || duration > 50) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *value = [MKBLEBaseSDKAdopter fetchHexValue:duration byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@",@"ed011401",value];
    [self configDataWithTaskID:mk_pb_taskConfigThreeAxisMotionDurationOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)pb_configMotionModeTripEndTimeout:(NSInteger)time
                                 sucBlock:(void (^)(void))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock {
    if (time < 3 || time > 180) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *value = [MKBLEBaseSDKAdopter fetchHexValue:time byteLen:1];
    NSString *commandString = [@"ed011501" stringByAppendingString:value];
    [self configDataWithTaskID:mk_pb_taskConfigMotionModeTripEndTimeoutOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

#pragma mark ****************************************Work Mode************************************************

+ (void)pb_configShutDownPayloadStatus:(BOOL)isOn
                              sucBlock:(void (^)(void))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed01200101" : @"ed01200100");
    [self configDataWithTaskID:mk_pb_taskConfigShutDownPayloadStatusOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)pb_configWorkMode:(mk_pb_deviceMode)deviceMode
                 sucBlock:(void (^)(void))sucBlock
              failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *value = [MKPBSDKDataAdopter fetchDeviceModeValue:deviceMode];
    NSString *commandString = [NSString stringWithFormat:@"%@%@",@"ed012101",value];
    [self configDataWithTaskID:mk_pb_taskConfigWorkModeOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)pb_configHeartbeatInterval:(NSInteger)interval
                          sucBlock:(void (^)(void))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock {
    if (interval < 1 || interval > 14400) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *value = [MKBLEBaseSDKAdopter fetchHexValue:interval byteLen:2];
    NSString *commandString = [NSString stringWithFormat:@"%@%@",@"ed012202",value];
    [self configDataWithTaskID:mk_pb_taskConfigHeartbeatIntervalOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)pb_configPeriodicModeReportInterval:(NSInteger)interval
                                   sucBlock:(void (^)(void))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock {
    if (interval < 1 || interval > 14400) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *value = [MKBLEBaseSDKAdopter fetchHexValue:interval byteLen:2];
    NSString *commandString = [@"ed012302" stringByAppendingString:value];
    [self configDataWithTaskID:mk_pb_taskConfigPeriodicModeReportIntervalOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)pb_configPeriodicModePositioningStrategy:(mk_pb_positioningStrategy)strategy
                                        sucBlock:(void (^)(void))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *strategyString = [MKPBSDKDataAdopter fetchPositioningStrategyCommand:strategy];
    NSString *commandString = [@"ed012401" stringByAppendingString:strategyString];
    [self configDataWithTaskID:mk_pb_taskConfigPeriodicModePositioningStrategyOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)pb_configTimingModeReportingTimePoint:(NSArray <mk_pb_timingModeReportingTimePointProtocol>*)dataList
                                     sucBlock:(void (^)(void))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *dataString = [MKPBSDKDataAdopter fetchTimingModeReportingTimePoint:dataList];
    if (!MKValidStr(dataString)) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *commandString = [@"ed0125" stringByAppendingString:dataString];
    [self configDataWithTaskID:mk_pb_taskConfigTimingModeReportingTimePointOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)pb_configTimingModePositioningStrategy:(mk_pb_positioningStrategy)strategy
                                      sucBlock:(void (^)(void))sucBlock
                                   failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *strategyString = [MKPBSDKDataAdopter fetchPositioningStrategyCommand:strategy];
    NSString *commandString = [@"ed012601" stringByAppendingString:strategyString];
    [self configDataWithTaskID:mk_pb_taskConfigTimingModePositioningStrategyOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)pb_configMotionModeEvents:(id <mk_pb_motionModeEventsProtocol>)protocol
                         sucBlock:(void (^)(void))sucBlock
                      failedBlock:(void (^)(NSError *error))failedBlock {
    
    NSString *fixOnStartValue = (protocol.fixOnStart ? @"1" : @"0");
    NSString *fixInTripValue = (protocol.fixInTrip ? @"1" : @"0");
    NSString *fixOnEndValue = (protocol.fixOnEnd ? @"1" : @"0");
    NSString *notifyEventOnStartValue = (protocol.notifyEventOnStart ? @"1" : @"0");
    NSString *notifyEventInTripValue = (protocol.notifyEventInTrip ? @"1" : @"0");
    NSString *notifyEventOnEndValue = (protocol.notifyEventOnEnd ? @"1" : @"0");
    NSString *resultValue = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",@"00",notifyEventOnEndValue,notifyEventInTripValue,notifyEventOnStartValue,fixOnEndValue,fixInTripValue,fixOnStartValue];
    NSString *cmdValue = [MKBLEBaseSDKAdopter getHexByBinary:resultValue];
    NSString *commandString = [@"ed012701" stringByAppendingString:cmdValue];
    [self configDataWithTaskID:mk_pb_taskConfigMotionModeEventsOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)pb_configMotionModePosStrategyOnStart:(mk_pb_positioningStrategy)strategy
                                     sucBlock:(void (^)(void))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *strategyString = [MKPBSDKDataAdopter fetchPositioningStrategyCommand:strategy];
    NSString *commandString = [@"ed012801" stringByAppendingString:strategyString];
    [self configDataWithTaskID:mk_pb_taskConfigMotionModePosStrategyOnStartOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)pb_configMotionModeNumberOfFixOnStart:(NSInteger)number
                                     sucBlock:(void (^)(void))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock {
    if (number < 1 || number > 255) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *value = [MKBLEBaseSDKAdopter fetchHexValue:number byteLen:1];
    NSString *commandString = [@"ed012901" stringByAppendingString:value];
    [self configDataWithTaskID:mk_pb_taskConfigMotionModeNumberOfFixOnStartOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)pb_configMotionModePosStrategyInTrip:(mk_pb_positioningStrategy)strategy
                                    sucBlock:(void (^)(void))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *strategyString = [MKPBSDKDataAdopter fetchPositioningStrategyCommand:strategy];
    NSString *commandString = [@"ed012a01" stringByAppendingString:strategyString];
    [self configDataWithTaskID:mk_pb_taskConfigMotionModePosStrategyInTripOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)pb_configMotionModeReportIntervalInTrip:(long long)interval
                                       sucBlock:(void (^)(void))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock {
    if (interval < 10 || interval > 86400) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *value = [MKBLEBaseSDKAdopter fetchHexValue:interval byteLen:4];
    NSString *commandString = [@"ed012b04" stringByAppendingString:value];
    [self configDataWithTaskID:mk_pb_taskConfigMotionModeReportIntervalInTripOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)pb_configMotionModePosStrategyOnEnd:(mk_pb_positioningStrategy)strategy
                                   sucBlock:(void (^)(void))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *strategyString = [MKPBSDKDataAdopter fetchPositioningStrategyCommand:strategy];
    NSString *commandString = [@"ed012c01" stringByAppendingString:strategyString];
    [self configDataWithTaskID:mk_pb_taskConfigMotionModePosStrategyOnEndOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)pb_configMotionModeNumberOfFixOnEnd:(NSInteger)number
                                   sucBlock:(void (^)(void))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock {
    if (number < 1 || number > 255) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *value = [MKBLEBaseSDKAdopter fetchHexValue:number byteLen:1];
    NSString *commandString = [@"ed012d01" stringByAppendingString:value];
    [self configDataWithTaskID:mk_pb_taskConfigMotionModeNumberOfFixOnEndOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)pb_configMotionModeReportIntervalOnEnd:(NSInteger)interval
                                      sucBlock:(void (^)(void))sucBlock
                                   failedBlock:(void (^)(NSError *error))failedBlock {
    if (interval < 10 || interval > 300) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *value = [MKBLEBaseSDKAdopter fetchHexValue:interval byteLen:2];
    NSString *commandString = [@"ed012e02" stringByAppendingString:value];
    [self configDataWithTaskID:mk_pb_taskConfigMotionModeReportIntervalOnEndOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

#pragma mark ****************************************Auxiliary************************************************

+ (void)pb_configDownlinkPositioningStrategy:(mk_pb_positioningStrategy)strategy
                                    sucBlock:(void (^)(void))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *strategyString = [MKPBSDKDataAdopter fetchPositioningStrategyCommand:strategy];
    NSString *commandString = [@"ed013001" stringByAppendingString:strategyString];
    [self configDataWithTaskID:mk_pb_taskConfigDownlinkPositioningStrategyOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)pb_configManDownDetection:(BOOL)isOn
                         sucBlock:(void (^)(void))sucBlock
                      failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed01310101" : @"ed01310100");
    [self configDataWithTaskID:mk_pb_taskConfigManDownDetectionOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)pb_configManDownPositioningStrategy:(mk_pb_positioningStrategy)strategy
                                   sucBlock:(void (^)(void))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *strategyString = [MKPBSDKDataAdopter fetchPositioningStrategyCommand:strategy];
    NSString *commandString = [@"ed013201" stringByAppendingString:strategyString];
    [self configDataWithTaskID:mk_pb_taskConfigManDownPositioningStrategyOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)pb_configManDownDetectionTimeout:(NSInteger)timeout
                                sucBlock:(void (^)(void))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock {
    if (timeout < 1 || timeout > 120) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *value = [MKBLEBaseSDKAdopter fetchHexValue:timeout byteLen:1];
    NSString *commandString = [@"ed013301" stringByAppendingString:value];
    [self configDataWithTaskID:mk_pb_taskConfigManDownDetectionTimeoutOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)pb_configManDownReportInterval:(NSInteger)interval
                              sucBlock:(void (^)(void))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock {
    if (interval < 10 || interval > 600) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *value = [MKBLEBaseSDKAdopter fetchHexValue:interval byteLen:2];
    NSString *commandString = [@"ed013402" stringByAppendingString:value];
    [self configDataWithTaskID:mk_pb_taskConfigManDownReportIntervalOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)pb_configNotifyEventOnManDownStart:(BOOL)isOn
                                  sucBlock:(void (^)(void))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed01350101" : @"ed01350100");
    [self configDataWithTaskID:mk_pb_taskConfigNotifyEventOnManDownStartOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)pb_configNotifyEventOnManDownEnd:(BOOL)isOn
                                sucBlock:(void (^)(void))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed01360101" : @"ed01360100");
    [self configDataWithTaskID:mk_pb_taskConfigNotifyEventOnManDownEndOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)pb_configMotorVibrationIntensity:(NSInteger)intensity
                                sucBlock:(void (^)(void))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock {
    if (intensity < 0 || intensity > 100) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *value = [MKBLEBaseSDKAdopter fetchHexValue:intensity byteLen:1];
    NSString *commandString = [@"ed013701" stringByAppendingString:value];
    [self configDataWithTaskID:mk_pb_taskConfigMotorVibrationIntensityOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)pb_configAlarmType:(mk_pb_alarmType)alarmType
                  sucBlock:(void (^)(void))sucBlock
               failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *value = [MKPBSDKDataAdopter fetchAlarmTypeCommand:alarmType];
    NSString *commandString = [@"ed013801" stringByAppendingString:value];
    [self configDataWithTaskID:mk_pb_taskConfigAlarmTypeOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)pb_configExitAlarmTypeLongPressTime:(NSInteger)pressTime
                                   sucBlock:(void (^)(void))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock {
    if (pressTime < 5 || pressTime > 15) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *value = [MKBLEBaseSDKAdopter fetchHexValue:pressTime byteLen:1];
    NSString *commandString = [@"ed013901" stringByAppendingString:value];
    [self configDataWithTaskID:mk_pb_taskConfigExitAlarmTypeLongPressTimeOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)pb_configNotifyEventOnSOSStart:(BOOL)isOn
                              sucBlock:(void (^)(void))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed013a0101" : @"ed013a0100");
    [self configDataWithTaskID:mk_pb_taskConfigNotifyEventOnSOSStartOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)pb_configNotifyEventOnSOSEnd:(BOOL)isOn
                            sucBlock:(void (^)(void))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed013b0101" : @"ed013b0100");
    [self configDataWithTaskID:mk_pb_taskConfigNotifyEventOnSOSEndOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)pb_configSOSPositioningStrategy:(mk_pb_positioningStrategy)strategy
                               sucBlock:(void (^)(void))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *strategyString = [MKPBSDKDataAdopter fetchPositioningStrategyCommand:strategy];
    NSString *commandString = [@"ed013c01" stringByAppendingString:strategyString];
    [self configDataWithTaskID:mk_pb_taskConfigSOSPositioningStrategyOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)pb_configSOSReportInterval:(NSInteger)interval
                          sucBlock:(void (^)(void))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock {
    if (interval < 10 || interval > 600) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *value = [MKBLEBaseSDKAdopter fetchHexValue:interval byteLen:2];
    NSString *commandString = [@"ed013d02" stringByAppendingString:value];
    [self configDataWithTaskID:mk_pb_taskConfigSOSReportIntervalOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

 + (void)pb_configSOSTriggerMode:(mk_pb_sosTriggerMode)triggerMode
                        sucBlock:(void (^)(void))sucBlock
                     failedBlock:(void (^)(NSError *error))failedBlock {
     NSString *mode = [MKPBSDKDataAdopter fetchSOSTriggerModeCommand:triggerMode];
     NSString *commandString = [@"ed013e01" stringByAppendingString:mode];
     [self configDataWithTaskID:mk_pb_taskConfigSOSTriggerModeOperation
                           data:commandString
                       sucBlock:sucBlock
                    failedBlock:failedBlock];
}

+ (void)pb_configNotifyEventOnAlertStart:(BOOL)isOn
                                sucBlock:(void (^)(void))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed013f0101" : @"ed013f0100");
    [self configDataWithTaskID:mk_pb_taskConfigNotifyEventOnAlertStartOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)pb_configNotifyEventOnAlertEnd:(BOOL)isOn
                              sucBlock:(void (^)(void))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed01400101" : @"ed01400100");
    [self configDataWithTaskID:mk_pb_taskConfigNotifyEventOnAlertEndOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)pb_configAlertPositioningStrategy:(mk_pb_positioningStrategy)strategy
                                 sucBlock:(void (^)(void))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *strategyString = [MKPBSDKDataAdopter fetchPositioningStrategyCommand:strategy];
    NSString *commandString = [@"ed014101" stringByAppendingString:strategyString];
    [self configDataWithTaskID:mk_pb_taskConfigAlertPositioningStrategyOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

 + (void)pb_configAlertTriggerMode:(mk_pb_alertTriggerMode)triggerMode
                          sucBlock:(void (^)(void))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock {
     NSString *mode = [MKPBSDKDataAdopter fetchAlertTriggerModeCommand:triggerMode];
     NSString *commandString = [@"ed014201" stringByAppendingString:mode];
     [self configDataWithTaskID:mk_pb_taskConfigAlertTriggerModeOperation
                           data:commandString
                       sucBlock:sucBlock
                    failedBlock:failedBlock];
 }

#pragma mark **************************************** Position ************************************************

+ (void)pb_configGpsPositioningTimeout:(NSInteger)timeout
                              sucBlock:(void (^)(void))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock {
    if (timeout < 60 || timeout > 600) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *value = [MKBLEBaseSDKAdopter fetchHexValue:timeout byteLen:2];
    NSString *commandString = [NSString stringWithFormat:@"%@%@",@"ed015002",value];
    [self configDataWithTaskID:mk_pb_taskConfigGpsPositioningTimeoutOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)pb_configPDOPOfGps:(NSInteger)pdop
                  sucBlock:(void (^)(void))sucBlock
               failedBlock:(void (^)(NSError *error))failedBlock {
    if (pdop < 25 || pdop > 100) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *value = [MKBLEBaseSDKAdopter fetchHexValue:pdop byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@",@"ed015101",value];
    [self configDataWithTaskID:mk_pb_taskConfigPDOPOfGpsOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)pb_configBlePositioningTimeout:(NSInteger)timeout
                              sucBlock:(void (^)(void))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock {
    if (timeout < 1 || timeout > 10) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *value = [MKBLEBaseSDKAdopter fetchHexValue:timeout byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@",@"ed015201",value];
    [self configDataWithTaskID:mk_pb_taskConfigBlePositioningTimeoutOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)pb_configBlePositioningNumberOfMac:(NSInteger)number
                                  sucBlock:(void (^)(void))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock {
    if (number < 1 || number > 15) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *value = [MKBLEBaseSDKAdopter fetchHexValue:number byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@",@"ed015301",value];
    [self configDataWithTaskID:mk_pb_taskConfigBlePositioningNumberOfMacOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)pb_configRssiFilterValue:(NSInteger)rssi
                        sucBlock:(void (^)(void))sucBlock
                     failedBlock:(void (^)(NSError *error))failedBlock {
    if (rssi < -127 || rssi > 0) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *rssiValue = [MKBLEBaseSDKAdopter hexStringFromSignedNumber:rssi];
    NSString *commandString = [NSString stringWithFormat:@"%@%@",@"ed015401",rssiValue];
    [self configDataWithTaskID:mk_pb_taskConfigRssiFilterValueOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)pb_configFilterRelationship:(mk_pb_filterRelationship)relationship
                           sucBlock:(void (^)(void))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *value = [MKBLEBaseSDKAdopter fetchHexValue:relationship byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@",@"ed015501",value];
    [self configDataWithTaskID:mk_pb_taskConfigFilterRelationshipOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)pb_configFilterByMacPreciseMatch:(BOOL)isOn
                                sucBlock:(void (^)(void))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed01560101" : @"ed01560100");
    [self configDataWithTaskID:mk_pb_taskConfigFilterByMacPreciseMatchOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)pb_configFilterByMacReverseFilter:(BOOL)isOn
                                 sucBlock:(void (^)(void))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed01570101" : @"ed01570100");
    [self configDataWithTaskID:mk_pb_taskConfigFilterByMacReverseFilterOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)pb_configFilterMACAddressList:(NSArray <NSString *>*)macList
                             sucBlock:(void (^)(void))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock {
    if (macList.count > 10) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *macString = @"";
    if (MKValidArray(macList)) {
        for (NSString *mac in macList) {
            if ((mac.length % 2 != 0) || !MKValidStr(mac) || mac.length > 12 || ![MKBLEBaseSDKAdopter checkHexCharacter:mac]) {
                [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
                return;
            }
            NSString *tempLen = [MKBLEBaseSDKAdopter fetchHexValue:(mac.length / 2) byteLen:1];
            NSString *string = [tempLen stringByAppendingString:mac];
            macString = [macString stringByAppendingString:string];
        }
    }
    NSString *dataLen = [MKBLEBaseSDKAdopter fetchHexValue:(macString.length / 2) byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"ed0158%@%@",dataLen,macString];
    [self configDataWithTaskID:mk_pb_taskConfigFilterMACAddressListOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)pb_configFilterByAdvNamePreciseMatch:(BOOL)isOn
                                    sucBlock:(void (^)(void))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed01590101" : @"ed01590100");
    [self configDataWithTaskID:mk_pb_taskConfigFilterByAdvNamePreciseMatchOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)pb_configFilterByAdvNameReverseFilter:(BOOL)isOn
                                     sucBlock:(void (^)(void))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed015a0101" : @"ed015a0100");
    [self configDataWithTaskID:mk_pb_taskConfigFilterByAdvNameReverseFilterOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)pb_configFilterAdvNameList:(NSArray <NSString *>*)nameList
                          sucBlock:(void (^)(void))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock {
    if (nameList.count > 10) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    if (!MKValidArray(nameList)) {
        //无列表
        NSString *commandString = @"ee015b010000";
        [self configDataWithTaskID:mk_pb_taskConfigFilterAdvNameListOperation
                              data:commandString
                          sucBlock:sucBlock
                       failedBlock:failedBlock];
        return;
    }
    NSString *nameString = @"";
    if (MKValidArray(nameList)) {
        for (NSString *name in nameList) {
            if (!MKValidStr(name) || name.length > 20 || ![MKBLEBaseSDKAdopter asciiString:name]) {
                [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
                return;
            }
            NSString *nameAscii = @"";
            for (NSInteger i = 0; i < name.length; i ++) {
                int asciiCode = [name characterAtIndex:i];
                nameAscii = [nameAscii stringByAppendingString:[NSString stringWithFormat:@"%1lx",(unsigned long)asciiCode]];
            }
            NSString *tempLen = [MKBLEBaseSDKAdopter fetchHexValue:(nameAscii.length / 2) byteLen:1];
            NSString *string = [tempLen stringByAppendingString:nameAscii];
            nameString = [nameString stringByAppendingString:string];
        }
    }
    NSInteger totalLen = nameString.length / 2;
    NSInteger totalNum = (totalLen / 100);
    if (totalLen % 100 != 0) {
        totalNum ++;
    }
    NSMutableArray *commandList = [NSMutableArray array];
    for (NSInteger i = 0; i < totalNum; i ++) {
        NSString *tempString = @"";
        if (i == totalNum - 1) {
            //最后一帧
            tempString = [nameString substringFromIndex:(i * 200)];
        }else {
            tempString = [nameString substringWithRange:NSMakeRange(i * 200, 200)];
        }
        [commandList addObject:tempString];
    }
    NSString *totalNumberHex = [MKBLEBaseSDKAdopter fetchHexValue:totalNum byteLen:1];
    
    __block NSInteger commandIndex = 0;
    dispatch_queue_t dataQueue = dispatch_queue_create("filterNameListQueue", DISPATCH_QUEUE_SERIAL);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dataQueue);
    //当2s内没有接收到新的数据的时候，也认为是接受超时
    dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), 0.05 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(timer, ^{
        if (commandIndex >= commandList.count) {
            //停止
            dispatch_cancel(timer);
            MKPBOperation *operation = [[MKPBOperation alloc] initOperationWithID:mk_pb_taskConfigFilterAdvNameListOperation commandBlock:^{
                
            } completeBlock:^(NSError * _Nullable error, id  _Nullable returnData) {
                BOOL success = [returnData[@"success"] boolValue];
                if (!success) {
                    [MKBLEBaseSDKAdopter operationSetParamsErrorBlock:failedBlock];
                    return ;
                }
                if (sucBlock) {
                    sucBlock();
                }
            }];
            [[MKPBCentralManager shared] addOperation:operation];
            return;
        }
        NSString *tempCommandString = commandList[commandIndex];
        NSString *indexHex = [MKBLEBaseSDKAdopter fetchHexValue:commandIndex byteLen:1];
        NSString *totalLenHex = [MKBLEBaseSDKAdopter fetchHexValue:(tempCommandString.length / 2) byteLen:1];
        NSString *commandString = [NSString stringWithFormat:@"%@%@%@%@%@",@"ee015b",totalNumberHex,indexHex,totalLenHex,tempCommandString];
        [[MKBLEBaseCentralManager shared] sendDataToPeripheral:commandString characteristic:[MKBLEBaseCentralManager shared].peripheral.pb_custom type:CBCharacteristicWriteWithResponse];
        commandIndex ++;
    });
    dispatch_resume(timer);
}

+ (void)pb_configFilterByBeaconStatus:(BOOL)isOn
                             sucBlock:(void (^)(void))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed015d0101" : @"ed015d0100");
    [self configDataWithTaskID:mk_pb_taskConfigFilterByBeaconStatusOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)pb_configFilterByBeaconMajor:(BOOL)isOn
                            minValue:(NSInteger)minValue
                            maxValue:(NSInteger)maxValue
                            sucBlock:(void (^)(void))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock {
    if (isOn && (minValue < 0 || minValue > 65535 || maxValue < minValue || maxValue > 65535)) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *minString = [MKBLEBaseSDKAdopter fetchHexValue:minValue byteLen:2];
    NSString *maxString = [MKBLEBaseSDKAdopter fetchHexValue:maxValue byteLen:2];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@%@",@"ed015e05",(isOn ? @"01" : @"00"),minString,maxString];
    [self configDataWithTaskID:mk_pb_taskConfigFilterByBeaconMajorOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)pb_configFilterByBeaconMinor:(BOOL)isOn
                            minValue:(NSInteger)minValue
                            maxValue:(NSInteger)maxValue
                            sucBlock:(void (^)(void))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock {
    if (isOn && (minValue < 0 || minValue > 65535 || maxValue < minValue || maxValue > 65535)) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *minString = [MKBLEBaseSDKAdopter fetchHexValue:minValue byteLen:2];
    NSString *maxString = [MKBLEBaseSDKAdopter fetchHexValue:maxValue byteLen:2];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@%@",@"ed015f05",(isOn ? @"01" : @"00"),minString,maxString];
    [self configDataWithTaskID:mk_pb_taskConfigFilterByBeaconMinorOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)pb_configFilterByBeaconUUID:(NSString *)uuid
                           sucBlock:(void (^)(void))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    if (uuid.length > 32) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    if (!uuid) {
        uuid = @"";
    }
    if (MKValidStr(uuid)) {
        if (![MKBLEBaseSDKAdopter checkHexCharacter:uuid] || uuid.length % 2 != 0) {
            [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
            return;
        }
    }
    NSString *lenString = [MKBLEBaseSDKAdopter fetchHexValue:(uuid.length / 2) byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ed0160",lenString,uuid];
    [self configDataWithTaskID:mk_pb_taskConfigFilterByBeaconUUIDOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)pb_configFilterByMKBeaconStatus:(BOOL)isOn
                               sucBlock:(void (^)(void))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed01610101" : @"ed01610100");
    [self configDataWithTaskID:mk_pb_taskConfigFilterByMKBeaconStatusOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)pb_configFilterByMKBeaconMajor:(BOOL)isOn
                              minValue:(NSInteger)minValue
                              maxValue:(NSInteger)maxValue
                              sucBlock:(void (^)(void))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock {
    if (isOn && (minValue < 0 || minValue > 65535 || maxValue < minValue || maxValue > 65535)) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *minString = [MKBLEBaseSDKAdopter fetchHexValue:minValue byteLen:2];
    NSString *maxString = [MKBLEBaseSDKAdopter fetchHexValue:maxValue byteLen:2];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@%@",@"ed016205",(isOn ? @"01" : @"00"),minString,maxString];
    [self configDataWithTaskID:mk_pb_taskConfigFilterByMKBeaconMajorOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)pb_configFilterByMKBeaconMinor:(BOOL)isOn
                              minValue:(NSInteger)minValue
                              maxValue:(NSInteger)maxValue
                              sucBlock:(void (^)(void))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock {
    if (isOn && (minValue < 0 || minValue > 65535 || maxValue < minValue || maxValue > 65535)) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *minString = [MKBLEBaseSDKAdopter fetchHexValue:minValue byteLen:2];
    NSString *maxString = [MKBLEBaseSDKAdopter fetchHexValue:maxValue byteLen:2];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@%@",@"ed016305",(isOn ? @"01" : @"00"),minString,maxString];
    [self configDataWithTaskID:mk_pb_taskConfigFilterByMKBeaconMinorOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)pb_configFilterByMKBeaconUUID:(NSString *)uuid
                             sucBlock:(void (^)(void))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock {
    if (uuid.length > 32) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    if (!uuid) {
        uuid = @"";
    }
    if (MKValidStr(uuid)) {
        if (![MKBLEBaseSDKAdopter checkHexCharacter:uuid] || uuid.length % 2 != 0) {
            [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
            return;
        }
    }
    NSString *lenString = [MKBLEBaseSDKAdopter fetchHexValue:(uuid.length / 2) byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ed0164",lenString,uuid];
    [self configDataWithTaskID:mk_pb_taskConfigFilterByMKBeaconUUIDOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)pb_configFilterByMKBeaconAccStatus:(BOOL)isOn
                                  sucBlock:(void (^)(void))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed01650101" : @"ed01650100");
    [self configDataWithTaskID:mk_pb_taskConfigFilterByMKBeaconAccStatusOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)pb_configFilterByMKBeaconAccMajor:(BOOL)isOn
                                 minValue:(NSInteger)minValue
                                 maxValue:(NSInteger)maxValue
                                 sucBlock:(void (^)(void))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock {
    if (isOn && (minValue < 0 || minValue > 65535 || maxValue < minValue || maxValue > 65535)) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *minString = [MKBLEBaseSDKAdopter fetchHexValue:minValue byteLen:2];
    NSString *maxString = [MKBLEBaseSDKAdopter fetchHexValue:maxValue byteLen:2];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@%@",@"ed016605",(isOn ? @"01" : @"00"),minString,maxString];
    [self configDataWithTaskID:mk_pb_taskConfigFilterByMKBeaconAccMajorOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)pb_configFilterByMKBeaconAccMinor:(BOOL)isOn
                                 minValue:(NSInteger)minValue
                                 maxValue:(NSInteger)maxValue
                                 sucBlock:(void (^)(void))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock {
    if (isOn && (minValue < 0 || minValue > 65535 || maxValue < minValue || maxValue > 65535)) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *minString = [MKBLEBaseSDKAdopter fetchHexValue:minValue byteLen:2];
    NSString *maxString = [MKBLEBaseSDKAdopter fetchHexValue:maxValue byteLen:2];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@%@",@"ed016705",(isOn ? @"01" : @"00"),minString,maxString];
    [self configDataWithTaskID:mk_pb_taskConfigFilterByMKBeaconAccMinorOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)pb_configFilterByMKBeaconAccUUID:(NSString *)uuid
                                sucBlock:(void (^)(void))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock {
    if (uuid.length > 32) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    if (!uuid) {
        uuid = @"";
    }
    if (MKValidStr(uuid)) {
        if (![MKBLEBaseSDKAdopter checkHexCharacter:uuid] || uuid.length % 2 != 0) {
            [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
            return;
        }
    }
    NSString *lenString = [MKBLEBaseSDKAdopter fetchHexValue:(uuid.length / 2) byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ed0168",lenString,uuid];
    [self configDataWithTaskID:mk_pb_taskConfigFilterByMKBeaconAccUUIDOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)pb_configFilterByUIDStatus:(BOOL)isOn
                          sucBlock:(void (^)(void))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed01690101" : @"ed01690100");
    [self configDataWithTaskID:mk_pb_taskConfigFilterByUIDStatusOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)pb_configFilterByUIDNamespaceID:(NSString *)namespaceID
                               sucBlock:(void (^)(void))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock {
    if (namespaceID.length > 20) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    if (!namespaceID) {
        namespaceID = @"";
    }
    if (MKValidStr(namespaceID)) {
        if (![MKBLEBaseSDKAdopter checkHexCharacter:namespaceID] || namespaceID.length % 2 != 0) {
            [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
            return;
        }
    }
    NSString *lenString = [MKBLEBaseSDKAdopter fetchHexValue:(namespaceID.length / 2) byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ed016a",lenString,namespaceID];
    [self configDataWithTaskID:mk_pb_taskConfigFilterByUIDNamespaceIDOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)pb_configFilterByUIDInstanceID:(NSString *)instanceID
                              sucBlock:(void (^)(void))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock {
    if (instanceID.length > 12) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    if (!instanceID) {
        instanceID = @"";
    }
    if (MKValidStr(instanceID)) {
        if (![MKBLEBaseSDKAdopter checkHexCharacter:instanceID] || instanceID.length % 2 != 0) {
            [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
            return;
        }
    }
    NSString *lenString = [MKBLEBaseSDKAdopter fetchHexValue:(instanceID.length / 2) byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ed016b",lenString,instanceID];
    [self configDataWithTaskID:mk_pb_taskConfigFilterByUIDInstanceIDOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)pb_configFilterByURLStatus:(BOOL)isOn
                          sucBlock:(void (^)(void))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed016c0101" : @"ed016c0100");
    [self configDataWithTaskID:mk_pb_taskConfigFilterByURLStatusOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)pb_configFilterByURLContent:(NSString *)content
                           sucBlock:(void (^)(void))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    if (content.length > 29 || ![MKBLEBaseSDKAdopter asciiString:content]) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *tempString = @"";
    for (NSInteger i = 0; i < content.length; i ++) {
        int asciiCode = [content characterAtIndex:i];
        tempString = [tempString stringByAppendingString:[NSString stringWithFormat:@"%1lx",(unsigned long)asciiCode]];
    }
    NSString *lenString = [MKBLEBaseSDKAdopter fetchHexValue:content.length byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ed016d",lenString,tempString];
    [self configDataWithTaskID:mk_pb_taskConfigFilterByURLContentOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)pb_configFilterByTLMStatus:(BOOL)isOn
                          sucBlock:(void (^)(void))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed016e0101" : @"ed016e0100");
    [self configDataWithTaskID:mk_pb_taskConfigFilterByTLMStatusOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)pb_configFilterByTLMVersion:(mk_pb_filterByTLMVersion)version
                           sucBlock:(void (^)(void))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *versionString = @"00";
    if (version == mk_pb_filterByTLMVersion_0) {
        versionString = @"01";
    }else if (version == mk_pb_filterByTLMVersion_1) {
        versionString = @"02";
    }
    NSString *commandString = [NSString stringWithFormat:@"%@%@",@"ed016f01",versionString];
    [self configDataWithTaskID:mk_pb_taskConfigFilterByTLMVersionOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)pb_configBXPAccFilterStatus:(BOOL)isOn
                           sucBlock:(void (^)(void))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed01700101" : @"ed01700100");
    [self configDataWithTaskID:mk_pb_taskConfigBXPAccFilterStatusOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)pb_configBXPTHFilterStatus:(BOOL)isOn
                          sucBlock:(void (^)(void))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed01710101" : @"ed01710100");
    [self configDataWithTaskID:mk_pb_taskConfigBXPTHFilterStatusOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)pb_configFilterByOtherStatus:(BOOL)isOn
                            sucBlock:(void (^)(void))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed01720101" : @"ed01720100");
    [self configDataWithTaskID:mk_pb_taskConfigFilterByOtherStatusOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)pb_configFilterByOtherRelationship:(mk_pb_filterByOther)relationship
                                  sucBlock:(void (^)(void))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *type = [MKPBSDKDataAdopter parseOtherRelationshipToCmd:relationship];
    NSString *commandString = [@"ed017301" stringByAppendingString:type];
    [self configDataWithTaskID:mk_pb_taskConfigFilterByOtherRelationshipOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)pb_configFilterByOtherConditions:(NSArray <mk_pb_BLEFilterRawDataProtocol>*)conditions
                                sucBlock:(void (^)(void))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock {
    if (!conditions || ![conditions isKindOfClass:NSArray.class] || conditions.count > 3) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *dataContent = @"";
    for (id <mk_pb_BLEFilterRawDataProtocol>protocol in conditions) {
        if (![MKPBSDKDataAdopter isConfirmRawFilterProtocol:protocol]) {
            [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
            return;
        }
        NSString *start = [MKBLEBaseSDKAdopter fetchHexValue:protocol.minIndex byteLen:1];
        NSString *end = [MKBLEBaseSDKAdopter fetchHexValue:protocol.maxIndex byteLen:1];
        NSString *content = [NSString stringWithFormat:@"%@%@%@%@",protocol.dataType,start,end,protocol.rawData];
        NSString *tempLenString = [MKBLEBaseSDKAdopter fetchHexValue:(content.length / 2) byteLen:1];
        dataContent = [dataContent stringByAppendingString:[tempLenString stringByAppendingString:content]];
    }
    NSString *lenString = [MKBLEBaseSDKAdopter fetchHexValue:(dataContent.length / 2) byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ed0174",lenString,dataContent];
    [self configDataWithTaskID:mk_pb_taskConfigFilterByOtherConditionsOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

#pragma mark ****************************************设备lorawan信息设置************************************************

+ (void)pb_configRegion:(mk_pb_loraWanRegion)region
               sucBlock:(void (^)(void))sucBlock
            failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = [NSString stringWithFormat:@"%@%@",@"ed018001",[MKPBSDKDataAdopter lorawanRegionString:region]];
    [self configDataWithTaskID:mk_pb_taskConfigRegionOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)pb_configModem:(mk_pb_loraWanModem)modem
              sucBlock:(void (^)(void))sucBlock
           failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (modem == mk_pb_loraWanModemABP) ? @"ed01810101" : @"ed01810102";
    [self configDataWithTaskID:mk_pb_taskConfigModemOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)pb_configDEVEUI:(NSString *)devEUI
               sucBlock:(void (^)(void))sucBlock
            failedBlock:(void (^)(NSError *error))failedBlock {
    if (!MKValidStr(devEUI) || devEUI.length != 16 || ![MKBLEBaseSDKAdopter checkHexCharacter:devEUI]) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *commandString = [@"ed018308" stringByAppendingString:devEUI];
    [self configDataWithTaskID:mk_pb_taskConfigDEVEUIOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)pb_configAPPEUI:(NSString *)appEUI
               sucBlock:(void (^)(void))sucBlock
            failedBlock:(void (^)(NSError *error))failedBlock {
    if (!MKValidStr(appEUI) || appEUI.length != 16 || ![MKBLEBaseSDKAdopter checkHexCharacter:appEUI]) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *commandString = [@"ed018408" stringByAppendingString:appEUI];
    [self configDataWithTaskID:mk_pb_taskConfigAPPEUIOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)pb_configAPPKEY:(NSString *)appKey
               sucBlock:(void (^)(void))sucBlock
            failedBlock:(void (^)(NSError *error))failedBlock {
    if (!MKValidStr(appKey) || appKey.length != 32 || ![MKBLEBaseSDKAdopter checkHexCharacter:appKey]) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *commandString = [@"ed018510" stringByAppendingString:appKey];
    [self configDataWithTaskID:mk_pb_taskConfigAPPKEYOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)pb_configDEVADDR:(NSString *)devAddr
                sucBlock:(void (^)(void))sucBlock
             failedBlock:(void (^)(NSError *error))failedBlock {
    if (!MKValidStr(devAddr) || devAddr.length != 8 || ![MKBLEBaseSDKAdopter checkHexCharacter:devAddr]) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *commandString = [@"ed018604" stringByAppendingString:devAddr];
    [self configDataWithTaskID:mk_pb_taskConfigDEVADDROperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)pb_configAPPSKEY:(NSString *)appSkey
                sucBlock:(void (^)(void))sucBlock
             failedBlock:(void (^)(NSError *error))failedBlock {
    if (!MKValidStr(appSkey) || appSkey.length != 32 || ![MKBLEBaseSDKAdopter checkHexCharacter:appSkey]) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *commandString = [@"ed018710" stringByAppendingString:appSkey];
    [self configDataWithTaskID:mk_pb_taskConfigAPPSKEYOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)pb_configNWKSKEY:(NSString *)nwkSkey
                sucBlock:(void (^)(void))sucBlock
             failedBlock:(void (^)(NSError *error))failedBlock {
    if (!MKValidStr(nwkSkey) || nwkSkey.length != 32 || ![MKBLEBaseSDKAdopter checkHexCharacter:nwkSkey]) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *commandString = [@"ed018810" stringByAppendingString:nwkSkey];
    [self configDataWithTaskID:mk_pb_taskConfigNWKSKEYOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)pb_configMessageType:(mk_pb_loraWanMessageType)messageType
                    sucBlock:(void (^)(void))sucBlock
                 failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (messageType == mk_pb_loraWanUnconfirmMessage) ? @"ed01890100" : @"ed01890101";
    [self configDataWithTaskID:mk_pb_taskConfigMessageTypeOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)pb_configCHL:(NSInteger)chlValue
                 CHH:(NSInteger)chhValue
            sucBlock:(void (^)(void))sucBlock
         failedBlock:(void (^)(NSError *error))failedBlock {
    if (chlValue < 0 || chlValue > 95 || chhValue < chlValue || chhValue > 95) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *lowValue = [MKBLEBaseSDKAdopter fetchHexValue:chlValue byteLen:1];
    NSString *highValue = [MKBLEBaseSDKAdopter fetchHexValue:chhValue byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ed018a02",lowValue,highValue];
    [self configDataWithTaskID:mk_pb_taskConfigCHValueOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)pb_configDR:(NSInteger)drValue
           sucBlock:(void (^)(void))sucBlock
        failedBlock:(void (^)(NSError *error))failedBlock {
    if (drValue < 0 || drValue > 5) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *value = [MKBLEBaseSDKAdopter fetchHexValue:drValue byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@",@"ed018b01",value];
    [self configDataWithTaskID:mk_pb_taskConfigDRValueOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)pb_configUplinkStrategy:(BOOL)isOn
                  transmissions:(NSInteger)transmissions
                            DRL:(NSInteger)DRL
                            DRH:(NSInteger)DRH
                       sucBlock:(void (^)(void))sucBlock
                    failedBlock:(void (^)(NSError *error))failedBlock {
    if (!isOn && (DRL < 0 || DRL > 6 || DRH < DRL || DRH > 6 || transmissions < 1 || transmissions > 2)) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    
    NSString *lowValue = [MKBLEBaseSDKAdopter fetchHexValue:DRL byteLen:1];
    NSString *highValue = [MKBLEBaseSDKAdopter fetchHexValue:DRH byteLen:1];
    NSString *transmissionsValue = [MKBLEBaseSDKAdopter fetchHexValue:transmissions byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@%@%@",@"ed018c04",(isOn ? @"01" : @"00"),transmissionsValue,lowValue,highValue];
    [self configDataWithTaskID:mk_pb_taskConfigUplinkStrategyOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)pb_configDutyCycleStatus:(BOOL)isOn
                        sucBlock:(void (^)(void))sucBlock
                     failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed018d0101" : @"ed018d0100");
    [self configDataWithTaskID:mk_pb_taskConfigDutyCycleStatusOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)pb_configTimeSyncInterval:(NSInteger)interval
                         sucBlock:(void (^)(void))sucBlock
                      failedBlock:(void (^)(NSError *error))failedBlock {
    if (interval < 0 || interval > 255) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *value = [MKBLEBaseSDKAdopter fetchHexValue:interval byteLen:1];
    NSString *commandString = [@"ed018e01" stringByAppendingString:value];
    [self configDataWithTaskID:mk_pb_taskConfigTimeSyncIntervalOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)pb_configLorawanNetworkCheckInterval:(NSInteger)interval
                                    sucBlock:(void (^)(void))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock {
    if (interval < 0 || interval > 255) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *value = [MKBLEBaseSDKAdopter fetchHexValue:interval byteLen:1];
    NSString *commandString = [@"ed018f01" stringByAppendingString:value];
    [self configDataWithTaskID:mk_pb_taskConfigNetworkCheckIntervalOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)pb_configLorawanMaxRetransmissionTimes:(NSInteger)times
                                      sucBlock:(void (^)(void))sucBlock
                                   failedBlock:(void (^)(NSError *error))failedBlock {
    if (times < 1 || times > 8) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *value = [MKBLEBaseSDKAdopter fetchHexValue:times byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@",@"ed019001",value];
    [self configDataWithTaskID:mk_pb_taskConfigMaxRetransmissionTimesOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)pb_configLorawanADRACKLimit:(NSInteger)value
                           sucBlock:(void (^)(void))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    if (value < 1 || value > 255) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *valueString = [MKBLEBaseSDKAdopter fetchHexValue:value byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@",@"ed019101",valueString];
    [self configDataWithTaskID:mk_pb_taskConfigLorawanADRACKLimitOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)pb_configLorawanADRACKDelay:(NSInteger)value
                           sucBlock:(void (^)(void))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    if (value < 1 || value > 255) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *valueString = [MKBLEBaseSDKAdopter fetchHexValue:value byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@",@"ed019201",valueString];
    [self configDataWithTaskID:mk_pb_taskConfigLorawanADRACKDelayOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

#pragma mark - private method
+ (void)configDataWithTaskID:(mk_pb_taskOperationID)taskID
                        data:(NSString *)data
                    sucBlock:(void (^)(void))sucBlock
                 failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addTaskWithTaskID:taskID characteristic:centralManager.peripheral.pb_custom commandData:data successBlock:^(id  _Nonnull returnData) {
        BOOL success = [returnData[@"result"][@"success"] boolValue];
        if (!success) {
            [MKBLEBaseSDKAdopter operationSetParamsErrorBlock:failedBlock];
            return ;
        }
        if (sucBlock) {
            sucBlock();
        }
    } failureBlock:failedBlock];
}

@end
