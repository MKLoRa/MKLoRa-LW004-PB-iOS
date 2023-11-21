//
//  MKPBInterface+MKPBConfig.h
//  MKLoRaWAN-PB_Example
//
//  Created by aa on 2022/3/15.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKPBInterface.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKPBInterface (MKPBConfig)

#pragma mark ****************************************System************************************************

/// Device shutdown.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_powerOffWithSucBlock:(void (^)(void))sucBlock
                    failedBlock:(void (^)(NSError *error))failedBlock;

/// Restart the device.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_restartDeviceWithSucBlock:(void (^)(void))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock;

/// Reset.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_factoryResetWithSucBlock:(void (^)(void))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock;

/// Turn off Device by button.
/// @param isOn isOn
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_configTurnOffDeviceByButtonStatus:(BOOL)isOn
                                    sucBlock:(void (^)(void))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure Low Power Prompt.
/// @param prompt 10%~60%
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_configLowPowerPrompt:(NSInteger)prompt
                       sucBlock:(void (^)(void))sucBlock
                    failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure Low Power Payload.
/// @param isOn isOn
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_configLowPowerPayload:(BOOL)isOn
                        sucBlock:(void (^)(void))sucBlock
                     failedBlock:(void (^)(NSError *error))failedBlock;


/// Configure the broadcast name of the device.
/// @param deviceName 0~16 ascii characters
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_configDeviceName:(NSString *)deviceName
                   sucBlock:(void (^)(void))sucBlock
                failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure beacon broadcast time interval.
/// @param interval 1 x 100ms ~ 100 x 100ms
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_configAdvInterval:(NSInteger)interval
                    sucBlock:(void (^)(void))sucBlock
                 failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the txPower of device.
/// @param txPower txPower
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_configTxPower:(mk_pb_txPower)txPower
                sucBlock:(void (^)(void))sucBlock
             failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the broadcast timeout time in Bluetooth configuration mode.
/// @param timeout 1Min~60Mins
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_configBroadcastTimeout:(NSInteger)timeout
                         sucBlock:(void (^)(void))sucBlock
                      failedBlock:(void (^)(NSError *error))failedBlock;

/// Do you need a password when configuring the device connection.
/// @param need need
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_configNeedPassword:(BOOL)need
                     sucBlock:(void (^)(void))sucBlock
                  failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the connection password of device.
/// @param password 8-character ascii code
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_configPassword:(NSString *)password
                 sucBlock:(void (^)(void))sucBlock
              failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the time zone of the device.
/// @param timeZone -24~28  //(The time zone is in units of 30 minutes, UTC-12:00~UTC+14:00.eg:timeZone = -23 ,--> UTC-11:30)
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_configTimeZone:(NSInteger)timeZone
                 sucBlock:(void (^)(void))sucBlock
              failedBlock:(void (^)(NSError *error))failedBlock;

/// Sync device time.
/// @param timestamp UTC
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_configDeviceTime:(unsigned long)timestamp
                   sucBlock:(void (^)(void))sucBlock
                failedBlock:(void (^)(NSError *error))failedBlock;

/// Wakeup Threshold Of 3-Axis.
/// @param threshold 1 ~ 20 (Unit:16mg).
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_configThreeAxisWakeupThreshold:(NSInteger)threshold
                                 sucBlock:(void (^)(void))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock;

/// Wakeup Duration Of 3-Axis.
/// @param duration 1~10.(Unit:10ms)
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_configThreeAxisWakeupDuration:(NSInteger)duration
                                sucBlock:(void (^)(void))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock;

/// Motion Threshold Of 3-Axis.
/// @param threshold 10 ~ 250 (Unit:2mg).
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_configThreeAxisMotionThreshold:(NSInteger)threshold
                                 sucBlock:(void (^)(void))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock;

/// Motion Duration Of 3-Axis.
/// @param duration 1~50.(Unit:5ms)
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_configThreeAxisMotionDuration:(NSInteger)duration
                                sucBlock:(void (^)(void))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure Motion Mode Trip End Timeout.
/// @param time 3~180(Unit:10s)
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_configMotionModeTripEndTimeout:(NSInteger)time
                                 sucBlock:(void (^)(void))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock;

#pragma mark ****************************************Work Mode************************************************

/// Shut-Down Payload.
/// @param isOn isOn
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_configShutDownPayloadStatus:(BOOL)isOn
                              sucBlock:(void (^)(void))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the working mode of the device.
/// @param deviceMode device mode
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_configWorkMode:(mk_pb_deviceMode)deviceMode
                 sucBlock:(void (^)(void))sucBlock
              failedBlock:(void (^)(NSError *error))failedBlock;

/// Heartbeat Interval.
/// @param interval 1Min~14400Mins
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_configHeartbeatInterval:(NSInteger)interval
                          sucBlock:(void (^)(void))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure Periodic Mode positioning strategy.
/// @param strategy strategy
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_configPeriodicModePositioningStrategy:(mk_pb_positioningStrategy)strategy
                                        sucBlock:(void (^)(void))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure Periodic Mode reporting interval.
/// @param interval 1s~14400s
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_configPeriodicModeReportInterval:(NSInteger)interval
                                   sucBlock:(void (^)(void))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure Timing Mode Reporting Time Point.
/// @param dataList up to 10 groups of filters.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_configTimingModeReportingTimePoint:(NSArray <mk_pb_timingModeReportingTimePointProtocol>*)dataList
                                     sucBlock:(void (^)(void))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure Timing Mode positioning strategy.
/// @param strategy strategy
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_configTimingModePositioningStrategy:(mk_pb_positioningStrategy)strategy
                                      sucBlock:(void (^)(void))sucBlock
                                   failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure Motion Mode Events.
/// @param protocol protocol
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_configMotionModeEvents:(id <mk_pb_motionModeEventsProtocol>)protocol
                         sucBlock:(void (^)(void))sucBlock
                      failedBlock:(void (^)(NSError *error))failedBlock;


/// Configure Motion Mode Pos-Strategy On Start.
/// @param strategy strategy
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_configMotionModePosStrategyOnStart:(mk_pb_positioningStrategy)strategy
                                     sucBlock:(void (^)(void))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure Motion Mode Number Of Fix On Start.
/// @param number 1~255
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_configMotionModeNumberOfFixOnStart:(NSInteger)number
                                     sucBlock:(void (^)(void))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure Motion Mode Pos-Strategy In Trip.
/// @param strategy strategy
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_configMotionModePosStrategyInTrip:(mk_pb_positioningStrategy)strategy
                                    sucBlock:(void (^)(void))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure Motion Mode Report Interval In Trip.
/*
 @{
 @"interval":@"300",            //Unit:S
 }
 */
/// @param interval 10s~86400s
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_configMotionModeReportIntervalInTrip:(long long)interval
                                       sucBlock:(void (^)(void))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure Motion Mode Pos-Strategy On End.
/// @param strategy strategy
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_configMotionModePosStrategyOnEnd:(mk_pb_positioningStrategy)strategy
                                   sucBlock:(void (^)(void))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure Motion Mode Number Of Fix On End.
/// @param number 1~255
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_configMotionModeNumberOfFixOnEnd:(NSInteger)number
                                   sucBlock:(void (^)(void))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure Motion Mode Report Interval On End.
/// @param interval 10s~300s
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_configMotionModeReportIntervalOnEnd:(NSInteger)interval
                                      sucBlock:(void (^)(void))sucBlock
                                   failedBlock:(void (^)(NSError *error))failedBlock;

#pragma mark ****************************************Auxiliary************************************************

/// Configure the Positioning Strategy Downlink  For Position.
/// @param strategy strategy
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_configDownlinkPositioningStrategy:(mk_pb_positioningStrategy)strategy
                                    sucBlock:(void (^)(void))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock;

/// Status Of Man Down Detection .
/// @param isOn isOn
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_configManDownDetection:(BOOL)isOn
                         sucBlock:(void (^)(void))sucBlock
                      failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the Positioning Strategy Of Man Down.
/// @param strategy strategy
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_configManDownPositioningStrategy:(mk_pb_positioningStrategy)strategy
                                   sucBlock:(void (^)(void))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock;

/// Timeout Of ManDown Detection.
/// @param timeout 1Min~120Mins.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_configManDownDetectionTimeout:(NSInteger)timeout
                                sucBlock:(void (^)(void))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock;

/// Report Interval Of ManDown Detection.
/// @param interval 10s~600s.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_configManDownReportInterval:(NSInteger)interval
                              sucBlock:(void (^)(void))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock;

/// Notify Event On Man Down Start.
/// @param isOn isOn
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_configNotifyEventOnManDownStart:(BOOL)isOn
                                  sucBlock:(void (^)(void))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock;

/// Notify Event On Man Down End.
/// @param isOn isOn
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_configNotifyEventOnManDownEnd:(BOOL)isOn
                                sucBlock:(void (^)(void))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the vibration intensity of the motor.
/// @param intensity 0~100.If set to 0, it means to turn off motor vibration
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_configMotorVibrationIntensity:(NSInteger)intensity
                                sucBlock:(void (^)(void))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock;

/// Alarm Type.
/// @param alarmType alarmType
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_configAlarmType:(mk_pb_alarmType)alarmType
                  sucBlock:(void (^)(void))sucBlock
               failedBlock:(void (^)(NSError *error))failedBlock;

/// How many seconds long press the button to make the device exit the alarm.
/// @param pressTime 5s~15s
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_configExitAlarmTypeLongPressTime:(NSInteger)pressTime
                                   sucBlock:(void (^)(void))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock;

/// Notify Event On SOS Start.
/// @param isOn isOn
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_configNotifyEventOnSOSStart:(BOOL)isOn
                              sucBlock:(void (^)(void))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock;

/// Notify Event On SOS End.
/// @param isOn isOn
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_configNotifyEventOnSOSEnd:(BOOL)isOn
                            sucBlock:(void (^)(void))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the Positioning Strategy Of SOS.
/// @param strategy strategy
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_configSOSPositioningStrategy:(mk_pb_positioningStrategy)strategy
                               sucBlock:(void (^)(void))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock;

/// Report Interval Of SOS.
/// @param interval 10s~600s
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_configSOSReportInterval:(NSInteger)interval
                          sucBlock:(void (^)(void))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock;

/// Trigger Mode Of SOS.
/// @param triggerMode triggerMode
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
 + (void)pb_configSOSTriggerMode:(mk_pb_sosTriggerMode)triggerMode
                        sucBlock:(void (^)(void))sucBlock
                     failedBlock:(void (^)(NSError *error))failedBlock;

/// Notify Event On Alert Start.
/// @param isOn isOn
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_configNotifyEventOnAlertStart:(BOOL)isOn
                                sucBlock:(void (^)(void))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock;

/// Notify Event On Alert End.
/// @param isOn isOn
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_configNotifyEventOnAlertEnd:(BOOL)isOn
                              sucBlock:(void (^)(void))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the Positioning Strategy Of Alert.
/// @param strategy strategy
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_configAlertPositioningStrategy:(mk_pb_positioningStrategy)strategy
                                 sucBlock:(void (^)(void))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock;

/// Trigger Mode Of Alert.
/// @param triggerMode triggerMode
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
 + (void)pb_configAlertTriggerMode:(mk_pb_alertTriggerMode)triggerMode
                          sucBlock:(void (^)(void))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock;

#pragma mark **************************************** Position ************************************************

/// Positioning Timeout Of GPS.
/// @param timeout 60s~600s
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_configGpsPositioningTimeout:(NSInteger)timeout
                              sucBlock:(void (^)(void))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock;

/// PDOP Of Gps Fix.
/// @param pdop 25~100(Unit:100ms)
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_configPDOPOfGps:(NSInteger)pdop
                  sucBlock:(void (^)(void))sucBlock
               failedBlock:(void (^)(NSError *error))failedBlock;

/// Positioning Timeout Of Ble.
/// @param timeout 1s~10s
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_configBlePositioningTimeout:(NSInteger)timeout
                              sucBlock:(void (^)(void))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock;

/// The number of MACs for Bluetooth positioning.
/// @param number 1~15
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_configBlePositioningNumberOfMac:(NSInteger)number
                                  sucBlock:(void (^)(void))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock;

/// The device will uplink valid ADV data with RSSI no less than rssi dBm.
/// @param rssi -127 dBm ~ 0 dBm.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_configRssiFilterValue:(NSInteger)rssi
                        sucBlock:(void (^)(void))sucBlock
                     failedBlock:(void (^)(NSError *error))failedBlock;

/// Broadcast content filtering logic.
/// @param relationship relationship
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_configFilterRelationship:(mk_pb_filterRelationship)relationship
                           sucBlock:(void (^)(void))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock;

/// A switch to accurately filter Mac addresses.
/// @param isOn isOn
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_configFilterByMacPreciseMatch:(BOOL)isOn
                                sucBlock:(void (^)(void))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock;

/// Switch for reverse filtering of MAC addresses.
/// @param isOn isOn
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_configFilterByMacReverseFilter:(BOOL)isOn
                                 sucBlock:(void (^)(void))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock;

/// Filtered list of mac addresses.
/// @param macList You can set up to 10 filters.1-6 Bytes.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_configFilterMACAddressList:(NSArray <NSString *>*)macList
                             sucBlock:(void (^)(void))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock;

/// A switch to accurately filter Adv Name.
/// @param isOn isOn
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_configFilterByAdvNamePreciseMatch:(BOOL)isOn
                                    sucBlock:(void (^)(void))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock;

/// Switch for reverse filtering of Adv Name.
/// @param isOn isOn
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_configFilterByAdvNameReverseFilter:(BOOL)isOn
                                     sucBlock:(void (^)(void))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock;

/// Filtered list of Adv Name.
/// @param nameList You can set up to 10 filters.1-20 Characters.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_configFilterAdvNameList:(NSArray <NSString *>*)nameList
                          sucBlock:(void (^)(void))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock;

/// Switch status of filter by iBeacon.
/// @param isOn isOn
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_configFilterByBeaconStatus:(BOOL)isOn
                             sucBlock:(void (^)(void))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock;

/// Major filter range of iBeacon.
/// @param isOn isOn
/// @param minValue 0~65535(isOn=YES)
/// @param maxValue minValue~65535(isOn=YES)
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_configFilterByBeaconMajor:(BOOL)isOn
                            minValue:(NSInteger)minValue
                            maxValue:(NSInteger)maxValue
                            sucBlock:(void (^)(void))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock;

/// Minor filter range of iBeacon.
/// @param isOn isOn
/// @param minValue 0~65535(isOn=YES)
/// @param maxValue minValue~65535(isOn=YES)
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_configFilterByBeaconMinor:(BOOL)isOn
                            minValue:(NSInteger)minValue
                            maxValue:(NSInteger)maxValue
                            sucBlock:(void (^)(void))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock;

/// UUID status of filter by iBeacon.
/// @param uuid 0~16 Bytes.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_configFilterByBeaconUUID:(NSString *)uuid
                           sucBlock:(void (^)(void))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock;

/// Switch status of filter by MKiBeacon.
/// @param isOn isOn
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_configFilterByMKBeaconStatus:(BOOL)isOn
                               sucBlock:(void (^)(void))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock;

/// Major filter range of MKiBeacon.
/// @param isOn isOn
/// @param minValue 0~65535(isOn=YES)
/// @param maxValue minValue~65535(isOn=YES)
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_configFilterByMKBeaconMajor:(BOOL)isOn
                              minValue:(NSInteger)minValue
                              maxValue:(NSInteger)maxValue
                              sucBlock:(void (^)(void))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock;

/// Minor filter range of MKiBeacon.
/// @param isOn isOn
/// @param minValue 0~65535(isOn=YES)
/// @param maxValue minValue~65535(isOn=YES)
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_configFilterByMKBeaconMinor:(BOOL)isOn
                              minValue:(NSInteger)minValue
                              maxValue:(NSInteger)maxValue
                              sucBlock:(void (^)(void))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock;

/// UUID status of filter by MKiBeacon.
/// @param uuid 0~16 Bytes.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_configFilterByMKBeaconUUID:(NSString *)uuid
                             sucBlock:(void (^)(void))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock;

/// Switch status of filter by MKiBeacon&ACC.
/// @param isOn isOn
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_configFilterByMKBeaconAccStatus:(BOOL)isOn
                                  sucBlock:(void (^)(void))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock;

/// Major filter range of MKiBeacon&ACC.
/// @param isOn isOn
/// @param minValue 0~65535(isOn=YES)
/// @param maxValue minValue~65535(isOn=YES)
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_configFilterByMKBeaconAccMajor:(BOOL)isOn
                                 minValue:(NSInteger)minValue
                                 maxValue:(NSInteger)maxValue
                                 sucBlock:(void (^)(void))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock;

/// Minor filter range of MKiBeacon&ACC.
/// @param isOn isOn
/// @param minValue 0~65535(isOn=YES)
/// @param maxValue minValue~65535(isOn=YES)
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_configFilterByMKBeaconAccMinor:(BOOL)isOn
                                 minValue:(NSInteger)minValue
                                 maxValue:(NSInteger)maxValue
                                 sucBlock:(void (^)(void))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock;

/// UUID status of filter by MKiBeacon&ACC.
/// @param uuid 0~16 Bytes.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_configFilterByMKBeaconAccUUID:(NSString *)uuid
                                sucBlock:(void (^)(void))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock;

/// Switch status of filter by UID.
/// @param isOn isOn
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_configFilterByUIDStatus:(BOOL)isOn
                          sucBlock:(void (^)(void))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock;

/// Namespace ID of filter by UID.
/// @param namespaceID 0~10 Bytes
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_configFilterByUIDNamespaceID:(NSString *)namespaceID
                               sucBlock:(void (^)(void))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock;

/// Instance ID of filter by UID.
/// @param instanceID 0~6 Bytes
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_configFilterByUIDInstanceID:(NSString *)instanceID
                              sucBlock:(void (^)(void))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock;

/// Switch status of filter by URL.
/// @param isOn isOn
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_configFilterByURLStatus:(BOOL)isOn
                          sucBlock:(void (^)(void))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock;

/// Content of filter by URL.
/// @param content 0~29 Characters.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_configFilterByURLContent:(NSString *)content
                           sucBlock:(void (^)(void))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock;

/// Switch status of filter by TLM.
/// @param isOn isOn
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_configFilterByTLMStatus:(BOOL)isOn
                          sucBlock:(void (^)(void))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock;

/// TLM Version of filter by TLM.
/// @param version version
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_configFilterByTLMVersion:(mk_pb_filterByTLMVersion)version
                           sucBlock:(void (^)(void))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock;

/// The filter status of the BeaconX Pro-ACC device.
/// @param isOn isOn
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_configBXPAccFilterStatus:(BOOL)isOn
                           sucBlock:(void (^)(void))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock;

/// The filter status of the BeaconX Pro-T&H device.
/// @param isOn isOn
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_configBXPTHFilterStatus:(BOOL)isOn
                          sucBlock:(void (^)(void))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock;

/// Switch status of filter by Other.
/// @param isOn isOn
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_configFilterByOtherStatus:(BOOL)isOn
                            sucBlock:(void (^)(void))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock;

/// Add logical relationships for up to three sets of filter conditions.
/// @param relationship relationship
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_configFilterByOtherRelationship:(mk_pb_filterByOther)relationship
                                  sucBlock:(void (^)(void))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock;

/// Current filter conditions.
/// @param conditions conditions
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_configFilterByOtherConditions:(NSArray <mk_pb_BLEFilterRawDataProtocol>*)conditions
                                sucBlock:(void (^)(void))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock;

#pragma mark ****************************************设备lorawan信息设置************************************************

/// Configure the region information of LoRaWAN.
/// @param region region
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_configRegion:(mk_pb_loraWanRegion)region
               sucBlock:(void (^)(void))sucBlock
            failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure LoRaWAN network access type.
/// @param modem modem
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_configModem:(mk_pb_loraWanModem)modem
              sucBlock:(void (^)(void))sucBlock
           failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the DEVEUI of LoRaWAN.
/// @param devEUI Hexadecimal characters, length must be 16.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_configDEVEUI:(NSString *)devEUI
               sucBlock:(void (^)(void))sucBlock
            failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the APPEUI of LoRaWAN.
/// @param appEUI Hexadecimal characters, length must be 16.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_configAPPEUI:(NSString *)appEUI
               sucBlock:(void (^)(void))sucBlock
            failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the APPKEY of LoRaWAN.
/// @param appKey Hexadecimal characters, length must be 32.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_configAPPKEY:(NSString *)appKey
               sucBlock:(void (^)(void))sucBlock
            failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the DEVADDR of LoRaWAN.
/// @param devAddr Hexadecimal characters, length must be 8.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_configDEVADDR:(NSString *)devAddr
                sucBlock:(void (^)(void))sucBlock
             failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the APPSKEY of LoRaWAN.
/// @param appSkey Hexadecimal characters, length must be 32.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_configAPPSKEY:(NSString *)appSkey
                sucBlock:(void (^)(void))sucBlock
             failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the NWKSKEY of LoRaWAN.
/// @param nwkSkey Hexadecimal characters, length must be 32.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_configNWKSKEY:(NSString *)nwkSkey
                sucBlock:(void (^)(void))sucBlock
             failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the message type of LoRaWAN.
/// @param messageType messageType
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_configMessageType:(mk_pb_loraWanMessageType)messageType
                    sucBlock:(void (^)(void))sucBlock
                failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the CH of LoRaWAN.It is only used for US915,AU915,CN470.
/// @param chlValue Minimum value of CH.0 ~ 95
/// @param chhValue Maximum value of CH. chlValue ~ 95
/// @param sucBlock Success callback
/// @param failedBlock  Failure callback
+ (void)pb_configCHL:(NSInteger)chlValue
                 CHH:(NSInteger)chhValue
            sucBlock:(void (^)(void))sucBlock
         failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the DR of LoRaWAN.It is only used for CN470, CN779, EU433, EU868,KR920, IN865, RU864.
/// @param drValue 0~5
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_configDR:(NSInteger)drValue
           sucBlock:(void (^)(void))sucBlock
        failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure LoRaWAN uplink data sending strategy.
/// @param isOn ADR is on.
/// @param transmissions 1/2
/// @param DRL When the ADR switch is off, the range is 0~6.
/// @param DRH When the ADR switch is off, the range is DRL~6
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_configUplinkStrategy:(BOOL)isOn
                  transmissions:(NSInteger)transmissions
                            DRL:(NSInteger)DRL
                            DRH:(NSInteger)DRH
                       sucBlock:(void (^)(void))sucBlock
                    failedBlock:(void (^)(NSError *error))failedBlock;

/// It is only used for EU868,CN779, EU433 and RU864. Off: The uplink report interval will not be limit by region freqency. On:The uplink report interval will be limit by region freqency.
/// @param isOn isOn
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_configDutyCycleStatus:(BOOL)isOn
                        sucBlock:(void (^)(void))sucBlock
                     failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure Time Sync Interval.
/// @param interval 0h~255h.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_configTimeSyncInterval:(NSInteger)interval
                         sucBlock:(void (^)(void))sucBlock
                      failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure Network Check Interval Of Lorawan.
/// @param interval 0h~255h.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_configLorawanNetworkCheckInterval:(NSInteger)interval
                                    sucBlock:(void (^)(void))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure The Max retransmission times  Of Lorawan.(Only for the message type is confirmed.)
/// @param times 1~8
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_configLorawanMaxRetransmissionTimes:(NSInteger)times
                                      sucBlock:(void (^)(void))sucBlock
                                   failedBlock:(void (^)(NSError *error))failedBlock;

/// The ADR ACK LIMIT Of Lorawan.
/// @param value 1~255
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_configLorawanADRACKLimit:(NSInteger)value
                           sucBlock:(void (^)(void))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock;

/// The ADR ACK DELAY Of Lorawan.
/// @param value 1~255
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_configLorawanADRACKDelay:(NSInteger)value
                           sucBlock:(void (^)(void))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock;


@end

NS_ASSUME_NONNULL_END
