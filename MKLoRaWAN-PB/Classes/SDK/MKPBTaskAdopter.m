//
//  MKPBTaskAdopter.m
//  MKLoRaWAN-PB_Example
//
//  Created by aa on 2022/3/15.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKPBTaskAdopter.h"

#import <CoreBluetooth/CoreBluetooth.h>

#import "MKBLEBaseSDKAdopter.h"
#import "MKBLEBaseSDKDefines.h"

#import "MKPBOperationID.h"
#import "MKPBSDKDataAdopter.h"

NSString *const mk_pb_totalNumKey = @"mk_pb_totalNumKey";
NSString *const mk_pb_totalIndexKey = @"mk_pb_totalIndexKey";
NSString *const mk_pb_contentKey = @"mk_pb_contentKey";

@implementation MKPBTaskAdopter

+ (NSDictionary *)parseReadDataWithCharacteristic:(CBCharacteristic *)characteristic {
    NSData *readData = characteristic.value;
    NSLog(@"+++++%@-----%@",characteristic.UUID.UUIDString,readData);
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A24"]]) {
        //产品型号
        NSString *tempString = [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
        return [self dataParserGetDataSuccess:@{@"modeID":tempString} operationID:mk_pb_taskReadDeviceModelOperation];
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A26"]]) {
        //firmware
        NSString *tempString = [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
        return [self dataParserGetDataSuccess:@{@"firmware":tempString} operationID:mk_pb_taskReadFirmwareOperation];
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A27"]]) {
        //hardware
        NSString *tempString = [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
        return [self dataParserGetDataSuccess:@{@"hardware":tempString} operationID:mk_pb_taskReadHardwareOperation];
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A28"]]) {
        //soft ware
        NSString *tempString = [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
        return [self dataParserGetDataSuccess:@{@"software":tempString} operationID:mk_pb_taskReadSoftwareOperation];
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A29"]]) {
        //manufacturerKey
        NSString *tempString = [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
        return [self dataParserGetDataSuccess:@{@"manufacturer":tempString} operationID:mk_pb_taskReadManufacturerOperation];
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA00"]]) {
        //密码相关
        NSString *content = [MKBLEBaseSDKAdopter hexStringFromData:readData];
        NSString *state = @"";
        if (content.length == 10) {
            state = [content substringWithRange:NSMakeRange(8, 2)];
        }
        return [self dataParserGetDataSuccess:@{@"state":state} operationID:mk_pb_connectPasswordOperation];
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA04"]]) {
        return [self parseCustomData:readData];
    }
    return @{};
}

+ (NSDictionary *)parseWriteDataWithCharacteristic:(CBCharacteristic *)characteristic {
    return @{};
}

#pragma mark - 数据解析
+ (NSDictionary *)parseCustomData:(NSData *)readData {
    NSString *readString = [MKBLEBaseSDKAdopter hexStringFromData:readData];
    NSString *headerString = [readString substringWithRange:NSMakeRange(0, 2)];
    if ([headerString isEqualToString:@"ee"]) {
        //分包协议
        return [self parsePacketData:readData];
    }
    if (![headerString isEqualToString:@"ed"]) {
        return @{};
    }
    NSInteger dataLen = [MKBLEBaseSDKAdopter getDecimalWithHex:readString range:NSMakeRange(6, 2)];
    if (readData.length != dataLen + 4) {
        return @{};
    }
    NSString *flag = [readString substringWithRange:NSMakeRange(2, 2)];
    NSString *cmd = [readString substringWithRange:NSMakeRange(4, 2)];
    NSString *content = [readString substringWithRange:NSMakeRange(8, dataLen * 2)];
    //不分包协议
    if ([flag isEqualToString:@"00"]) {
        //读取
        return [self parseCustomReadData:content cmd:cmd data:readData];
    }
    if ([flag isEqualToString:@"01"]) {
        return [self parseCustomConfigData:content cmd:cmd];
    }
    return @{};
}

+ (NSDictionary *)parsePacketData:(NSData *)readData {
    NSString *readString = [MKBLEBaseSDKAdopter hexStringFromData:readData];
    NSString *flag = [readString substringWithRange:NSMakeRange(2, 2)];
    NSString *cmd = [readString substringWithRange:NSMakeRange(4, 2)];
    if ([flag isEqualToString:@"00"]) {
        //读取
        NSString *totalNum = [MKBLEBaseSDKAdopter getDecimalStringWithHex:readString range:NSMakeRange(6, 2)];
        NSString *index = [MKBLEBaseSDKAdopter getDecimalStringWithHex:readString range:NSMakeRange(8, 2)];
        NSInteger len = [MKBLEBaseSDKAdopter getDecimalWithHex:readString range:NSMakeRange(10, 2)];
        if ([index integerValue] >= [totalNum integerValue]) {
            return @{};
        }
        if ([cmd isEqualToString:@"5b"]) {
            //读取Adv Name过滤规则
            NSData *subData = [readData subdataWithRange:NSMakeRange(6, len)];
            NSDictionary *resultDic= @{
                mk_pb_totalNumKey:totalNum,
                mk_pb_totalIndexKey:index,
                mk_pb_contentKey:(subData ? subData : [NSData data]),
            };
            return [self dataParserGetDataSuccess:resultDic operationID:mk_pb_taskReadFilterAdvNameListOperation];
        }
    }
    if ([flag isEqualToString:@"01"]) {
        //配置
        mk_pb_taskOperationID operationID = mk_pb_defaultTaskOperationID;
        NSString *content = [readString substringWithRange:NSMakeRange(8, 2)];
        BOOL success = [content isEqualToString:@"01"];
        
        if ([cmd isEqualToString:@"5b"]) {
            //配置Adv Name过滤规则
            operationID = mk_pb_taskConfigFilterAdvNameListOperation;
        }
        return [self dataParserGetDataSuccess:@{@"success":@(success)} operationID:operationID];
    }
    return @{};
}

+ (NSDictionary *)parseCustomReadData:(NSString *)content cmd:(NSString *)cmd data:(NSData *)data {
    mk_pb_taskOperationID operationID = mk_pb_defaultTaskOperationID;
    NSDictionary *resultDic = @{};
    
    if ([cmd isEqualToString:@"01"]) {
        
    }else if ([cmd isEqualToString:@"05"]) {
        //读取电池电压
        resultDic = @{
            @"voltage":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_pb_taskReadBatteryVoltageOperation;
    }else if ([cmd isEqualToString:@"06"]) {
        //读取按键关机状态
        BOOL isOn = ([content isEqualToString:@"01"]);
        resultDic = @{
            @"isOn":@(isOn)
        };
        operationID = mk_pb_taskReadTurnOffDeviceByButtonStatusOperation;
    }else if ([cmd isEqualToString:@"07"]) {
        //读取低电档位
        resultDic = @{
            @"value":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_pb_taskReadLowPowerPromptOperation;
    }else if ([cmd isEqualToString:@"08"]) {
        //读取低电上报状态
        BOOL isOn = ([content isEqualToString:@"01"]);
        resultDic = @{
            @"isOn":@(isOn)
        };
        operationID = mk_pb_taskReadLowPowerPayloadOperation;
    }else if ([cmd isEqualToString:@"09"]) {
        //读取设备广播名称
        NSData *nameData = [data subdataWithRange:NSMakeRange(4, data.length - 4)];
        NSString *deviceName = [[NSString alloc] initWithData:nameData encoding:NSUTF8StringEncoding];
        resultDic = @{
            @"deviceName":(MKValidStr(deviceName) ? deviceName : @""),
        };
        operationID = mk_pb_taskReadDeviceNameOperation;
    }else if ([cmd isEqualToString:@"0a"]) {
        //读取广播间隔
        resultDic = @{
            @"interval":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_pb_taskReadAdvIntervalOperation;
    }else if ([cmd isEqualToString:@"0b"]) {
        //读取设备Tx Power
        NSString *txPower = [MKPBSDKDataAdopter fetchTxPowerValueString:content];
        resultDic = @{@"txPower":txPower};
        operationID = mk_pb_taskReadTxPowerOperation;
    }else if ([cmd isEqualToString:@"0c"]) {
        //读取广播超时时长
        resultDic = @{
            @"timeout":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_pb_taskReadBroadcastTimeoutOperation;
    }else if ([cmd isEqualToString:@"0d"]) {
        //读取密码开关
        BOOL need = ([content isEqualToString:@"01"]);
        resultDic = @{
            @"need":@(need)
        };
        operationID = mk_pb_taskReadConnectationNeedPasswordOperation;
    }else if ([cmd isEqualToString:@"0e"]) {
        //读取密码
        NSData *passwordData = [data subdataWithRange:NSMakeRange(4, data.length - 4)];
        NSString *password = [[NSString alloc] initWithData:passwordData encoding:NSUTF8StringEncoding];
        resultDic = @{
            @"password":(MKValidStr(password) ? password : @""),
        };
        operationID = mk_pb_taskReadPasswordOperation;
    }else if ([cmd isEqualToString:@"0f"]) {
        //读取时区
        resultDic = @{
            @"timeZone":[MKBLEBaseSDKAdopter signedHexTurnString:content],
        };
        operationID = mk_pb_taskReadTimeZoneOperation;
    }else if ([cmd isEqualToString:@"11"]) {
        //读取三轴唤醒触发阈值
        NSString *threshold = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)];
        resultDic = @{
            @"threshold":threshold,
        };
        operationID = mk_pb_taskReadThreeAxisWakeupThresholdOperation;
    }else if ([cmd isEqualToString:@"12"]) {
        //读取三轴唤醒判断时间
        NSString *duration = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)];
        resultDic = @{
            @"duration":duration,
        };
        operationID = mk_pb_taskReadThreeAxisWakeupDurationOperation;
    }else if ([cmd isEqualToString:@"13"]) {
        //读取三轴运动触发阈值
        NSString *threshold = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)];
        resultDic = @{
            @"threshold":threshold,
        };
        operationID = mk_pb_taskReadThreeAxisMotionThresholdOperation;
    }else if ([cmd isEqualToString:@"14"]) {
        //读取三轴运动判断时间
        NSString *duration = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)];
        resultDic = @{
            @"duration":duration,
        };
        operationID = mk_pb_taskReadThreeAxisMotionDurationOperation;
    }else if ([cmd isEqualToString:@"15"]) {
        //读取运动结束判断时间
        NSString *time = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)];
        resultDic = @{
            @"time":time,
        };
        operationID = mk_pb_taskReadMotionModeTripEndTimeoutOperation;
    }else if ([cmd isEqualToString:@"17"]) {
        //读取MAC地址
        NSString *macAddress = [NSString stringWithFormat:@"%@:%@:%@:%@:%@:%@",[content substringWithRange:NSMakeRange(0, 2)],[content substringWithRange:NSMakeRange(2, 2)],[content substringWithRange:NSMakeRange(4, 2)],[content substringWithRange:NSMakeRange(6, 2)],[content substringWithRange:NSMakeRange(8, 2)],[content substringWithRange:NSMakeRange(10, 2)]];
        resultDic = @{@"macAddress":[macAddress uppercaseString]};
        operationID = mk_pb_taskReadMacAddressOperation;
    }else if ([cmd isEqualToString:@"20"]) {
        //读取关机信息上报状态
        BOOL isOn = ([content isEqualToString:@"01"]);
        resultDic = @{
            @"isOn":@(isOn)
        };
        operationID = mk_pb_taskReadShutDownPayloadStatusOperation;
    }else if ([cmd isEqualToString:@"21"]) {
        //读取工作模式
        resultDic = @{
            @"mode":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_pb_taskReadWorkModeOperation;
    }else if ([cmd isEqualToString:@"22"]) {
        //读取心跳包上报间隔
        resultDic = @{
            @"interval":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_pb_taskReadHeartbeatIntervalOperation;
    }else if ([cmd isEqualToString:@"23"]) {
        //读取定期模式上报间隔
        NSString *interval = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)];
        resultDic = @{
            @"interval":interval,
        };
        operationID = mk_pb_taskReadPeriodicModeReportIntervalOperation;
    }else if ([cmd isEqualToString:@"24"]) {
        //读取定时模式定位策略
        NSString *strategy = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)];
        resultDic = @{
            @"strategy":strategy,
        };
        operationID = mk_pb_taskReadPeriodicModePositioningStrategyOperation;
    }else if ([cmd isEqualToString:@"25"]) {
        //读取定时模式时间点
        NSArray *list = [MKPBSDKDataAdopter parseTimingModeReportingTimePoint:content];
        
        resultDic = @{
            @"pointList":list,
        };
        operationID = mk_pb_taskReadTimingModeReportingTimePointOperation;
    }else if ([cmd isEqualToString:@"26"]) {
        //读取定时模式定位策略
        NSString *strategy = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)];
        resultDic = @{
            @"strategy":strategy,
        };
        operationID = mk_pb_taskReadTimingModePositioningStrategyOperation;
    }else if ([cmd isEqualToString:@"27"]) {
        //读取运动模式事件
        NSString *binaryHex = [MKBLEBaseSDKAdopter binaryByhex:[content substringWithRange:NSMakeRange(0, content.length)]];
        
        BOOL fixOnStart = [[binaryHex substringWithRange:NSMakeRange(7, 1)] isEqualToString:@"1"];
        BOOL fixInTrip = [[binaryHex substringWithRange:NSMakeRange(6, 1)] isEqualToString:@"1"];
        BOOL fixOnEnd = [[binaryHex substringWithRange:NSMakeRange(5, 1)] isEqualToString:@"1"];
        BOOL notifyEventOnStart = [[binaryHex substringWithRange:NSMakeRange(4, 1)] isEqualToString:@"1"];
        BOOL notifyEventInTrip = [[binaryHex substringWithRange:NSMakeRange(3, 1)] isEqualToString:@"1"];
        BOOL notifyEventOnEnd = [[binaryHex substringWithRange:NSMakeRange(2, 1)] isEqualToString:@"1"];
        
        resultDic = @{
            @"fixOnStart":@(fixOnStart),
            @"fixInTrip":@(fixInTrip),
            @"fixOnEnd":@(fixOnEnd),
            @"notifyEventOnStart":@(notifyEventOnStart),
            @"notifyEventInTrip":@(notifyEventInTrip),
            @"notifyEventOnEnd":@(notifyEventOnEnd),
        };
        operationID = mk_pb_taskReadMotionModeEventsOperation;
    }else if ([cmd isEqualToString:@"28"]) {
        //读取运动开始定位策略
        NSString *strategy = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)];
        resultDic = @{
            @"strategy":strategy,
        };
        operationID = mk_pb_taskReadMotionModePosStrategyOnStartOperation;
    }else if ([cmd isEqualToString:@"29"]) {
        //读取运动开始定位上报次数
        NSString *number = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)];
        resultDic = @{
            @"number":number,
        };
        operationID = mk_pb_taskReadMotionModeNumberOfFixOnStartOperation;
    }else if ([cmd isEqualToString:@"2a"]) {
        //读取运动中定位策略
        NSString *strategy = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)];
        resultDic = @{
            @"strategy":strategy,
        };
        operationID = mk_pb_taskReadMotionModePosStrategyInTripOperation;
    }else if ([cmd isEqualToString:@"2b"]) {
        //读取运动中定位间隔
        NSString *interval = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)];
        resultDic = @{
            @"interval":interval,
        };
        operationID = mk_pb_taskReadMotionModeReportIntervalInTripOperation;
    }else if ([cmd isEqualToString:@"2c"]) {
        //读取运动结束定位策略
        NSString *strategy = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)];
        resultDic = @{
            @"strategy":strategy,
        };
        operationID = mk_pb_taskReadMotionModePosStrategyOnEndOperation;
    }else if ([cmd isEqualToString:@"2d"]) {
        //读取运动结束判断时间
        NSString *number = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)];
        resultDic = @{
            @"number":number,
        };
        operationID = mk_pb_taskReadMotionModeNumberOfFixOnEndOperation;
    }else if ([cmd isEqualToString:@"2e"]) {
        //读取运动结束定位间隔
        resultDic = @{
            @"interval":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_pb_taskReadMotionModeReportIntervalOnEndOperation;
    }else if ([cmd isEqualToString:@"30"]) {
        //读取下行定位请求定位策略
        NSString *strategy = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)];
        resultDic = @{
            @"strategy":strategy,
        };
        operationID = mk_pb_taskReadDownlinkPositioningStrategyOperation;
    }else if ([cmd isEqualToString:@"31"]) {
        //读取ManDown功能开关
        BOOL isOn = ([content isEqualToString:@"01"]);
        resultDic = @{
            @"isOn":@(isOn)
        };
        operationID = mk_pb_taskReadManDownDetectionOperation;
    }else if ([cmd isEqualToString:@"32"]) {
        //读取ManDown定位请求定位策略
        NSString *strategy = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)];
        resultDic = @{
            @"strategy":strategy,
        };
        operationID = mk_pb_taskReadManDownPositioningStrategyOperation;
    }else if ([cmd isEqualToString:@"33"]) {
        //读取ManDown检测超时时间
        resultDic = @{
            @"timeout":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_pb_taskReadManDownDetectionTimeoutOperation;
    }else if ([cmd isEqualToString:@"34"]) {
        //读取ManDown定位数据上报间隔
        resultDic = @{
            @"interval":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_pb_taskReadManDownReportIntervalOperation;
    }else if ([cmd isEqualToString:@"35"]) {
        //读取ManDown开始时间通知开关
        BOOL isOn = ([content isEqualToString:@"01"]);
        resultDic = @{
            @"isOn":@(isOn)
        };
        operationID = mk_pb_taskReadNotifyEventOnManDownStartOperation;
    }else if ([cmd isEqualToString:@"36"]) {
        //读取ManDown结束时间通知开关
        BOOL isOn = ([content isEqualToString:@"01"]);
        resultDic = @{
            @"isOn":@(isOn)
        };
        operationID = mk_pb_taskReadNotifyEventOnManDownEndOperation;
    }else if ([cmd isEqualToString:@"37"]) {
        //读取马达震动强度
        resultDic = @{
            @"intensity":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_pb_taskReadMotorVibrationIntensityOperation;
    }else if ([cmd isEqualToString:@"38"]) {
        //读取报警类型
        resultDic = @{
            @"alarmType":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_pb_taskReadAlarmTypeOperation;
    }else if ([cmd isEqualToString:@"39"]) {
        //读取长按退出报警的时长
        resultDic = @{
            @"time":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_pb_taskReadExitAlarmTypeLongPressTimeOperation;
    }else if ([cmd isEqualToString:@"3a"]) {
        //读取SOS开始事件通知
        BOOL isOn = ([content isEqualToString:@"01"]);
        resultDic = @{
            @"isOn":@(isOn)
        };
        operationID = mk_pb_taskReadNotifyEventOnSOSStartOperation;
    }else if ([cmd isEqualToString:@"3b"]) {
        //读取SOS结束事件通知
        BOOL isOn = ([content isEqualToString:@"01"]);
        resultDic = @{
            @"isOn":@(isOn)
        };
        operationID = mk_pb_taskReadNotifyEventOnSOSEndOperation;
    }else if ([cmd isEqualToString:@"3c"]) {
        //读取SOS报警定位策略
        NSString *strategy = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)];
        resultDic = @{
            @"strategy":strategy,
        };
        operationID = mk_pb_taskReadSOSPositioningStrategyOperation;
    }else if ([cmd isEqualToString:@"3d"]) {
        //读取SOS报警的定位数据上报间隔
        resultDic = @{
            @"interval":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_pb_taskReadSOSReportIntervalOperation;
    }else if ([cmd isEqualToString:@"3e"]) {
        //读取SOS报警触发方式
        resultDic = @{
            @"triggerMode":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_pb_taskReadSOSTriggerModeOperation;
    }else if ([cmd isEqualToString:@"3f"]) {
        //读取Alert开始事件通知
        BOOL isOn = ([content isEqualToString:@"01"]);
        resultDic = @{
            @"isOn":@(isOn)
        };
        operationID = mk_pb_taskReadNotifyEventOnAlertStartOperation;
    }else if ([cmd isEqualToString:@"40"]) {
        //读取Alert结束事件通知
        BOOL isOn = ([content isEqualToString:@"01"]);
        resultDic = @{
            @"isOn":@(isOn)
        };
        operationID = mk_pb_taskReadNotifyEventOnAlertEndOperation;
    }else if ([cmd isEqualToString:@"41"]) {
        //读取Alert报警定位策略
        NSString *strategy = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)];
        resultDic = @{
            @"strategy":strategy,
        };
        operationID = mk_pb_taskReadAlertPositioningStrategyOperation;
    }else if ([cmd isEqualToString:@"42"]) {
        //读取Alert报警触发方式
        resultDic = @{
            @"triggerMode":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_pb_taskReadAlertTriggerModeOperation;
    }else if ([cmd isEqualToString:@"50"]) {
        //读取GPS定位超时时间
        resultDic = @{
            @"timeout":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_pb_taskReadGpsPositioningTimeoutOperation;
    }else if ([cmd isEqualToString:@"51"]) {
        //读取PDOP
        resultDic = @{
            @"pdop":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_pb_taskReadPDOPOfGpsOperation;
    }else if ([cmd isEqualToString:@"52"]) {
        //读取蓝牙定位超时时间
        resultDic = @{
            @"timeout":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_pb_taskReadBlePositioningTimeoutOperation;
    }else if ([cmd isEqualToString:@"53"]) {
        //读取蓝牙定位MAC数量
        resultDic = @{
            @"number":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_pb_taskReadBlePositioningNumberOfMacOperation;
    }else if ([cmd isEqualToString:@"54"]) {
        //读取RSSI过滤规则
        resultDic = @{
            @"rssi":[NSString stringWithFormat:@"%ld",(long)[[MKBLEBaseSDKAdopter signedHexTurnString:content] integerValue]],
        };
        operationID = mk_pb_taskReadRssiFilterValueOperation;
    }else if ([cmd isEqualToString:@"55"]) {
        //读取广播内容过滤逻辑
        resultDic = @{
            @"relationship":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_pb_taskReadFilterRelationshipOperation;
    }else if ([cmd isEqualToString:@"56"]) {
        //读取精准过滤MAC开关
        BOOL isOn = ([content isEqualToString:@"01"]);
        resultDic = @{
            @"isOn":@(isOn)
        };
        operationID = mk_pb_taskReadFilterByMacPreciseMatchOperation;
    }else if ([cmd isEqualToString:@"57"]) {
        //读取反向过滤MAC开关
        BOOL isOn = ([content isEqualToString:@"01"]);
        resultDic = @{
            @"isOn":@(isOn)
        };
        operationID = mk_pb_taskReadFilterByMacReverseFilterOperation;
    }else if ([cmd isEqualToString:@"58"]) {
        //读取MAC过滤列表
        NSArray *macList = [MKPBSDKDataAdopter parseFilterMacList:content];
        resultDic = @{
            @"macList":(MKValidArray(macList) ? macList : @[]),
        };
        operationID = mk_pb_taskReadFilterMACAddressListOperation;
    }else if ([cmd isEqualToString:@"59"]) {
        //读取精准过滤Adv Name开关
        BOOL isOn = ([content isEqualToString:@"01"]);
        resultDic = @{
            @"isOn":@(isOn)
        };
        operationID = mk_pb_taskReadFilterByAdvNamePreciseMatchOperation;
    }else if ([cmd isEqualToString:@"5a"]) {
        //读取反向过滤Adv Name开关
        BOOL isOn = ([content isEqualToString:@"01"]);
        resultDic = @{
            @"isOn":@(isOn)
        };
        operationID = mk_pb_taskReadFilterByAdvNameReverseFilterOperation;
    }else if ([cmd isEqualToString:@"5c"]) {
        //读取过滤设备类型开关
        BOOL unknown = ([[content substringWithRange:NSMakeRange(0, 2)] isEqualToString:@"01"]);
        BOOL iBeacon = ([[content substringWithRange:NSMakeRange(2, 2)] isEqualToString:@"01"]);
        BOOL uid = ([[content substringWithRange:NSMakeRange(4, 2)] isEqualToString:@"01"]);
        BOOL url = ([[content substringWithRange:NSMakeRange(6, 2)] isEqualToString:@"01"]);
        BOOL tlm = ([[content substringWithRange:NSMakeRange(8, 2)] isEqualToString:@"01"]);
        BOOL bxp_acc = ([[content substringWithRange:NSMakeRange(10, 2)] isEqualToString:@"01"]);
        BOOL bxp_th = ([[content substringWithRange:NSMakeRange(12, 2)] isEqualToString:@"01"]);
        BOOL mk_iBeacon = ([[content substringWithRange:NSMakeRange(14, 2)] isEqualToString:@"01"]);
        BOOL mk_iBeacon_acc = ([[content substringWithRange:NSMakeRange(16, 2)] isEqualToString:@"01"]);

        resultDic = @{
            @"unknown":@(unknown),
            @"iBeacon":@(iBeacon),
            @"uid":@(uid),
            @"url":@(url),
            @"tlm":@(tlm),
            @"bxp_acc":@(bxp_acc),
            @"bxp_th":@(bxp_th),
            @"mk_iBeacon":@(mk_iBeacon),
            @"mk_iBeacon_acc":@(mk_iBeacon_acc)
        };
        operationID = mk_pb_taskReadFilterTypeStatusOperation;
    }else if ([cmd isEqualToString:@"5d"]) {
        //读取iBeacon类型过滤开关
        BOOL isOn = ([content isEqualToString:@"01"]);
        resultDic = @{
            @"isOn":@(isOn)
        };
        operationID = mk_pb_taskReadFilterByBeaconStatusOperation;
    }else if ([cmd isEqualToString:@"5e"]) {
        //读取iBeacon类型过滤的Major范围
        BOOL isOn = ([[content substringWithRange:NSMakeRange(0, 2)] isEqualToString:@"01"]);
        NSString *minValue = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(2, 4)];
        NSString *maxValue = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(6, 4)];
        resultDic = @{
            @"isOn":@(isOn),
            @"maxValue":maxValue,
            @"minValue":minValue,
        };
        operationID = mk_pb_taskReadFilterByBeaconMajorRangeOperation;
    }else if ([cmd isEqualToString:@"5f"]) {
        //读取iBeacon类型过滤的Minor范围
        BOOL isOn = ([[content substringWithRange:NSMakeRange(0, 2)] isEqualToString:@"01"]);
        NSString *minValue = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(2, 4)];
        NSString *maxValue = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(6, 4)];
        resultDic = @{
            @"isOn":@(isOn),
            @"maxValue":maxValue,
            @"minValue":minValue,
        };
        operationID = mk_pb_taskReadFilterByBeaconMinorRangeOperation;
    }else if ([cmd isEqualToString:@"60"]) {
        //读取iBeacon类型过滤的UUID
        resultDic = @{
            @"uuid":content,
        };
        operationID = mk_pb_taskReadFilterByBeaconUUIDOperation;
    }else if ([cmd isEqualToString:@"61"]) {
        //读取MKiBeacon类型过滤开关
        BOOL isOn = ([content isEqualToString:@"01"]);
        resultDic = @{
            @"isOn":@(isOn)
        };
        operationID = mk_pb_taskReadFilterByMKBeaconStatusOperation;
    }else if ([cmd isEqualToString:@"62"]) {
        //读取MKiBeacon类型过滤的Major范围
        BOOL isOn = ([[content substringWithRange:NSMakeRange(0, 2)] isEqualToString:@"01"]);
        NSString *minValue = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(2, 4)];
        NSString *maxValue = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(6, 4)];
        resultDic = @{
            @"isOn":@(isOn),
            @"maxValue":maxValue,
            @"minValue":minValue,
        };
        operationID = mk_pb_taskReadFilterByMKBeaconMajorRangeOperation;
    }else if ([cmd isEqualToString:@"63"]) {
        //读取iBeacon类型过滤的Minor范围
        BOOL isOn = ([[content substringWithRange:NSMakeRange(0, 2)] isEqualToString:@"01"]);
        NSString *minValue = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(2, 4)];
        NSString *maxValue = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(6, 4)];
        resultDic = @{
            @"isOn":@(isOn),
            @"maxValue":maxValue,
            @"minValue":minValue,
        };
        operationID = mk_pb_taskReadFilterByMKBeaconMinorRangeOperation;
    }else if ([cmd isEqualToString:@"64"]) {
        //读取iBeacon类型过滤的UUID
        resultDic = @{
            @"uuid":content,
        };
        operationID = mk_pb_taskReadFilterByMKBeaconUUIDOperation;
    }else if ([cmd isEqualToString:@"65"]) {
        //读取MKiBeacon&ACC类型过滤开关
        BOOL isOn = ([content isEqualToString:@"01"]);
        resultDic = @{
            @"isOn":@(isOn)
        };
        operationID = mk_pb_taskReadFilterByMKBeaconAccStatusOperation;
    }else if ([cmd isEqualToString:@"66"]) {
        //读取MKiBeacon&ACC类型过滤的Major范围
        BOOL isOn = ([[content substringWithRange:NSMakeRange(0, 2)] isEqualToString:@"01"]);
        NSString *minValue = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(2, 4)];
        NSString *maxValue = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(6, 4)];
        resultDic = @{
            @"isOn":@(isOn),
            @"maxValue":maxValue,
            @"minValue":minValue,
        };
        operationID = mk_pb_taskReadFilterByMKBeaconAccMajorRangeOperation;
    }else if ([cmd isEqualToString:@"67"]) {
        //读取MKiBeacon&ACC类型过滤的Minor范围
        BOOL isOn = ([[content substringWithRange:NSMakeRange(0, 2)] isEqualToString:@"01"]);
        NSString *minValue = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(2, 4)];
        NSString *maxValue = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(6, 4)];
        resultDic = @{
            @"isOn":@(isOn),
            @"maxValue":maxValue,
            @"minValue":minValue,
        };
        operationID = mk_pb_taskReadFilterByMKBeaconAccMinorRangeOperation;
    }else if ([cmd isEqualToString:@"68"]) {
        //读取MKiBeacon&ACC类型过滤的UUID
        resultDic = @{
            @"uuid":content,
        };
        operationID = mk_pb_taskReadFilterByMKBeaconAccUUIDOperation;
    }else if ([cmd isEqualToString:@"69"]) {
        //读取UID类型过滤开关
        BOOL isOn = ([content isEqualToString:@"01"]);
        resultDic = @{
            @"isOn":@(isOn)
        };
        operationID = mk_pb_taskReadFilterByUIDStatusOperation;
    }else if ([cmd isEqualToString:@"6a"]) {
        //读取UID类型过滤的Namespace ID
        resultDic = @{
            @"namespaceID":content,
        };
        operationID = mk_pb_taskReadFilterByUIDNamespaceIDOperation;
    }else if ([cmd isEqualToString:@"6b"]) {
        //读取UID类型过滤的Instance ID
        resultDic = @{
            @"instanceID":content,
        };
        operationID = mk_pb_taskReadFilterByUIDInstanceIDOperation;
    }else if ([cmd isEqualToString:@"6c"]) {
        //读取URL类型过滤开关
        BOOL isOn = ([content isEqualToString:@"01"]);
        resultDic = @{
            @"isOn":@(isOn)
        };
        operationID = mk_pb_taskReadFilterByURLStatusOperation;
    }else if ([cmd isEqualToString:@"6d"]) {
        //读取URL类型过滤内容
        NSString *url = @"";
        if (data.length > 5) {
            NSData *urlData = [data subdataWithRange:NSMakeRange(4, data.length - 4)];
            url = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
        }
        
        resultDic = @{
            @"url":(MKValidStr(url) ? url : @""),
        };
        operationID = mk_pb_taskReadFilterByURLContentOperation;
    }else if ([cmd isEqualToString:@"6e"]) {
        //读取TLM类型过滤开关
        BOOL isOn = ([content isEqualToString:@"01"]);
        resultDic = @{
            @"isOn":@(isOn)
        };
        operationID = mk_pb_taskReadFilterByTLMStatusOperation;
    }else if ([cmd isEqualToString:@"6f"]) {
        //读取TLM过滤数据类型
        NSString *version = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)];
        resultDic = @{
            @"version":version
        };
        operationID = mk_pb_taskReadFilterByTLMVersionOperation;
    }else if ([cmd isEqualToString:@"70"]) {
        //读取BeaconX Pro-ACC设备过滤开关
        BOOL isOn = ([content isEqualToString:@"01"]);
        resultDic = @{
            @"isOn":@(isOn)
        };
        operationID = mk_pb_taskReadBXPAccFilterStatusOperation;
    }else if ([cmd isEqualToString:@"71"]) {
        //读取BeaconX Pro-T&H设备过滤开关
        BOOL isOn = ([content isEqualToString:@"01"]);
        resultDic = @{
            @"isOn":@(isOn)
        };
        operationID = mk_pb_taskReadBXPTHFilterStatusOperation;
    }else if ([cmd isEqualToString:@"72"]) {
        //读取Other过滤条件开关
        BOOL isOn = ([content isEqualToString:@"01"]);
        resultDic = @{
            @"isOn":@(isOn)
        };
        operationID = mk_pb_taskReadFilterByOtherStatusOperation;
    }else if ([cmd isEqualToString:@"73"]) {
        //读取Other过滤条件的逻辑关系
        NSString *relationship = [MKPBSDKDataAdopter parseOtherRelationship:content];
        resultDic = @{
            @"relationship":relationship,
        };
        operationID = mk_pb_taskReadFilterByOtherRelationshipOperation;
    }else if ([cmd isEqualToString:@"74"]) {
        //读取Other的过滤条件列表
        NSArray *conditionList = [MKPBSDKDataAdopter parseOtherFilterConditionList:content];
        resultDic = @{
            @"conditionList":conditionList,
        };
        operationID = mk_pb_taskReadFilterByOtherConditionsOperation;
    }else if ([cmd isEqualToString:@"80"]) {
        //读取LoRaWAN频段
        resultDic = @{
            @"region":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_pb_taskReadLorawanRegionOperation;
    }else if ([cmd isEqualToString:@"81"]) {
        //读取LoRaWAN入网类型
        resultDic = @{
            @"modem":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_pb_taskReadLorawanModemOperation;
    }else if ([cmd isEqualToString:@"82"]) {
        //读取LoRaWAN网络状态
        resultDic = @{
            @"status":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_pb_taskReadLorawanNetworkStatusOperation;
    }else if ([cmd isEqualToString:@"83"]) {
        //读取LoRaWAN DEVEUI
        resultDic = @{
            @"devEUI":content,
        };
        operationID = mk_pb_taskReadLorawanDEVEUIOperation;
    }else if ([cmd isEqualToString:@"84"]) {
        //读取LoRaWAN APPEUI
        resultDic = @{
            @"appEUI":content
        };
        operationID = mk_pb_taskReadLorawanAPPEUIOperation;
    }else if ([cmd isEqualToString:@"85"]) {
        //读取LoRaWAN APPKEY
        resultDic = @{
            @"appKey":content
        };
        operationID = mk_pb_taskReadLorawanAPPKEYOperation;
    }else if ([cmd isEqualToString:@"86"]) {
        //读取LoRaWAN DEVADDR
        resultDic = @{
            @"devAddr":content
        };
        operationID = mk_pb_taskReadLorawanDEVADDROperation;
    }else if ([cmd isEqualToString:@"87"]) {
        //读取LoRaWAN APPSKEY
        resultDic = @{
            @"appSkey":content
        };
        operationID = mk_pb_taskReadLorawanAPPSKEYOperation;
    }else if ([cmd isEqualToString:@"88"]) {
        //读取LoRaWAN nwkSkey
        resultDic = @{
            @"nwkSkey":content
        };
        operationID = mk_pb_taskReadLorawanNWKSKEYOperation;
    }else if ([cmd isEqualToString:@"89"]) {
        //读取LoRaWAN 上行数据类型
        resultDic = @{
            @"messageType":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_pb_taskReadLorawanMessageTypeOperation;
    }else if ([cmd isEqualToString:@"8a"]) {
        //读取LoRaWAN CH
        resultDic = @{
            @"CHL":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, 2)],
            @"CHH":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(2, 2)]
        };
        operationID = mk_pb_taskReadLorawanCHOperation;
    }else if ([cmd isEqualToString:@"8b"]) {
        //读取LoRaWAN DR
        resultDic = @{
            @"DR":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_pb_taskReadLorawanDROperation;
    }else if ([cmd isEqualToString:@"8c"]) {
        //读取LoRaWAN 数据发送策略
        BOOL isOn = ([[content substringWithRange:NSMakeRange(0, 2)] isEqualToString:@"01"]);
        NSString *transmissions = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(2, 2)];
        NSString *DRL = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(4, 2)];
        NSString *DRH = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(6, 2)];
        resultDic = @{
            @"isOn":@(isOn),
            @"transmissions":transmissions,
            @"DRL":DRL,
            @"DRH":DRH,
        };
        operationID = mk_pb_taskReadLorawanUplinkStrategyOperation;
    }else if ([cmd isEqualToString:@"8d"]) {
        //读取LoRaWAN duty cycle
        BOOL isOn = ([content isEqualToString:@"01"]);
        resultDic = @{
            @"isOn":@(isOn)
        };
        operationID = mk_pb_taskReadLorawanDutyCycleStatusOperation;
    }else if ([cmd isEqualToString:@"8e"]) {
        //读取LoRaWAN devtime指令同步间隔
        resultDic = @{
            @"interval":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_pb_taskReadLorawanDevTimeSyncIntervalOperation;
    }else if ([cmd isEqualToString:@"8f"]) {
        //读取LoRaWAN LinkCheckReq指令间隔
        resultDic = @{
            @"interval":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_pb_taskReadLorawanNetworkCheckIntervalOperation;
    }else if ([cmd isEqualToString:@"90"]) {
        //读取LoRaWAN 重传次数
        resultDic = @{
            @"number":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_pb_taskReadLorawanMaxRetransmissionTimesOperation;
    }else if ([cmd isEqualToString:@"91"]) {
        //读取ADR_ACK_LIMIT
        resultDic = @{
            @"value":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_pb_taskReadLorawanADRACKLimitOperation;
    }else if ([cmd isEqualToString:@"92"]) {
        //读取ADR_ACK_DELAY
        resultDic = @{
            @"value":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_pb_taskReadLorawanADRACKDelayOperation;
    }
    
    return [self dataParserGetDataSuccess:resultDic operationID:operationID];
}

+ (NSDictionary *)parseCustomConfigData:(NSString *)content cmd:(NSString *)cmd {
    mk_pb_taskOperationID operationID = mk_pb_defaultTaskOperationID;
    BOOL success = [content isEqualToString:@"01"];
    
    if ([cmd isEqualToString:@"01"]) {
        //配置LoRaWAN入网类型
        operationID = mk_pb_taskConfigModemOperation;
    }else if ([cmd isEqualToString:@"02"]) {
        //关机
        operationID = mk_pb_taskPowerOffOperation;
    }else if ([cmd isEqualToString:@"03"]) {
        //配置LoRaWAN 入网
        operationID = mk_pb_taskRestartDeviceOperation;
    }else if ([cmd isEqualToString:@"04"]) {
        //恢复出厂设置
        operationID = mk_pb_taskFactoryResetOperation;
    }else if ([cmd isEqualToString:@"06"]) {
        //配置按键关机
        operationID = mk_pb_taskConfigTurnOffDeviceByButtonStatusOperation;
    }else if ([cmd isEqualToString:@"07"]) {
        //配置低电百分比
        operationID = mk_pb_taskConfigLowPowerPromptOperation;
    }else if ([cmd isEqualToString:@"08"]) {
        //配置低电状态数据上报开关
        operationID = mk_pb_taskConfigLowPowerPayloadOperation;
    }else if ([cmd isEqualToString:@"09"]) {
        //配置广播名称
        operationID = mk_pb_taskConfigDeviceNameOperation;
    }else if ([cmd isEqualToString:@"0a"]) {
        //配置广播间隔
        operationID = mk_pb_taskConfigAdvIntervalOperation;
    }else if ([cmd isEqualToString:@"0b"]) {
        //配置发射功率
        operationID = mk_pb_taskConfigTxPowerOperation;
    }else if ([cmd isEqualToString:@"0c"]) {
        //配置广播超时时长
        operationID = mk_pb_taskConfigBroadcastTimeoutOperation;
    }else if ([cmd isEqualToString:@"0d"]) {
        //配置密码开关
        operationID = mk_pb_taskConfigNeedPasswordOperation;
    }else if ([cmd isEqualToString:@"0e"]) {
        //配置密码
        operationID = mk_pb_taskConfigPasswordOperation;
    }else if ([cmd isEqualToString:@"0f"]) {
        //配置时区
        operationID = mk_pb_taskConfigTimeZoneOperation;
    }else if ([cmd isEqualToString:@"10"]) {
        //配置时间戳
        operationID = mk_pb_taskConfigDeviceTimeOperation;
    }else if ([cmd isEqualToString:@"11"]) {
        //配置三轴唤醒触发阈值
        operationID = mk_pb_taskConfigThreeAxisWakeupThresholdOperation;
    }else if ([cmd isEqualToString:@"12"]) {
        //配置三轴唤醒判断时间
        operationID = mk_pb_taskConfigThreeAxisWakeupDurationOperation;
    }else if ([cmd isEqualToString:@"13"]) {
        //配置三轴运动触发阈值
        operationID = mk_pb_taskConfigThreeAxisMotionThresholdOperation;
    }else if ([cmd isEqualToString:@"14"]) {
        //配置三轴运动判断时间
        operationID = mk_pb_taskConfigThreeAxisMotionDurationOperation;
    }else if ([cmd isEqualToString:@"15"]) {
        //配置运动结束判断时间
        operationID = mk_pb_taskConfigMotionModeTripEndTimeoutOperation;
    }else if ([cmd isEqualToString:@"20"]) {
        //配置关机信息上报状态
        operationID = mk_pb_taskConfigShutDownPayloadStatusOperation;
    }else if ([cmd isEqualToString:@"21"]) {
        //配置工作模式
        operationID = mk_pb_taskConfigWorkModeOperation;
    }else if ([cmd isEqualToString:@"22"]) {
        //配置心跳包上报间隔
        operationID = mk_pb_taskConfigHeartbeatIntervalOperation;
    }else if ([cmd isEqualToString:@"23"]) {
        //配置定期模式下定位数据上报间隔
        operationID = mk_pb_taskConfigPeriodicModeReportIntervalOperation;
    }else if ([cmd isEqualToString:@"24"]) {
        //配置定期模式下定位策略
        operationID = mk_pb_taskConfigPeriodicModePositioningStrategyOperation;
    }else if ([cmd isEqualToString:@"25"]) {
        //配置定时上报时间点
        operationID = mk_pb_taskConfigTimingModeReportingTimePointOperation;
    }else if ([cmd isEqualToString:@"26"]) {
        //配置定时模式下定位策略
        operationID = mk_pb_taskConfigTimingModePositioningStrategyOperation;
    }else if ([cmd isEqualToString:@"27"]) {
        //配置运动模式事件
        operationID = mk_pb_taskConfigMotionModeEventsOperation;
    }else if ([cmd isEqualToString:@"28"]) {
        //配置运动开始定位策略
        operationID = mk_pb_taskConfigMotionModePosStrategyOnStartOperation;
    }else if ([cmd isEqualToString:@"29"]) {
        //配置运动开始定位上报次数
        operationID = mk_pb_taskConfigMotionModeNumberOfFixOnStartOperation;
    }else if ([cmd isEqualToString:@"2a"]) {
        //配置运动中定位策略
        operationID = mk_pb_taskConfigMotionModePosStrategyInTripOperation;
    }else if ([cmd isEqualToString:@"2b"]) {
        //配置运动中定位间隔
        operationID = mk_pb_taskConfigMotionModeReportIntervalInTripOperation;
    }else if ([cmd isEqualToString:@"2c"]) {
        //配置运动结束定位策略
        operationID = mk_pb_taskConfigMotionModePosStrategyOnEndOperation;
    }else if ([cmd isEqualToString:@"2d"]) {
        //配置运动结束定位次数
        operationID = mk_pb_taskConfigMotionModeNumberOfFixOnEndOperation;
    }else if ([cmd isEqualToString:@"2e"]) {
        //配置运动结束定位间隔
        operationID = mk_pb_taskConfigMotionModeReportIntervalOnEndOperation;
    }else if ([cmd isEqualToString:@"30"]) {
        //配置下行定位请求定位策略
        operationID = mk_pb_taskConfigDownlinkPositioningStrategyOperation;
    }else if ([cmd isEqualToString:@"31"]) {
        //配置ManDown功能开关
        operationID = mk_pb_taskConfigManDownDetectionOperation;
    }else if ([cmd isEqualToString:@"32"]) {
        //配置ManDown定位请求定位策略
        operationID = mk_pb_taskConfigManDownPositioningStrategyOperation;
    }else if ([cmd isEqualToString:@"33"]) {
        //配置ManDown检测超时时间
        operationID = mk_pb_taskConfigManDownDetectionTimeoutOperation;
    }else if ([cmd isEqualToString:@"34"]) {
        //配置ManDown的定位数据上报间隔
        operationID = mk_pb_taskConfigManDownReportIntervalOperation;
    }else if ([cmd isEqualToString:@"35"]) {
        //配置ManDown开始事件通知开关
        operationID = mk_pb_taskConfigNotifyEventOnManDownStartOperation;
    }else if ([cmd isEqualToString:@"36"]) {
        //配置ManDown结束事件通知开关
        operationID = mk_pb_taskConfigNotifyEventOnManDownEndOperation;
    }else if ([cmd isEqualToString:@"37"]) {
        //配置马达震动强度
        operationID = mk_pb_taskConfigMotorVibrationIntensityOperation;
    }else if ([cmd isEqualToString:@"38"]) {
        //配置报警类型
        operationID = mk_pb_taskConfigAlarmTypeOperation;
    }else if ([cmd isEqualToString:@"39"]) {
        //配置退出报警按键触发时长
        operationID = mk_pb_taskConfigExitAlarmTypeLongPressTimeOperation;
    }else if ([cmd isEqualToString:@"3a"]) {
        //配置SOS开始事件通知
        operationID = mk_pb_taskConfigNotifyEventOnSOSStartOperation;
    }else if ([cmd isEqualToString:@"3b"]) {
        //配置SOS结束事件通知
        operationID = mk_pb_taskConfigNotifyEventOnSOSEndOperation;
    }else if ([cmd isEqualToString:@"3c"]) {
        //配置SOS报警定位策略
        operationID = mk_pb_taskConfigSOSPositioningStrategyOperation;
    }else if ([cmd isEqualToString:@"3d"]) {
        //配置SOS报警定位数据上报间隔
        operationID = mk_pb_taskConfigSOSReportIntervalOperation;
    }else if ([cmd isEqualToString:@"3e"]) {
        //配置SOS报警触发方式
        operationID = mk_pb_taskConfigSOSTriggerModeOperation;
    }else if ([cmd isEqualToString:@"3f"]) {
        //配置Alert开始事件通知
        operationID = mk_pb_taskConfigNotifyEventOnAlertStartOperation;
    }else if ([cmd isEqualToString:@"40"]) {
        //配置Alert结束事件通知
        operationID = mk_pb_taskConfigNotifyEventOnAlertEndOperation;
    }else if ([cmd isEqualToString:@"41"]) {
        //配置Alert报警定位策略
        operationID = mk_pb_taskConfigAlertPositioningStrategyOperation;
    }else if ([cmd isEqualToString:@"42"]) {
        //配置Alert报警触发方式
        operationID = mk_pb_taskConfigAlertTriggerModeOperation;
    }else if ([cmd isEqualToString:@"50"]) {
        //配置GPS定位超时时间
        operationID = mk_pb_taskConfigGpsPositioningTimeoutOperation;
    }else if ([cmd isEqualToString:@"51"]) {
        //配置PDOP
        operationID = mk_pb_taskConfigPDOPOfGpsOperation;
    }else if ([cmd isEqualToString:@"52"]) {
        //配置蓝牙定位超时时间
        operationID = mk_pb_taskConfigBlePositioningTimeoutOperation;
    }else if ([cmd isEqualToString:@"53"]) {
        //配置蓝牙定位mac数量
        operationID = mk_pb_taskConfigBlePositioningNumberOfMacOperation;
    }else if ([cmd isEqualToString:@"54"]) {
        //配置rssi过滤规则
        operationID = mk_pb_taskConfigRssiFilterValueOperation;
    }else if ([cmd isEqualToString:@"55"]) {
        //配置广播内容过滤逻辑
        operationID = mk_pb_taskConfigFilterRelationshipOperation;
    }else if ([cmd isEqualToString:@"56"]) {
        //配置精准过滤MAC开关
        operationID = mk_pb_taskConfigFilterByMacPreciseMatchOperation;
    }else if ([cmd isEqualToString:@"57"]) {
        //配置反向过滤MAC开关
        operationID = mk_pb_taskConfigFilterByMacReverseFilterOperation;
    }else if ([cmd isEqualToString:@"58"]) {
        //配置MAC过滤规则
        operationID = mk_pb_taskConfigFilterMACAddressListOperation;
    }else if ([cmd isEqualToString:@"59"]) {
        //配置精准过滤Adv Name开关
        operationID = mk_pb_taskConfigFilterByAdvNamePreciseMatchOperation;
    }else if ([cmd isEqualToString:@"5a"]) {
        //配置反向过滤Adv Name开关
        operationID = mk_pb_taskConfigFilterByAdvNameReverseFilterOperation;
    }else if ([cmd isEqualToString:@"5d"]) {
        //配置iBeacon类型过滤开关
        operationID = mk_pb_taskConfigFilterByBeaconStatusOperation;
    }else if ([cmd isEqualToString:@"5e"]) {
        //配置iBeacon类型过滤Major范围
        operationID = mk_pb_taskConfigFilterByBeaconMajorOperation;
    }else if ([cmd isEqualToString:@"5f"]) {
        //配置iBeacon类型过滤Minor范围
        operationID = mk_pb_taskConfigFilterByBeaconMinorOperation;
    }else if ([cmd isEqualToString:@"60"]) {
        //配置iBeacon类型过滤UUID
        operationID = mk_pb_taskConfigFilterByBeaconUUIDOperation;
    }else if ([cmd isEqualToString:@"61"]) {
        //配置MKiBeacon类型过滤开关
        operationID = mk_pb_taskConfigFilterByMKBeaconStatusOperation;
    }else if ([cmd isEqualToString:@"62"]) {
        //配置MKiBeacon类型过滤Major范围
        operationID = mk_pb_taskConfigFilterByMKBeaconMajorOperation;
    }else if ([cmd isEqualToString:@"63"]) {
        //配置MKiBeacon类型过滤Minor范围
        operationID = mk_pb_taskConfigFilterByMKBeaconMinorOperation;
    }else if ([cmd isEqualToString:@"64"]) {
        //配置MKiBeacon类型过滤UUID
        operationID = mk_pb_taskConfigFilterByMKBeaconUUIDOperation;
    }else if ([cmd isEqualToString:@"65"]) {
        //配置MKiBeacon&ACC类型过滤开关
        operationID = mk_pb_taskConfigFilterByMKBeaconAccStatusOperation;
    }else if ([cmd isEqualToString:@"66"]) {
        //配置MKiBeacon&ACC类型过滤Major范围
        operationID = mk_pb_taskConfigFilterByMKBeaconAccMajorOperation;
    }else if ([cmd isEqualToString:@"67"]) {
        //配置MKiBeacon&ACC类型过滤Minor范围
        operationID = mk_pb_taskConfigFilterByMKBeaconAccMinorOperation;
    }else if ([cmd isEqualToString:@"68"]) {
        //配置MKiBeacon&ACC类型过滤UUID
        operationID = mk_pb_taskConfigFilterByMKBeaconAccUUIDOperation;
    }else if ([cmd isEqualToString:@"69"]) {
        //配置UID类型过滤开关
        operationID = mk_pb_taskConfigFilterByUIDStatusOperation;
    }else if ([cmd isEqualToString:@"6a"]) {
        //配置UID类型过滤Namespace ID.
        operationID = mk_pb_taskConfigFilterByUIDNamespaceIDOperation;
    }else if ([cmd isEqualToString:@"6b"]) {
        //配置UID类型过滤Instace ID.
        operationID = mk_pb_taskConfigFilterByUIDInstanceIDOperation;
    }else if ([cmd isEqualToString:@"6c"]) {
        //配置URL类型过滤开关
        operationID = mk_pb_taskConfigFilterByURLStatusOperation;
    }else if ([cmd isEqualToString:@"6d"]) {
        //配置URL类型过滤内容
        operationID = mk_pb_taskConfigFilterByURLContentOperation;
    }else if ([cmd isEqualToString:@"6e"]) {
        //配置TLM类型开关
        operationID = mk_pb_taskConfigFilterByTLMStatusOperation;
    }else if ([cmd isEqualToString:@"6f"]) {
        //配置TLM过滤数据类型
        operationID = mk_pb_taskConfigFilterByTLMVersionOperation;
    }else if ([cmd isEqualToString:@"70"]) {
        //配置BeaconX Pro-ACC设备过滤开关
        operationID = mk_pb_taskConfigBXPAccFilterStatusOperation;
    }else if ([cmd isEqualToString:@"71"]) {
        //配置BeaconX Pro-TH设备过滤开关
        operationID = mk_pb_taskConfigBXPTHFilterStatusOperation;
    }else if ([cmd isEqualToString:@"72"]) {
        //配置Other过滤关系开关
        operationID = mk_pb_taskConfigFilterByOtherStatusOperation;
    }else if ([cmd isEqualToString:@"73"]) {
        //配置Other过滤条件逻辑关系
        operationID = mk_pb_taskConfigFilterByOtherRelationshipOperation;
    }else if ([cmd isEqualToString:@"74"]) {
        //配置Other过滤条件列表
        operationID = mk_pb_taskConfigFilterByOtherConditionsOperation;
    }else if ([cmd isEqualToString:@"80"]) {
        //配置LoRaWAN频段
        operationID = mk_pb_taskConfigRegionOperation;
    }else if ([cmd isEqualToString:@"81"]) {
        //配置LoRaWAN入网类型
        operationID = mk_pb_taskConfigModemOperation;
    }else if ([cmd isEqualToString:@"83"]) {
        //配置LoRaWAN DEVEUI
        operationID = mk_pb_taskConfigDEVEUIOperation;
    }else if ([cmd isEqualToString:@"84"]) {
        //配置LoRaWAN APPEUI
        operationID = mk_pb_taskConfigAPPEUIOperation;
    }else if ([cmd isEqualToString:@"85"]) {
        //配置LoRaWAN APPKEY
        operationID = mk_pb_taskConfigAPPKEYOperation;
    }else if ([cmd isEqualToString:@"86"]) {
        //配置LoRaWAN DEVADDR
        operationID = mk_pb_taskConfigDEVADDROperation;
    }else if ([cmd isEqualToString:@"87"]) {
        //配置LoRaWAN APPSKEY
        operationID = mk_pb_taskConfigAPPSKEYOperation;
    }else if ([cmd isEqualToString:@"88"]) {
        //配置LoRaWAN nwkSkey
        operationID = mk_pb_taskConfigNWKSKEYOperation;
    }else if ([cmd isEqualToString:@"89"]) {
        //配置LoRaWAN 上行数据类型
        operationID = mk_pb_taskConfigMessageTypeOperation;
    }else if ([cmd isEqualToString:@"8a"]) {
        //配置LoRaWAN CH
        operationID = mk_pb_taskConfigCHValueOperation;
    }else if ([cmd isEqualToString:@"8b"]) {
        //配置LoRaWAN DR
        operationID = mk_pb_taskConfigDRValueOperation;
    }else if ([cmd isEqualToString:@"8c"]) {
        //配置LoRaWAN 数据发送策略
        operationID = mk_pb_taskConfigUplinkStrategyOperation;
    }else if ([cmd isEqualToString:@"8d"]) {
        //配置LoRaWAN duty cycle
        operationID = mk_pb_taskConfigDutyCycleStatusOperation;
    }else if ([cmd isEqualToString:@"8e"]) {
        //配置LoRaWAN devtime指令同步间隔
        operationID = mk_pb_taskConfigTimeSyncIntervalOperation;
    }else if ([cmd isEqualToString:@"8f"]) {
        //配置LoRaWAN LinkCheckReq指令间隔
        operationID = mk_pb_taskConfigNetworkCheckIntervalOperation;
    }else if ([cmd isEqualToString:@"90"]) {
        //配置LoRaWAN 重传次数
        operationID = mk_pb_taskConfigMaxRetransmissionTimesOperation;
    }else if ([cmd isEqualToString:@"91"]) {
        //配置ADR_ACK_LIMIT
        operationID = mk_pb_taskConfigLorawanADRACKLimitOperation;
    }else if ([cmd isEqualToString:@"92"]) {
        //配置ADR_ACK_DELAY
        operationID = mk_pb_taskConfigLorawanADRACKDelayOperation;
    }else if ([cmd isEqualToString:@"69"]) {
        //同步时间
        operationID = mk_pb_taskConfigDeviceTimeOperation;
    }else if ([cmd isEqualToString:@"6a"]) {
        //恢复出厂配置
        operationID = mk_pb_taskFactoryResetOperation;
    }
    
    return [self dataParserGetDataSuccess:@{@"success":@(success)} operationID:operationID];
}



#pragma mark -

+ (NSDictionary *)dataParserGetDataSuccess:(NSDictionary *)returnData operationID:(mk_pb_taskOperationID)operationID{
    if (!returnData) {
        return @{};
    }
    return @{@"returnData":returnData,@"operationID":@(operationID)};
}

@end
