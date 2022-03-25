
#pragma mark ****************************************Enumerate************************************************

#pragma mark - MKPBCentralManager

typedef NS_ENUM(NSInteger, mk_pb_centralConnectStatus) {
    mk_pb_centralConnectStatusUnknow,                                           //未知状态
    mk_pb_centralConnectStatusConnecting,                                       //正在连接
    mk_pb_centralConnectStatusConnected,                                        //连接成功
    mk_pb_centralConnectStatusConnectedFailed,                                  //连接失败
    mk_pb_centralConnectStatusDisconnect,
};

typedef NS_ENUM(NSInteger, mk_pb_centralManagerStatus) {
    mk_pb_centralManagerStatusUnable,                           //不可用
    mk_pb_centralManagerStatusEnable,                           //可用状态
};

typedef NS_ENUM(NSInteger, mk_pb_deviceMode) {
    mk_pb_deviceMode_standbyMode,         //Standby mode
    mk_pb_deviceMode_timingMode,          //Timing mode
    mk_pb_deviceMode_periodicMode,        //Periodic mode
    mk_pb_deviceMode_motionMode,          //Motion Mode
};

typedef NS_ENUM(NSInteger, mk_pb_positioningStrategy) {
    mk_pb_positioningStrategy_ble,
    mk_pb_positioningStrategy_gps,
    mk_pb_positioningStrategy_bleAndGps,
};

typedef NS_ENUM(NSInteger, mk_pb_alarmType) {
    mk_pb_alarmType_no,
    mk_pb_alarmType_alert,
    mk_pb_alarmType_sos,
};

typedef NS_ENUM(NSInteger, mk_pb_sosTriggerMode) {
    mk_pb_sosTriggerMode_doubleClick,
    mk_pb_sosTriggerMode_tripleClick,
    mk_pb_sosTriggerMode_longPressOneSec,
    mk_pb_sosTriggerMode_longPressTwoSec,
    mk_pb_sosTriggerMode_longPressThreeSec,
    mk_pb_sosTriggerMode_longPressFourSec,
    mk_pb_sosTriggerMode_longPressFiveSec,
};

typedef NS_ENUM(NSInteger, mk_pb_alertTriggerMode) {
    mk_pb_alertTriggerMode_singleClick,
    mk_pb_alertTriggerMode_doubleClick,
    mk_pb_alertTriggerMode_longPressOneSec,
    mk_pb_alertTriggerMode_longPressTwoSec,
    mk_pb_alertTriggerMode_longPressThreeSec,
    mk_pb_alertTriggerMode_longPressFourSec,
    mk_pb_alertTriggerMode_longPressFiveSec,
};

typedef NS_ENUM(NSInteger, mk_pb_filterRelationship) {
    mk_pb_filterRelationship_null,
    mk_pb_filterRelationship_mac,
    mk_pb_filterRelationship_advName,
    mk_pb_filterRelationship_rawData,
    mk_pb_filterRelationship_advNameAndRawData,
    mk_pb_filterRelationship_macAndadvNameAndRawData,
    mk_pb_filterRelationship_advNameOrRawData,
};

typedef NS_ENUM(NSInteger, mk_pb_filterByTLMVersion) {
    mk_pb_filterByTLMVersion_null,             //Do not filter data.
    mk_pb_filterByTLMVersion_0,                //Unencrypted TLM data.
    mk_pb_filterByTLMVersion_1,                //Encrypted TLM data.
};

typedef NS_ENUM(NSInteger, mk_pb_filterByOther) {
    mk_pb_filterByOther_A,                 //Filter by A condition.
    mk_pb_filterByOther_AB,                //Filter by A & B condition.
    mk_pb_filterByOther_AOrB,              //Filter by A | B condition.
    mk_pb_filterByOther_ABC,               //Filter by A & B & C condition.
    mk_pb_filterByOther_ABOrC,             //Filter by (A & B) | C condition.
    mk_pb_filterByOther_AOrBOrC,           //Filter by A | B | C condition.
};

typedef NS_ENUM(NSInteger, mk_pb_loraWanRegion) {
    mk_pb_loraWanRegionAS923,
    mk_pb_loraWanRegionAU915,
    mk_pb_loraWanRegionCN470,
    mk_pb_loraWanRegionCN779,
    mk_pb_loraWanRegionEU433,
    mk_pb_loraWanRegionEU868,
    mk_pb_loraWanRegionKR920,
    mk_pb_loraWanRegionIN865,
    mk_pb_loraWanRegionUS915,
    mk_pb_loraWanRegionRU864,
};

typedef NS_ENUM(NSInteger, mk_pb_loraWanModem) {
    mk_pb_loraWanModemABP,
    mk_pb_loraWanModemOTAA,
};

typedef NS_ENUM(NSInteger, mk_pb_loraWanMessageType) {
    mk_pb_loraWanUnconfirmMessage,          //Non-acknowledgement frame.
    mk_pb_loraWanConfirmMessage,            //Confirm the frame.
};

typedef NS_ENUM(NSInteger, mk_pb_txPower) {
    mk_pb_txPowerNeg40dBm,   //RadioTxPower:-40dBm
    mk_pb_txPowerNeg20dBm,   //-20dBm
    mk_pb_txPowerNeg16dBm,   //-16dBm
    mk_pb_txPowerNeg12dBm,   //-12dBm
    mk_pb_txPowerNeg8dBm,    //-8dBm
    mk_pb_txPowerNeg4dBm,    //-4dBm
    mk_pb_txPower0dBm,       //0dBm
    mk_pb_txPower3dBm,       //3dBm
    mk_pb_txPower4dBm,       //4dBm
};



@protocol mk_pb_timingModeReportingTimePointProtocol <NSObject>

/// 0~23
@property (nonatomic, assign)NSInteger hour;

/// 0:00   1:15   2:30   3:45
@property (nonatomic, assign)NSInteger minuteGear;

@end



@protocol mk_pb_motionModeEventsProtocol <NSObject>

@property (nonatomic, assign)BOOL notifyEventOnStart;

@property (nonatomic, assign)BOOL fixOnStart;

@property (nonatomic, assign)BOOL notifyEventInTrip;

@property (nonatomic, assign)BOOL fixInTrip;

@property (nonatomic, assign)BOOL notifyEventOnEnd;

@property (nonatomic, assign)BOOL fixOnEnd;

@end





@protocol mk_pb_BLEFilterRawDataProtocol <NSObject>

/// The currently filtered data type, refer to the definition of different Bluetooth data types by the International Bluetooth Organization, 1 byte of hexadecimal data
@property (nonatomic, copy)NSString *dataType;

/// Data location to start filtering.
@property (nonatomic, assign)NSInteger minIndex;

/// Data location to end filtering.
@property (nonatomic, assign)NSInteger maxIndex;

/// The currently filtered content. If minIndex==0,maxIndex must be 0.The data length should be maxIndex-minIndex, if maxIndex=0&&minIndex==0, the item length is not checked whether it meets the requirements.MAX length:29 Bytes
@property (nonatomic, copy)NSString *rawData;

@end

#pragma mark ****************************************Delegate************************************************

@protocol mk_pb_centralManagerScanDelegate <NSObject>

/// Scan to new device.
/// @param deviceModel device
/*
 @{
 @"rssi":@(-55),
 @"peripheral":peripheral,
 @"deviceName":@"LW004-PB",
 @"macAddress":@"AA:BB:CC:DD:EE:FF",
 @"voltage":@"3.333",           //V
 @"battery":@"100",             //battery power
 @"needPassword":@(needPassword),
 @"deviceMode":deviceMode,      //1:Standby mode 2:Timing Mode 3:Periodic mode 4:Movement begins 5:in motion 6:the end of the movement
 @"deviceState":deviceState,    //1:Alert  2:SOS  3:ManDown 4:Downlink request positioning.
 @"connectable":advDic[CBAdvertisementDataIsConnectable],
 @"txPower":advDic[CBAdvertisementDataTxPowerLevelKey],
 }
 */
- (void)mk_pb_receiveDevice:(NSDictionary *)deviceModel;

@optional

/// Starts scanning equipment.
- (void)mk_pb_startScan;

/// Stops scanning equipment.
- (void)mk_pb_stopScan;

@end


@protocol mk_pb_centralManagerLogDelegate <NSObject>

- (void)mk_pb_receiveLog:(NSString *)deviceLog;

@end
