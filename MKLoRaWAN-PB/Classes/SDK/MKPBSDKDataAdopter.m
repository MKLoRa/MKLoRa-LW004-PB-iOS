//
//  MKPBSDKDataAdopter.m
//  MKLoRaWAN-PB_Example
//
//  Created by aa on 2022/3/15.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKPBSDKDataAdopter.h"

#import "MKBLEBaseSDKDefines.h"
#import "MKBLEBaseSDKAdopter.h"

@implementation MKPBSDKDataAdopter

+ (NSString *)lorawanRegionString:(mk_pb_loraWanRegion)region {
    switch (region) {
        case mk_pb_loraWanRegionAS923:
            return @"00";
        case mk_pb_loraWanRegionAU915:
            return @"01";
        case mk_pb_loraWanRegionCN470:
            return @"02";
        case mk_pb_loraWanRegionCN779:
            return @"03";
        case mk_pb_loraWanRegionEU433:
            return @"04";
        case mk_pb_loraWanRegionEU868:
            return @"05";
        case mk_pb_loraWanRegionKR920:
            return @"06";
        case mk_pb_loraWanRegionIN865:
            return @"07";
        case mk_pb_loraWanRegionUS915:
            return @"08";
        case mk_pb_loraWanRegionRU864:
            return @"09";
    }
}

+ (NSString *)fetchTxPower:(mk_pb_txPower)txPower {
    switch (txPower) {
        case mk_pb_txPower4dBm:
            return @"04";
            
        case mk_pb_txPower3dBm:
            return @"03";
            
        case mk_pb_txPower0dBm:
            return @"00";
            
        case mk_pb_txPowerNeg4dBm:
            return @"fc";
            
        case mk_pb_txPowerNeg8dBm:
            return @"f8";
            
        case mk_pb_txPowerNeg12dBm:
            return @"f4";
            
        case mk_pb_txPowerNeg16dBm:
            return @"f0";
            
        case mk_pb_txPowerNeg20dBm:
            return @"ec";
            
        case mk_pb_txPowerNeg40dBm:
            return @"d8";
    }
}

+ (NSString *)fetchTxPowerValueString:(NSString *)content {
    if ([content isEqualToString:@"08"]) {
        return @"8dBm";
    }
    if ([content isEqualToString:@"07"]) {
        return @"7dBm";
    }
    if ([content isEqualToString:@"06"]) {
        return @"6dBm";
    }
    if ([content isEqualToString:@"05"]) {
        return @"5dBm";
    }
    if ([content isEqualToString:@"04"]) {
        return @"4dBm";
    }
    if ([content isEqualToString:@"03"]) {
        return @"3dBm";
    }
    if ([content isEqualToString:@"02"]) {
        return @"2dBm";
    }
    if ([content isEqualToString:@"00"]) {
        return @"0dBm";
    }
    if ([content isEqualToString:@"fc"]) {
        return @"-4dBm";
    }
    if ([content isEqualToString:@"f8"]) {
        return @"-8dBm";
    }
    if ([content isEqualToString:@"f4"]) {
        return @"-12dBm";
    }
    if ([content isEqualToString:@"f0"]) {
        return @"-16dBm";
    }
    if ([content isEqualToString:@"ec"]) {
        return @"-20dBm";
    }
    if ([content isEqualToString:@"d8"]) {
        return @"-40dBm";
    }
    return @"0dBm";
}

+ (NSArray <NSString *>*)parseFilterMacList:(NSString *)content {
    if (!MKValidStr(content) || content.length < 4) {
        return @[];
    }
    NSInteger index = 0;
    NSMutableArray *dataList = [NSMutableArray array];
    for (NSInteger i = 0; i < content.length; i ++) {
        if (index >= content.length) {
            break;
        }
        NSInteger subLen = [MKBLEBaseSDKAdopter getDecimalWithHex:content range:NSMakeRange(index, 2)];
        index += 2;
        if (content.length < (index + subLen * 2)) {
            break;
        }
        NSString *subContent = [content substringWithRange:NSMakeRange(index, subLen * 2)];
        index += subLen * 2;
        [dataList addObject:subContent];
    }
    return dataList;
}

+ (NSArray <NSString *>*)parseFilterAdvNameList:(NSArray <NSData *>*)contentList {
    if (!MKValidArray(contentList)) {
        return @[];
    }
    NSMutableData *contentData = [[NSMutableData alloc] init];
    for (NSInteger i = 0; i < contentList.count; i ++) {
        [contentData appendData:contentList[i]];
    }
    if (!MKValidData(contentData)) {
        return @[];
    }
    NSInteger index = 0;
    NSMutableArray *advNameList = [NSMutableArray array];
    for (NSInteger i = 0; i < contentData.length; i ++) {
        if (index >= contentData.length) {
            break;
        }
        NSData *lenData = [contentData subdataWithRange:NSMakeRange(index, 1)];
        NSString *lenString = [MKBLEBaseSDKAdopter hexStringFromData:lenData];
        NSInteger subLen = [MKBLEBaseSDKAdopter getDecimalWithHex:lenString range:NSMakeRange(0, lenString.length)];
        NSData *subData = [contentData subdataWithRange:NSMakeRange(index + 1, subLen)];
        NSString *advName = [[NSString alloc] initWithData:subData encoding:NSUTF8StringEncoding];
        if (advName) {
            [advNameList addObject:advName];
        }
        index += (subLen + 1);
    }
    return advNameList;
}

+ (NSString *)parseOtherRelationship:(NSString *)other {
    if (!MKValidStr(other)) {
        return @"0";
    }
    if ([other isEqualToString:@"00"]) {
        //A
        return @"0";
    }
    if ([other isEqualToString:@"01"]) {
        //A&B
        return @"1";
    }
    if ([other isEqualToString:@"02"]) {
        //A|B
        return @"2";
    }
    if ([other isEqualToString:@"03"]) {
        //协议中A | B | C
        //对应原型中的5
        return @"5";
    }
    if ([other isEqualToString:@"04"]) {
        //协议中A & B & C
        //对应原型3
        return @"3";
    }
    if ([other isEqualToString:@"05"]) {
        //协议中(A & B) | C
        //对应原型4
        return @"4";
    }
    return @"0";
}

+ (NSArray *)parseOtherFilterConditionList:(NSString *)content {
    if (!MKValidStr(content) || content.length < 4) {
        return @[];
    }
    NSInteger index = 0;
    NSMutableArray *dataList = [NSMutableArray array];
    for (NSInteger i = 0; i < content.length; i ++) {
        if (index >= content.length) {
            break;
        }
        NSInteger subLen = [MKBLEBaseSDKAdopter getDecimalWithHex:content range:NSMakeRange(index, 2)];
        index += 2;
        if (content.length < (index + subLen * 2)) {
            break;
        }
        NSString *subContent = [content substringWithRange:NSMakeRange(index, subLen * 2)];
        
        NSString *type = [subContent substringWithRange:NSMakeRange(0, 2)];
        NSString *start = [MKBLEBaseSDKAdopter getDecimalStringWithHex:subContent range:NSMakeRange(2, 2)];
        NSString *end = [MKBLEBaseSDKAdopter getDecimalStringWithHex:subContent range:NSMakeRange(4, 2)];
        NSString *data = [subContent substringFromIndex:6];
        
        NSDictionary *dataDic = @{
            @"type":type,
            @"start":start,
            @"end":end,
            @"data":(data ? data : @""),
        };
        
        index += subLen * 2;
        [dataList addObject:dataDic];
    }
    return dataList;
}

+ (NSString *)parseOtherRelationshipToCmd:(mk_pb_filterByOther)relationship {
    switch (relationship) {
        case mk_pb_filterByOther_A:
            return @"00";
        case mk_pb_filterByOther_AB:
            return @"01";
        case mk_pb_filterByOther_AOrB:
            return @"02";
        case mk_pb_filterByOther_ABC:
            return @"04";
        case mk_pb_filterByOther_ABOrC:
            return @"05";
        case mk_pb_filterByOther_AOrBOrC:
            return @"03";
    }
}

+ (BOOL)isConfirmRawFilterProtocol:(id <mk_pb_BLEFilterRawDataProtocol>)protocol {
    if (![protocol conformsToProtocol:@protocol(mk_pb_BLEFilterRawDataProtocol)]) {
        return NO;
    }
    if (!MKValidStr(protocol.dataType) || protocol.dataType.length != 2 || ![MKBLEBaseSDKAdopter checkHexCharacter:protocol.dataType]) {
        return NO;
    }
    if (protocol.minIndex == 0 && protocol.maxIndex == 0) {
        if (!MKValidStr(protocol.rawData) || protocol.rawData.length > 58 || ![MKBLEBaseSDKAdopter checkHexCharacter:protocol.rawData] || (protocol.rawData.length % 2 != 0)) {
            return NO;
        }
        return YES;
    }
    if (protocol.minIndex < 0 || protocol.minIndex > 29 || protocol.maxIndex < 0 || protocol.maxIndex > 29) {
        return NO;
    }
    if (protocol.minIndex == 0 && protocol.maxIndex != 0) {
        return NO;
    }
    if (protocol.maxIndex < protocol.minIndex) {
        return NO;
    }
    if (!MKValidStr(protocol.rawData) || protocol.rawData.length > 58 || ![MKBLEBaseSDKAdopter checkHexCharacter:protocol.rawData]) {
        return NO;
    }
    NSInteger totalLen = (protocol.maxIndex - protocol.minIndex + 1) * 2;
    if (protocol.rawData.length != totalLen) {
        return NO;
    }
    return YES;
}

+ (NSString *)fetchDeviceModeValue:(mk_pb_deviceMode)deviceMode {
    switch (deviceMode) {
        case mk_pb_deviceMode_standbyMode:
            return @"00";
        case mk_pb_deviceMode_timingMode:
            return @"01";
        case mk_pb_deviceMode_periodicMode:
            return @"02";
        case mk_pb_deviceMode_motionMode:
            return @"03";
    }
}

+ (NSArray <NSDictionary *>*)parseTimingModeReportingTimePoint:(NSString *)content {
    if (!MKValidStr(content) || content.length < 2) {
        return @[];
    }
    if ([content isEqualToString:@"00"]) {
        return @[];
    }
    NSInteger totalByte = content.length / 2;
    NSMutableArray *tempList = [NSMutableArray array];
    
    for (NSInteger i = 0; i < totalByte; i ++) {
        NSString *tempString = [content substringWithRange:NSMakeRange(i * 2, 2)];
        NSInteger tempValue = [MKBLEBaseSDKAdopter getDecimalWithHex:tempString range:NSMakeRange(0, tempString.length)];
        NSInteger hour = 0;
        NSInteger minuteGear = 0;
        if (tempValue < 96) {
            //如果是96，表示00:00
            hour = tempValue / 4;
            minuteGear = tempValue % 4;
        }
        [tempList addObject:@{
            @"hour":@(hour),
            @"minuteGear":@(minuteGear),
        }];
    }
    
    return tempList;
}

+ (NSString *)fetchTimingModeReportingTimePoint:(NSArray <mk_pb_timingModeReportingTimePointProtocol>*)dataList {
    if (dataList.count > 10) {
        return @"";
    }
    if (!MKValidArray(dataList)) {
        return @"00";
    }
    NSString *len = [MKBLEBaseSDKAdopter fetchHexValue:dataList.count byteLen:1];
    NSString *resultString = len;
    for (NSInteger i = 0; i < dataList.count; i ++) {
        id <mk_pb_timingModeReportingTimePointProtocol>data = dataList[i];
        if (data.hour < 0 || data.hour > 23 || data.minuteGear < 0 || data.minuteGear > 3) {
            return @"";
        }
        NSInteger timeValue = 0;
        if (data.hour == 0 && data.minuteGear == 0) {
            timeValue = 96;
        }else {
            timeValue = 4 * data.hour + data.minuteGear;
        }
        NSString *timeString = [MKBLEBaseSDKAdopter fetchHexValue:timeValue byteLen:1];
        resultString = [resultString stringByAppendingString:timeString];
    }
    return resultString;
}

+ (NSString *)fetchPositioningStrategyCommand:(mk_pb_positioningStrategy)strategy {
    switch (strategy) {
        case mk_pb_positioningStrategy_ble:
            return @"00";
        case mk_pb_positioningStrategy_gps:
            return @"01";
        case mk_pb_positioningStrategy_bleAndGps:
            return @"02";
    }
}

+ (NSString *)fetchAlarmTypeCommand:(mk_pb_alarmType)alarmType {
    switch (alarmType) {
        case mk_pb_alarmType_no:
            return @"00";
        case mk_pb_alarmType_alert:
            return @"01";
        case mk_pb_alarmType_sos:
            return @"02";
    }
}

+ (NSString *)fetchSOSTriggerModeCommand:(mk_pb_sosTriggerMode)triggerMode {
    switch (triggerMode) {
        case mk_pb_sosTriggerMode_doubleClick:
            return @"00";
        case mk_pb_sosTriggerMode_tripleClick:
            return @"01";
        case mk_pb_sosTriggerMode_longPressOneSec:
            return @"02";
        case mk_pb_sosTriggerMode_longPressTwoSec:
            return @"03";
        case mk_pb_sosTriggerMode_longPressThreeSec:
            return @"04";
        case mk_pb_sosTriggerMode_longPressFourSec:
            return @"05";
        case mk_pb_sosTriggerMode_longPressFiveSec:
            return @"06";
    }
}

+ (NSString *)fetchAlertTriggerModeCommand:(mk_pb_alertTriggerMode)triggerMode {
    switch (triggerMode) {
        case mk_pb_alertTriggerMode_singleClick:
            return @"00";
        case mk_pb_alertTriggerMode_doubleClick:
            return @"01";
        case mk_pb_alertTriggerMode_longPressOneSec:
            return @"02";
        case mk_pb_alertTriggerMode_longPressTwoSec:
            return @"03";
        case mk_pb_alertTriggerMode_longPressThreeSec:
            return @"04";
        case mk_pb_alertTriggerMode_longPressFourSec:
            return @"05";
        case mk_pb_alertTriggerMode_longPressFiveSec:
            return @"06";
    }
}

@end
