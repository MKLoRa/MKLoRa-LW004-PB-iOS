//
//  MKPBInterface.h
//  MKLoRaWAN-PB_Example
//
//  Created by aa on 2022/3/15.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MKPBSDKNormalDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKPBInterface : NSObject

#pragma mark ****************************************Device Service Information************************************************

/// Read product model
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_readDeviceModelWithSucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock;

/// Read device firmware information
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_readFirmwareWithSucBlock:(void (^)(id returnData))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock;

/// Read device hardware information
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_readHardwareWithSucBlock:(void (^)(id returnData))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock;

/// Read device software information
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_readSoftwareWithSucBlock:(void (^)(id returnData))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock;

/// Read device manufacturer information
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_readManufacturerWithSucBlock:(void (^)(id returnData))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock;

#pragma mark ****************************************System************************************************

/// Read battery voltage.
/*
 @{
 @"voltage":@"3000",        //Unit:mV
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_readBatteryVoltageWithSucBlock:(void (^)(id returnData))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock;

/// Turn off Device by button.
/*
 @{
 @"isOn":@(YES)
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_readTurnOffDeviceByButtonStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                           failedBlock:(void (^)(NSError *error))failedBlock;

/// Read Low Power Prompt.
/*
 @{
 @"value":@"10"
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_readLowPowerPromptWithSucBlock:(void (^)(id returnData))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock;

/// Read Low Power Payload.
/*
 @{
 @"isOn":@(YES)
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_readLowPowerPayloadWithSucBlock:(void (^)(id returnData))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock;


/// Read the broadcast name of the device.
/*
 @{
 @"deviceName":@"MOKO"
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_readDeviceNameWithSucBlock:(void (^)(id returnData))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock;

/// Read device broadcast time interval.(Unit:100ms)
/*
 @{
 @"interval":@"10"
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_readAdvIntervalWithSucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock;

/// Read the txPower of device.
/*
 @{
 @"txPower":@"0dBm"
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_readTxPowerWithSucBlock:(void (^)(id returnData))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock;

/// Read the broadcast timeout time in Bluetooth configuration mode.
/*
 @{
 @"timeout":@"10"
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_readBroadcastTimeoutWithSucBlock:(void (^)(id returnData))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock;

/// Is a password required when the device is connected.
/*
 @{
 @"need":@(YES)
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_readConnectationNeedPasswordWithSucBlock:(void (^)(id returnData))sucBlock
                                        failedBlock:(void (^)(NSError *error))failedBlock;

/// When the connected device requires a password, read the current connection password.
/*
 @{
 @"password":@"xxxxxxxxx"
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_readPasswordWithSucBlock:(void (^)(id returnData))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock;

/// Read the time zone of the device.
/*
 @{
 @"timeZone":@(-23)       //UTC-11:30
 }
 //-24~28((The time zone is in units of 30 minutes, UTC-12:00~UTC+14:00))
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_readTimeZoneWithSucBlock:(void (^)(id returnData))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock;

/// Wakeup Threshold Of 3-Axis.
/*
 @{
 @"threshold":@"3",         //Unit:16mg
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_readThreeAxisWakeupThresholdWithSucBlock:(void (^)(id returnData))sucBlock
                                        failedBlock:(void (^)(NSError *error))failedBlock;

/// Wakeup Duration Of 3-Axis.
/*
 @{
 @"duration":@"2",          //Unit:10ms
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_readThreeAxisWakeupDurationWithSucBlock:(void (^)(id returnData))sucBlock
                                       failedBlock:(void (^)(NSError *error))failedBlock;

/// Motion Threshold Of 3-Axis.
/*
 @{
 @"threshold":@"3",         //Unit:2mg
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_readThreeAxisMotionThresholdWithSucBlock:(void (^)(id returnData))sucBlock
                                        failedBlock:(void (^)(NSError *error))failedBlock;

/// Motion Duration Of 3-Axis.
/*
 @{
 @"duration":@"2",          //Unit:5ms
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_readThreeAxisMotionDurationWithSucBlock:(void (^)(id returnData))sucBlock
                                       failedBlock:(void (^)(NSError *error))failedBlock;

/// Read Motion Mode Trip End Timeout.(Unit:10s)
/*
 @{
 @"time":@"10",     //Unit:10s
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_readMotionModeTripEndTimeoutWithSucBlock:(void (^)(id returnData))sucBlock
                                        failedBlock:(void (^)(NSError * error))failedBlock;

/// Read the mac address of the device.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_readMacAddressWithSucBlock:(void (^)(id returnData))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock;

#pragma mark ****************************************Work Mode************************************************

/// Shut-Down Payload.
/*
 @{
 @"isOn":@(YES)
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_readShutDownPayloadStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                     failedBlock:(void (^)(NSError * error))failedBlock;

/// Read the working mode of the device.
/*
 @{
 @"mode":@"2"
 }
 
 0：Standby mode
 1：Timing mode
 2：Periodic mode
 3：Motion Mode
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_readWorkModeWithSucBlock:(void (^)(id returnData))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock;

/// Heartbeat Interval.
/*
 @{
 @"interval":@"720"     //Unit:Min.
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_readHeartbeatIntervalWithSucBlock:(void (^)(id returnData))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock;

/// Read Periodic Mode reporting interval.
/*
 @{
 @"interval":@"5",          //Unit:Min
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_readPeriodicModeReportIntervalWithSucBlock:(void (^)(id returnData))sucBlock
                                          failedBlock:(void (^)(NSError *error))failedBlock;

/// Read Periodic Mode positioning strategy.
/*
 @{
 @"strategy":@(1)
 }
 
 0:BLE
 1:GPS
 2:GPS+BLE
 
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_readPeriodicModePositioningStrategyWithSucBlock:(void (^)(id returnData))sucBlock
                                               failedBlock:(void (^)(NSError *error))failedBlock;

/// Read Timing Mode Reporting Time Point.
/*
 @[@{
 @"hour":@(0),
 @"minuteGear":@(0)
 },
 @{
 @"hour":@(0),
 @"minuteGear":@(1)
 }]
 
 hour:0~23,
 minuteGear:  0:00, 1:15, 2:30, 3:45
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_readTimingModeReportingTimePointWithSucBlock:(void (^)(id returnData))sucBlock
                                            failedBlock:(void (^)(NSError * error))failedBlock;

/// Read Timing Mode positioning strategy.
/*
 @{
 @"strategy":@(1)
 }
 
 0:BLE
 1:GPS
 2:GPS+BLE
 
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_readTimingModePositioningStrategyWithSucBlock:(void (^)(id returnData))sucBlock
                                             failedBlock:(void (^)(NSError *error))failedBlock;

/// Read Motion Mode Events.
/*
 @{
     @"fixOnStart":@(YES),
     @"fixInTrip":@(NO),
     @"fixOnEnd":@(YES),
     @"notifyEventOnStart":@(NO),
     @"notifyEventInTrip":@(NO),
     @"notifyEventOnEnd":@(YES),
 };
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_readMotionModeEventsWithSucBlock:(void (^)(id returnData))sucBlock
                                failedBlock:(void (^)(NSError * error))failedBlock;

/// Read Motion Mode Pos-Strategy On Start.
/*
 @{
 @"strategy":@(1)
 }
 
 0:BLE
 1:GPS
 2:GPS+BLE
 
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_readMotionModePosStrategyOnStartWithSucBlock:(void (^)(id returnData))sucBlock
                                            failedBlock:(void (^)(NSError * error))failedBlock;

/// Read Motion Mode Number Of Fix On Start.
/*
 @{
 @"number":@"1"
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_readMotionModeNumberOfFixOnStartWithSucBlock:(void (^)(id returnData))sucBlock
                                            failedBlock:(void (^)(NSError * error))failedBlock;

/// Read Motion Mode Pos-Strategy In Trip.
/*
 @{
 @"strategy":@(1)
 }
 
 0:BLE
 1:GPS
 2:GPS+BLE
 
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_readMotionModePosStrategyInTripWithSucBlock:(void (^)(id returnData))sucBlock
                                           failedBlock:(void (^)(NSError * error))failedBlock;

/// Read Motion Mode Report Interval In Trip.
/*
 @{
 @"interval":@"5"
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_readMotionModeReportIntervalInTripWithSucBlock:(void (^)(id returnData))sucBlock
                                              failedBlock:(void (^)(NSError * error))failedBlock;

/// Read Motion Mode Pos-Strategy On End.
/*
 @{
 @"strategy":@(1)
 }
 
 0:BLE
 1:GPS
 2:GPS+BLE
 
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_readMotionModePosStrategyOnEndWithSucBlock:(void (^)(id returnData))sucBlock
                                          failedBlock:(void (^)(NSError * error))failedBlock;

/// Read Motion Mode Number Of Fix On End.
/*
 @{
 @"number":@"1"
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_readMotionModeNumberOfFixOnEndWithSucBlock:(void (^)(id returnData))sucBlock
                                          failedBlock:(void (^)(NSError * error))failedBlock;

/// Read Motion Mode Report Interval On End.
/*
 @{
 @"interval":@"120"
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_readMotionModeReportIntervalOnEndWithSucBlock:(void (^)(id returnData))sucBlock
                                             failedBlock:(void (^)(NSError * error))failedBlock;

#pragma mark ****************************************Auxiliary************************************************

/// Read the Positioning Strategy Downlink  For Position.
/*
 @{
 @"strategy":@(1)
 }
 
 0:BLE
 1:GPS
 2:GPS+BLE
 
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_readDownlinkPositioningStrategyWithSucBlock:(void (^)(id returnData))sucBlock
                                           failedBlock:(void (^)(NSError * error))failedBlock;

/// Status Of Man Down Detection .
/*
 @{
 @"isOn":@(YES)
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_readManDownDetectionWithSucBlock:(void (^)(id returnData))sucBlock
                                failedBlock:(void (^)(NSError * error))failedBlock;

/// Read the Positioning Strategy Of Man Down.
/*
 @{
 @"strategy":@(1)
 }
 
 0:BLE
 1:GPS
 2:GPS+BLE
 
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_readManDownPositioningStrategyWithSucBlock:(void (^)(id returnData))sucBlock
                                          failedBlock:(void (^)(NSError * error))failedBlock;

/// Timeout Of ManDown Detection.
/*
 @{
 @"timeout":@"10",      //Unit:Mins.
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_readManDownDetectionTimeoutWithSucBlock:(void (^)(id returnData))sucBlock
                                       failedBlock:(void (^)(NSError * error))failedBlock;

/// Report Interval Of ManDown Detection.
/*
 @{
 @"interval":@"120",        //Unit:S
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_readManDownReportIntervalWithSucBlock:(void (^)(id returnData))sucBlock
                                     failedBlock:(void (^)(NSError * error))failedBlock;

/// Notify Event On Man Down Start.
/*
 @{
 @"isOn":@(YES)
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_readNotifyEventOnManDownStartWithSucBlock:(void (^)(id returnData))sucBlock
                                         failedBlock:(void (^)(NSError * error))failedBlock;

/// Notify Event On Man Down End.
/*
 @{
 @"isOn":@(YES)
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_readNotifyEventOnManDownEndWithSucBlock:(void (^)(id returnData))sucBlock
                                       failedBlock:(void (^)(NSError * error))failedBlock;

/// Read the vibration intensity of the motor.
/*
 @{
 @"intensity":@"80"
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_readMotorVibrationIntensityWithSucBlock:(void (^)(id returnData))sucBlock
                                       failedBlock:(void (^)(NSError * error))failedBlock;

/// Alarm Type.
/*
 @{
 @"alarmType":@"0"  //@"0":No     @"1":Alert       @"2":@"SOS"
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_readAlarmTypeWithSucBlock:(void (^)(id returnData))sucBlock
                         failedBlock:(void (^)(NSError * error))failedBlock;

/// How many seconds long press the button to make the device exit the alarm.
/*
 @{
 @"time":@"15",         //Unit:s
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_readExitAlarmTypeLongPressTimeWithSucBlock:(void (^)(id returnData))sucBlock
                                          failedBlock:(void (^)(NSError * error))failedBlock;

/// Notify Event On SOS Start.
/*
 @{
 @"isOn":@(YES)
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_readNotifyEventOnSOSStartWithSucBlock:(void (^)(id returnData))sucBlock
                                     failedBlock:(void (^)(NSError * error))failedBlock;

/// Notify Event On SOS End.
/*
 @{
 @"isOn":@(YES)
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_readNotifyEventOnSOSEndWithSucBlock:(void (^)(id returnData))sucBlock
                                   failedBlock:(void (^)(NSError * error))failedBlock;

/// Read the Positioning Strategy Of SOS.
/*
 @{
 @"strategy":@(1)
 }
 
 0:BLE
 1:GPS
 2:GPS+BLE
 
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_readSOSPositioningStrategyWithSucBlock:(void (^)(id returnData))sucBlock
                                      failedBlock:(void (^)(NSError * error))failedBlock;

/// Report Interval Of SOS.
/*
 @{
 @"interval":@"120",        //Unit:S
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_readSOSReportIntervalWithSucBlock:(void (^)(id returnData))sucBlock
                                 failedBlock:(void (^)(NSError * error))failedBlock;

/// Trigger Mode Of SOS.
/*
 @{
 @"triggerMode":@"0"
 }
 @"0":"Double Click",
 @"1":"Triple Click",
 @"2":"Long Press 1s",
 @"3":"Long Press 2s",
 @"4":"Long Press 3s",
 @"5":"Long Press 4s",
 @"6":"Long Press 5s"
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_readSOSTriggerModeWithSucBlock:(void (^)(id returnData))sucBlock
                              failedBlock:(void (^)(NSError * error))failedBlock;

/// Notify Event On Alert Start.
/*
 @{
 @"isOn":@(YES)
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_readNotifyEventOnAlertStartWithSucBlock:(void (^)(id returnData))sucBlock
                                       failedBlock:(void (^)(NSError * error))failedBlock;

/// Notify Event On Alert End.
/*
 @{
 @"isOn":@(YES)
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_readNotifyEventOnAlertEndWithSucBlock:(void (^)(id returnData))sucBlock
                                     failedBlock:(void (^)(NSError * error))failedBlock;

/// Read the Positioning Strategy Of Alert.
/*
 @{
 @"strategy":@(1)
 }
 
 0:BLE
 1:GPS
 2:GPS+BLE
 
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_readAlertPositioningStrategyWithSucBlock:(void (^)(id returnData))sucBlock
                                        failedBlock:(void (^)(NSError * error))failedBlock;

/// Trigger Mode Of Alert.
/*
 @{
 @"triggerMode":@"0"
 }
 @"0":"Single Click",
 @"1":"Double Click",
 @"2":"Long Press 1s",
 @"3":"Long Press 2s",
 @"4":"Long Press 3s",
 @"5":"Long Press 4s",
 @"6":"Long Press 5s"
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_readAlertTriggerModeWithSucBlock:(void (^)(id returnData))sucBlock
                                failedBlock:(void (^)(NSError * error))failedBlock;

#pragma mark **************************************** Position ************************************************

/// Positioning Timeout Of Ble.
/*
 @{
 @"timeout":@"5"            //unit:s
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_readGpsPositioningTimeoutWithSucBlock:(void (^)(id returnData))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock;

/// PDOP Of Gps Fix.
/*
 @{
 @"pdop":@"30",         //Unit:100ms
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_readPDOPOfGpsWithSucBlock:(void (^)(id returnData))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock;

/// Positioning Timeout Of Ble.
/*
 @{
 @"timeout":@"5"            //unit:s
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_readBlePositioningTimeoutWithSucBlock:(void (^)(id returnData))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock;

/// The number of MACs for Bluetooth positioning.
/*
 @{
 @"number":@"3"
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_readBlePositioningNumberOfMacWithSucBlock:(void (^)(id returnData))sucBlock
                                         failedBlock:(void (^)(NSError *error))failedBlock;

/// The device will uplink valid ADV data with RSSI no less than xx dBm.
/*
 @{
 @"rssi":@"-127"
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_readRssiFilterValueWithSucBlock:(void (^)(id returnData))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock;

/// Broadcast content filtering logic.
/*
 @{
 @"relationship":@"4"
 }
 @"0":Null
 @"1":MAC
 @"2":ADV Name
 @"3":Raw Data
 @"4":ADV Name & Raw Data
 @"5":MAC & ADV Name & Raw Data
 @"6":ADV Name | Raw Data
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_readFilterRelationshipWithSucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock;

/// A switch to accurately filter Mac addresses.
/*
 @{
 @"isOn":@(YES)
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_readFilterByMacPreciseMatchWithSucBlock:(void (^)(id returnData))sucBlock
                                       failedBlock:(void (^)(NSError *error))failedBlock;

/// Switch for reverse filtering of MAC addresses.
/*
 @{
 @"isOn":@(YES)
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_readFilterByMacReverseFilterWithSucBlock:(void (^)(id returnData))sucBlock
                                        failedBlock:(void (^)(NSError *error))failedBlock;

/// Filtered list of mac addresses.
/*
 @{
 @"macList":@[
    @"aabb",
 @"aabbccdd",
 @"ddeeff"
 ],
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_readFilterMACAddressListWithSucBlock:(void (^)(id returnData))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock;

/// A switch to accurately filter Adv Name.
/*
 @{
 @"isOn":@(YES)
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_readFilterByAdvNamePreciseMatchWithSucBlock:(void (^)(id returnData))sucBlock
                                           failedBlock:(void (^)(NSError *error))failedBlock;

/// Switch for reverse filtering of Adv Name.
/*
 @{
 @"isOn":@(YES)
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_readFilterByAdvNameReverseFilterWithSucBlock:(void (^)(id returnData))sucBlock
                                            failedBlock:(void (^)(NSError *error))failedBlock;

/// Filtered list of mac addresses.
/*
 @{
 @"nameList":@[
    @"moko",
 @"LW004-PB",
 @"asdf"
 ],
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_readFilterAdvNameListWithSucBlock:(void (^)(id returnData))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock;

/// Read switch status of filtered device types.
/*
 @{
 @"unknown":@(YES),
 @"iBeacon":@(NO),
 @"uid":@(NO),
 @"url":@(NO),
 @"tlm":@(NO),
 @"bxp_acc":@(YES),
 @"bxp_th":@(YES),
 @"mk_iBeacon":@(YES),
 @"mk_iBeacon_acc":@(YES)
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_readFilterTypeStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock;

/// Switch status of filter by iBeacon.
/*
 @{
 @"isOn":@(YES)
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_readFilterByBeaconStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock;

/// Major filter range of iBeacon.
/*
 @{
     @"isOn":@(YES),
     @"minValue":@"00",         //isOn=YES
     @"maxValue":@"11",         //isOn=YES
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_readFilterByBeaconMajorRangeWithSucBlock:(void (^)(id returnData))sucBlock
                                        failedBlock:(void (^)(NSError *error))failedBlock;

/// Minor filter range of iBeacon.
/*
 @{
     @"isOn":@(YES),
     @"minValue":@"00",         //isOn=YES
     @"maxValue":@"11",         //isOn=YES
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_readFilterByBeaconMinorRangeWithSucBlock:(void (^)(id returnData))sucBlock
                                        failedBlock:(void (^)(NSError *error))failedBlock;

/// UUID status of filter by iBeacon.
/*
 @{
 @"uuid":@"xx"
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_readFilterByBeaconUUIDWithSucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock;

/// Switch status of filter by MKiBeacon.
/*
 @{
 @"isOn":@(YES)
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_readFilterByMKBeaconStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                      failedBlock:(void (^)(NSError *error))failedBlock;

/// Major filter range of MKiBeacon.
/*
 @{
     @"isOn":@(YES),
     @"minValue":@"00",         //isOn=YES
     @"maxValue":@"11",         //isOn=YES
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_readFilterByMKBeaconMajorRangeWithSucBlock:(void (^)(id returnData))sucBlock
                                          failedBlock:(void (^)(NSError *error))failedBlock;

/// Minor filter range of MKiBeacon.
/*
 @{
     @"isOn":@(YES),
     @"minValue":@"00",         //isOn=YES
     @"maxValue":@"11",         //isOn=YES
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_readFilterByMKBeaconMinorRangeWithSucBlock:(void (^)(id returnData))sucBlock
                                          failedBlock:(void (^)(NSError *error))failedBlock;

/// UUID status of filter by MKiBeacon.
/*
 @{
 @"uuid":@"xx"
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_readFilterByMKBeaconUUIDWithSucBlock:(void (^)(id returnData))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock;


/// Switch status of filter by MKiBeacon&ACC.
/*
 @{
 @"isOn":@(YES)
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_readFilterByMKBeaconAccStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                         failedBlock:(void (^)(NSError *error))failedBlock;

/// Major filter range of MKiBeacon&ACC.
/*
 @{
     @"isOn":@(YES),
     @"minValue":@"00",         //isOn=YES
     @"maxValue":@"11",         //isOn=YES
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_readFilterByMKBeaconAccMajorRangeWithSucBlock:(void (^)(id returnData))sucBlock
                                             failedBlock:(void (^)(NSError *error))failedBlock;

/// Minor filter range of MKiBeacon&ACC.
/*
 @{
     @"isOn":@(YES),
     @"minValue":@"00",         //isOn=YES
     @"maxValue":@"11",         //isOn=YES
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_readFilterByMKBeaconAccMinorRangeWithSucBlock:(void (^)(id returnData))sucBlock
                                             failedBlock:(void (^)(NSError *error))failedBlock;

/// UUID status of filter by iBeacon.
/*
 @{
 @"uuid":@"xx"
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_readFilterByMKBeaconAccUUIDWithSucBlock:(void (^)(id returnData))sucBlock
                                       failedBlock:(void (^)(NSError *error))failedBlock;

/// Switch status of filter by UID.
/*
 @{
 @"isOn":@(YES)
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_readFilterByUIDStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock;

/// Namespace ID of filter by UID.
/*
 @{
 @"namespaceID":@"aabb"
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_readFilterByUIDNamespaceIDWithSucBlock:(void (^)(id returnData))sucBlock
                                      failedBlock:(void (^)(NSError *error))failedBlock;

/// Instance ID of filter by UID.
/*
 @{
 @"instanceID":@"aabb"
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_readFilterByUIDInstanceIDWithSucBlock:(void (^)(id returnData))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock;

/// Switch status of filter by URL.
/*
 @{
 @"isOn":@(YES)
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_readFilterByURLStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock;

/// Content of filter by URL.
/*
 @{
 @"url":@"moko.com"
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_readFilterByURLContentWithSucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock;

/// Switch status of filter by TLM.
/*
 @{
 @"isOn":@(YES)
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_readFilterByTLMStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock;

/// TLM Version of filter by TLM.
/*
 @{
 @"version":@"0",           //@"0":Null(Do not filter data)   @"1":Unencrypted TLM data. @"2":Encrypted TLM data.
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_readFilterByTLMVersionWithSucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock;


/// Read the filter status of the BeaconX Pro-ACC device.
/*
 @{
 @"isOn":@(YES)
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_readBXPAccFilterStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock;

/// Read the filter status of the BeaconX Pro-T&H device.
/*
 @{
 @"isOn":@(YES)
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_readBXPTHFilterStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock;

/// Switch status of filter by Other.
/*
 @{
 @"isOn":@(YES)
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_readFilterByOtherStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                   failedBlock:(void (^)(NSError *error))failedBlock;

/// Add logical relationships for up to three sets of filter conditions.
/*
 @{
 @"relationship":@"0",
 }
  0:A
  1:A & B
  2:A | B
  3:A & B & C
  4:(A & B) | C
  5:A | B | C
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_readFilterByOtherRelationshipWithSucBlock:(void (^)(id returnData))sucBlock
                                         failedBlock:(void (^)(NSError *error))failedBlock;

/// Current filter.
/*
 @{
    @"conditionList":@[
            @{
                @"type":@"00",
                @"start":@"0"
                @"end":@"3",
                @"data":@"001122"
            },
            @{
                @"type":@"03",
                @"start":@"1"
                @"end":@"2",
                @"data":@"0011"
            }
        ]
    }
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_readFilterByOtherConditionsWithSucBlock:(void (^)(id returnData))sucBlock
                                       failedBlock:(void (^)(NSError *error))failedBlock;

#pragma mark **************************************** LoRaWAN ************************************************
/// Read the region information of LoRaWAN.
/*
 0:AS923 
 1:AU915
 2:CN470
 3:CN779
 4:EU433
 5:EU868
 6:KR920
 7:IN865
 8:US915
 9:RU864
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_readLorawanRegionWithSucBlock:(void (^)(id returnData))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock;

/// Read LoRaWAN network access type.
/*
 1:ABP
 2:OTAA
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_readLorawanModemWithSucBlock:(void (^)(id returnData))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock;

/// Read the current network status of LoRaWAN.
/*
    0:Connecting
    1:OTAA network access or ABP mode.
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_readLorawanNetworkStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock;

/// Read the DEVEUI of LoRaWAN.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_readLorawanDEVEUIWithSucBlock:(void (^)(id returnData))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock;

/// Read the APPEUI of LoRaWAN.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_readLorawanAPPEUIWithSucBlock:(void (^)(id returnData))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock;

/// Read the APPKEY of LoRaWAN.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_readLorawanAPPKEYWithSucBlock:(void (^)(id returnData))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock;

/// Read the DEVADDR of LoRaWAN.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_readLorawanDEVADDRWithSucBlock:(void (^)(id returnData))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock;

/// Read the APPSKEY of LoRaWAN.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_readLorawanAPPSKEYWithSucBlock:(void (^)(id returnData))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock;

/// Read the NWKSKEY of LoRaWAN.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_readLorawanNWKSKEYWithSucBlock:(void (^)(id returnData))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock;

/// Read lorawan upstream data type.
/*
 0:Non-acknowledgement frame.
 1:Confirm the frame.
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_readLorawanMessageTypeWithSucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock;

/// Read lorawan CH.It is only used for US915,AU915,CN470.
/*
 @{
 @"CHL":0
 @"CHH":2
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_readLorawanCHWithSucBlock:(void (^)(id returnData))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock;

/// Read lorawan DR.It is only used for CN470, CN779, EU433, EU868,KR920, IN865, RU864.
/*
 @{
 @"DR":1
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_readLorawanDRWithSucBlock:(void (^)(id returnData))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock;

/// Read Uplink Strategy  Of Lorawan.
/*
 @{
 @"isOn":@(isOn),
 @"transmissions":transmissions,
 @"DRL":DRL,            //DR For Payload Low.
 @"DRH":DRH,            //DR For Payload High.
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_readLorawanUplinkStrategyWithSucBlock:(void (^)(id returnData))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock;

/// Read lorawan duty cycle status.It is only used for EU868,CN779, EU433 and RU864.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_readLorawanDutyCycleStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                      failedBlock:(void (^)(NSError *error))failedBlock;

/// Read lorawan devtime command synchronization interval.(Hour)
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_readLorawanTimeSyncIntervalWithSucBlock:(void (^)(id returnData))sucBlock
                                       failedBlock:(void (^)(NSError *error))failedBlock;

/// Read Network Check Interval Of Lorawan.(Hour)
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_readLorawanNetworkCheckIntervalWithSucBlock:(void (^)(id returnData))sucBlock
                                           failedBlock:(void (^)(NSError *error))failedBlock;

/// Read The Max retransmission times  Of Lorawan.(Only for the message type is confirmed.)
/*
 @{
 @"number":@"2"
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_readLorawanMaxRetransmissionTimesWithSucBlock:(void (^)(id returnData))sucBlock
                                             failedBlock:(void (^)(NSError *error))failedBlock;

/// Read The ADR ACK LIMIT Of Lorawan.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_readLorawanADRACKLimitWithSucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock;

/// Read The ADR ACK DELAY Of Lorawan.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)pb_readLorawanADRACKDelayWithSucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
