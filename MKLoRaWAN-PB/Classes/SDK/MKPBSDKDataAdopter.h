//
//  MKPBSDKDataAdopter.h
//  MKLoRaWAN-PB_Example
//
//  Created by aa on 2022/3/15.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MKPBSDKNormalDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKPBSDKDataAdopter : NSObject

+ (NSString *)lorawanRegionString:(mk_pb_loraWanRegion)region;

+ (NSString *)fetchTxPower:(mk_pb_txPower)txPower;

/// 实际值转换为0dBm、4dBm等
/// @param content content
+ (NSString *)fetchTxPowerValueString:(NSString *)content;

/// 过滤的mac列表
/// @param content content
+ (NSArray <NSString *>*)parseFilterMacList:(NSString *)content;

/// 过滤的Adv Name列表
/// @param contentList contentList
+ (NSArray <NSString *>*)parseFilterAdvNameList:(NSArray <NSData *>*)contentList;

/// 将协议中的数值对应到原型中去
/// @param other 协议中的数值
+ (NSString *)parseOtherRelationship:(NSString *)other;

/// 解析Other当前过滤条件列表
/// @param content content
+ (NSArray *)parseOtherFilterConditionList:(NSString *)content;

+ (NSString *)parseOtherRelationshipToCmd:(mk_pb_filterByOther)relationship;

+ (BOOL)isConfirmRawFilterProtocol:(id <mk_pb_BLEFilterRawDataProtocol>)protocol;

+ (NSString *)fetchDeviceModeValue:(mk_pb_deviceMode)deviceMode;

+ (NSArray <NSDictionary *>*)parseTimingModeReportingTimePoint:(NSString *)content;

+ (NSString *)fetchTimingModeReportingTimePoint:(NSArray <mk_pb_timingModeReportingTimePointProtocol>*)dataList;

+ (NSString *)fetchPositioningStrategyCommand:(mk_pb_positioningStrategy)strategy;

+ (NSString *)fetchAlarmTypeCommand:(mk_pb_alarmType)alarmType;

+ (NSString *)fetchSOSTriggerModeCommand:(mk_pb_sosTriggerMode)triggerMode;

+ (NSString *)fetchAlertTriggerModeCommand:(mk_pb_alertTriggerMode)triggerMode;

@end

NS_ASSUME_NONNULL_END
