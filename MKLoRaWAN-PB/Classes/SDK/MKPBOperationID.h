
typedef NS_ENUM(NSInteger, mk_pb_taskOperationID) {
    mk_pb_defaultTaskOperationID,
    
#pragma mark - Read
    mk_pb_taskReadDeviceModelOperation,        //读取产品型号
    mk_pb_taskReadFirmwareOperation,           //读取固件版本
    mk_pb_taskReadHardwareOperation,           //读取硬件类型
    mk_pb_taskReadSoftwareOperation,           //读取软件版本
    mk_pb_taskReadManufacturerOperation,       //读取厂商信息
    mk_pb_taskReadDeviceTypeOperation,         //读取产品类型
    
#pragma mark - 密码特征
    mk_pb_connectPasswordOperation,             //连接设备时候发送密码
    
#pragma mark - 系统参数
    mk_pb_taskReadBatteryVoltageOperation,              //读取电池电压
    mk_pb_taskReadTurnOffDeviceByButtonStatusOperation,           //读取按键关机状态
    mk_pb_taskReadLowPowerPromptOperation,              //读取低电档位
    mk_pb_taskReadLowPowerPayloadOperation,             //读取低点上报状态
    mk_pb_taskReadDeviceNameOperation,                  //读取设备广播名称
    mk_pb_taskReadAdvIntervalOperation,                 //读取广播间隔
    mk_pb_taskReadTxPowerOperation,                     //读取发射功率
    mk_pb_taskReadBroadcastTimeoutOperation,            //读取广播超时时长
    mk_pb_taskReadConnectationNeedPasswordOperation,    //读取密码开关
    mk_pb_taskReadPasswordOperation,                    //读取设备连接密码
    mk_pb_taskReadTimeZoneOperation,                    //读取时区
    mk_pb_taskReadThreeAxisWakeupThresholdOperation,    //读取三轴唤醒触发阈值
    mk_pb_taskReadThreeAxisWakeupDurationOperation,     //读取三轴唤醒判断时间
    mk_pb_taskReadThreeAxisMotionThresholdOperation,    //读取三轴运动触发阈值
    mk_pb_taskReadThreeAxisMotionDurationOperation,     //读取三轴运动判断时间
    mk_pb_taskReadMotionModeTripEndTimeoutOperation,    //读取运动结束时间
    mk_pb_taskReadMacAddressOperation,              //读取mac地址
    mk_pb_taskReadPCBAStatusOperation,              //读取产测状态
    mk_pb_taskReadSelftestStatusOperation,          //读取自检故障原因
    
#pragma mark - 工作模式
    mk_pb_taskReadShutDownPayloadStatusOperation,       //读取关机信息上报状态
    mk_pb_taskReadWorkModeOperation,            //读取工作模式
    mk_pb_taskReadHeartbeatIntervalOperation,   //读取心跳包上报间隔
    mk_pb_taskReadPeriodicModeReportIntervalOperation,      //读取定期模式定位数据上报间隔
    mk_pb_taskReadPeriodicModePositioningStrategyOperation, //读取定期模式下定位策略
    mk_pb_taskReadTimingModeReportingTimePointOperation,    //读取定时上报时间点
    mk_pb_taskReadTimingModePositioningStrategyOperation,   //读取定时模式下定位策略
    mk_pb_taskReadMotionModeEventsOperation,                //读取运动模式事件
    mk_pb_taskReadMotionModePosStrategyOnStartOperation,            //读取运动开始定位策略
    mk_pb_taskReadMotionModeNumberOfFixOnStartOperation,            //读取运动开始定位上报次数
    mk_pb_taskReadMotionModePosStrategyInTripOperation,             //读取运动中定位策略
    mk_pb_taskReadMotionModeReportIntervalInTripOperation,          //读取运动中定位间隔
    mk_pb_taskReadMotionModePosStrategyOnEndOperation,              //读取运动结束定位策略
    mk_pb_taskReadMotionModeNumberOfFixOnEndOperation,              //读取运动结束定位次数
    mk_pb_taskReadMotionModeReportIntervalOnEndOperation,           //读取运动结束定位间隔
    
#pragma mark - 辅助功能
    mk_pb_taskReadDownlinkPositioningStrategyOperation,             //读取下行定位请求定位策略
    mk_pb_taskReadManDownDetectionOperation,                        //读取ManDown功能开关
    mk_pb_taskReadManDownPositioningStrategyOperation,              //读取ManDown定位策略
    mk_pb_taskReadManDownDetectionTimeoutOperation,                 //读取ManDown检测超时时间
    mk_pb_taskReadManDownReportIntervalOperation,                   //读取ManDown定位数据上报间隔
    mk_pb_taskReadNotifyEventOnManDownStartOperation,               //读取ManDown开始时间通知开关
    mk_pb_taskReadNotifyEventOnManDownEndOperation,                 //读取ManDown结束时间通知开关
    mk_pb_taskReadMotorVibrationIntensityOperation,                 //读取马达震动强度
    mk_pb_taskReadAlarmTypeOperation,                               //读取报警类型
    mk_pb_taskReadExitAlarmTypeLongPressTimeOperation,              //读取退出报警按键触发时长
    mk_pb_taskReadNotifyEventOnSOSStartOperation,                   //读取SOS开始事件通知
    mk_pb_taskReadNotifyEventOnSOSEndOperation,                     //读取SOS结束事件通知
    mk_pb_taskReadSOSPositioningStrategyOperation,                  //读取SOS报警定位策略
    mk_pb_taskReadSOSReportIntervalOperation,                       //读取SOS报警定位数据上报间隔
    mk_pb_taskReadSOSTriggerModeOperation,                          //读取SOS报警触发方式
    mk_pb_taskReadNotifyEventOnAlertStartOperation,                   //读取Alert开始事件通知
    mk_pb_taskReadNotifyEventOnAlertEndOperation,                     //读取Alert结束事件通知
    mk_pb_taskReadAlertPositioningStrategyOperation,                  //读取Alert报警定位策略
    mk_pb_taskReadAlertTriggerModeOperation,                          //读取Alert报警触发方式
    
    
#pragma mark - 位置参数
    mk_pb_taskReadGpsPositioningTimeoutOperation,   //读取GPS定位超时时间
    mk_pb_taskReadPDOPOfGpsOperation,               //读取PDOP
    mk_pb_taskReadBlePositioningTimeoutOperation,   //读取蓝牙定位超时时间
    mk_pb_taskReadBlePositioningNumberOfMacOperation,   //读取蓝牙定位MAC数量
    mk_pb_taskReadRssiFilterValueOperation,         //读取RSSI过滤规则
    mk_pb_taskReadFilterRelationshipOperation,      //读取广播内容过滤逻辑
    mk_pb_taskReadFilterByMacPreciseMatchOperation, //读取精准过滤MAC开关
    mk_pb_taskReadFilterByMacReverseFilterOperation,    //读取反向过滤MAC开关
    mk_pb_taskReadFilterMACAddressListOperation,        //读取MAC过滤列表
    mk_pb_taskReadFilterByAdvNamePreciseMatchOperation, //读取精准过滤ADV Name开关
    mk_pb_taskReadFilterByAdvNameReverseFilterOperation,    //读取反向过滤ADV Name开关
    mk_pb_taskReadFilterAdvNameListOperation,           //读取ADV Name过滤列表
    mk_pb_taskReadFilterTypeStatusOperation,            //读取过滤设备类型开关
    mk_pb_taskReadFilterByBeaconStatusOperation,        //读取iBeacon类型过滤开关
    mk_pb_taskReadFilterByBeaconMajorRangeOperation,    //读取iBeacon类型Major范围
    mk_pb_taskReadFilterByBeaconMinorRangeOperation,    //读取iBeacon类型Minor范围
    mk_pb_taskReadFilterByBeaconUUIDOperation,          //读取iBeacon类型UUID
    mk_pb_taskReadFilterByMKBeaconStatusOperation,      //读取MKiBeacon类型过滤开关
    mk_pb_taskReadFilterByMKBeaconMajorRangeOperation,    //读取MKiBeacon类型Major范围
    mk_pb_taskReadFilterByMKBeaconMinorRangeOperation,    //读取MKiBeacon类型Minor范围
    mk_pb_taskReadFilterByMKBeaconUUIDOperation,          //读取MKiBeacon类型UUID
    mk_pb_taskReadFilterByMKBeaconAccStatusOperation,     //读取MKiBeacon&ACC类型过滤开关
    mk_pb_taskReadFilterByMKBeaconAccMajorRangeOperation,    //读取MKiBeacon&ACC类型Major范围
    mk_pb_taskReadFilterByMKBeaconAccMinorRangeOperation,    //读取MKiBeacon&ACC类型Minor范围
    mk_pb_taskReadFilterByMKBeaconAccUUIDOperation,          //读取MKiBeacon&ACC类型UUID
    mk_pb_taskReadFilterByUIDStatusOperation,                //读取UID类型过滤开关
    mk_pb_taskReadFilterByUIDNamespaceIDOperation,           //读取UID类型过滤的Namespace ID
    mk_pb_taskReadFilterByUIDInstanceIDOperation,            //读取UID类型过滤的Instance ID
    mk_pb_taskReadFilterByURLStatusOperation,               //读取URL类型过滤开关
    mk_pb_taskReadFilterByURLContentOperation,              //读取URL过滤的内容
    mk_pb_taskReadFilterByTLMStatusOperation,               //读取TLM过滤开关
    mk_pb_taskReadFilterByTLMVersionOperation,              //读取TLM过滤类型
    mk_pb_taskReadBXPAccFilterStatusOperation,          //读取BeaconX Pro-ACC设备过滤开关
    mk_pb_taskReadBXPTHFilterStatusOperation,           //读取BeaconX Pro-T&H设备过滤开关
    mk_pb_taskReadFilterByOtherStatusOperation,         //读取Other过滤条件开关
    mk_pb_taskReadFilterByOtherRelationshipOperation,   //读取Other过滤条件的逻辑关系
    mk_pb_taskReadFilterByOtherConditionsOperation,     //读取Other的过滤条件列表
    
#pragma mark - 设备LoRa参数读取
    mk_pb_taskReadLorawanRegionOperation,           //读取LoRaWAN频段
    mk_pb_taskReadLorawanModemOperation,            //读取LoRaWAN入网类型
    mk_pb_taskReadLorawanNetworkStatusOperation,    //读取LoRaWAN网络状态
    mk_pb_taskReadLorawanDEVEUIOperation,           //读取LoRaWAN DEVEUI
    mk_pb_taskReadLorawanAPPEUIOperation,           //读取LoRaWAN APPEUI
    mk_pb_taskReadLorawanAPPKEYOperation,           //读取LoRaWAN APPKEY
    mk_pb_taskReadLorawanDEVADDROperation,          //读取LoRaWAN DEVADDR
    mk_pb_taskReadLorawanAPPSKEYOperation,          //读取LoRaWAN APPSKEY
    mk_pb_taskReadLorawanNWKSKEYOperation,          //读取LoRaWAN NWKSKEY
    mk_pb_taskReadLorawanMessageTypeOperation,      //读取上行数据类型
    mk_pb_taskReadLorawanCHOperation,               //读取LoRaWAN CH
    mk_pb_taskReadLorawanDROperation,               //读取LoRaWAN DR
    mk_pb_taskReadLorawanUplinkStrategyOperation,   //读取LoRaWAN数据发送策略
    mk_pb_taskReadLorawanDutyCycleStatusOperation,  //读取dutycyle
    mk_pb_taskReadLorawanDevTimeSyncIntervalOperation,  //读取同步时间同步间隔
    mk_pb_taskReadLorawanNetworkCheckIntervalOperation, //读取网络确认间隔
    mk_pb_taskReadLorawanMaxRetransmissionTimesOperation,   //读取LoRaWAN重传次数
    mk_pb_taskReadLorawanADRACKLimitOperation,              //读取ADR_ACK_LIMIT
    mk_pb_taskReadLorawanADRACKDelayOperation,              //读取ADR_ACK_DELAY
    
#pragma mark - 设备控制参数配置
    mk_pb_taskPowerOffOperation,                        //关机
    mk_pb_taskRestartDeviceOperation,                   //配置设备重新入网
    mk_pb_taskFactoryResetOperation,                    //设备恢复出厂设置
    mk_pb_taskConfigTurnOffDeviceByButtonStatusOperation,   //配置按键关机
    mk_pb_taskConfigLowPowerPromptOperation,            //配置低电百分比
    mk_pb_taskConfigLowPowerPayloadOperation,           //配置低电状态数据上报开关
    mk_pb_taskConfigDeviceNameOperation,                //配置设备广播名称
    mk_pb_taskConfigAdvIntervalOperation,               //配置广播间隔
    mk_pb_taskConfigTxPowerOperation,                   //配置txPower
    mk_pb_taskConfigBroadcastTimeoutOperation,          //配置广播超时时长
    mk_pb_taskConfigNeedPasswordOperation,              //配置密码开关
    mk_pb_taskConfigPasswordOperation,                  //配置密码
    mk_pb_taskConfigTimeZoneOperation,                  //配置时区
    mk_pb_taskConfigDeviceTimeOperation,                //配置时间戳
    mk_pb_taskConfigThreeAxisWakeupThresholdOperation,  //配置三轴唤醒触发阈值
    mk_pb_taskConfigThreeAxisWakeupDurationOperation,   //配置三轴唤醒判断时间
    mk_pb_taskConfigThreeAxisMotionThresholdOperation,  //配置三轴运动触发阈值
    mk_pb_taskConfigThreeAxisMotionDurationOperation,   //配置三轴运动判断时间
    mk_pb_taskConfigMotionModeTripEndTimeoutOperation,      //配置运动结束判断时间
    
#pragma mark - 工作模式配置
    mk_pb_taskConfigShutDownPayloadStatusOperation,     //配置关机信息上报状态
    mk_pb_taskConfigWorkModeOperation,                  //配置工作模式
    mk_pb_taskConfigHeartbeatIntervalOperation,         //配置心跳包上报间隔
    mk_pb_taskConfigPeriodicModeReportIntervalOperation,            //配置定期模式下定位数据上报间隔
    mk_pb_taskConfigPeriodicModePositioningStrategyOperation,       //配置定期模式下定位策略
    mk_pb_taskConfigTimingModeReportingTimePointOperation,  //配置定时上报时间点
    mk_pb_taskConfigTimingModePositioningStrategyOperation, //配置定时模式下定位策略
    mk_pb_taskConfigMotionModeEventsOperation,                      //配置运动模式事件
    mk_pb_taskConfigMotionModePosStrategyOnStartOperation,          //配置运动开始定位策略
    mk_pb_taskConfigMotionModeNumberOfFixOnStartOperation,          //配置运动开始定位上报次数
    mk_pb_taskConfigMotionModePosStrategyInTripOperation,           //配置运动中定位策略
    mk_pb_taskConfigMotionModeReportIntervalInTripOperation,        //配置运动中定位间隔
    mk_pb_taskConfigMotionModePosStrategyOnEndOperation,            //配置运动结束定位策略
    mk_pb_taskConfigMotionModeNumberOfFixOnEndOperation,            //配置运动结束定位次数
    mk_pb_taskConfigMotionModeReportIntervalOnEndOperation,         //配置运动结束定位间隔
    
#pragma mark - 辅助功能参数配置
    mk_pb_taskConfigDownlinkPositioningStrategyOperation,           //配置下行定位请求定位策略
    mk_pb_taskConfigManDownDetectionOperation,                      //配置ManDown功能开关
    mk_pb_taskConfigManDownPositioningStrategyOperation,            //配置ManDown定位策略
    mk_pb_taskConfigManDownDetectionTimeoutOperation,               //配置ManDown检测超时时间
    mk_pb_taskConfigManDownReportIntervalOperation,                 //配置ManDown定位数据上报间隔
    mk_pb_taskConfigNotifyEventOnManDownStartOperation,             //配置ManDown开始事件通知开关
    mk_pb_taskConfigNotifyEventOnManDownEndOperation,               //配置ManDown结束事件通知开关
    mk_pb_taskConfigMotorVibrationIntensityOperation,               //配置马达震动强度
    mk_pb_taskConfigAlarmTypeOperation,                             //配置报警类型
    mk_pb_taskConfigExitAlarmTypeLongPressTimeOperation,            //配置退出报警按键触发时长
    mk_pb_taskConfigNotifyEventOnSOSStartOperation,                 //配置SOS开始事件通知
    mk_pb_taskConfigNotifyEventOnSOSEndOperation,                   //配置SOS结束事件通知
    mk_pb_taskConfigSOSPositioningStrategyOperation,                //配置SOS报警定位策略
    mk_pb_taskConfigSOSReportIntervalOperation,                     //配置SOS报警定位数据上报间隔
    mk_pb_taskConfigSOSTriggerModeOperation,                        //配置SOS报警触发方式
    mk_pb_taskConfigNotifyEventOnAlertStartOperation,                 //配置Alert开始事件通知
    mk_pb_taskConfigNotifyEventOnAlertEndOperation,                   //配置Alert结束事件通知
    mk_pb_taskConfigAlertPositioningStrategyOperation,                //配置Alert报警定位策略
    mk_pb_taskConfigAlertTriggerModeOperation,                        //配置Alert报警触发方式
    
#pragma mark - 定位参数配置
    mk_pb_taskConfigGpsPositioningTimeoutOperation,     //配置GPS定位超时时间
    mk_pb_taskConfigPDOPOfGpsOperation,                 //配置PDOP
    mk_pb_taskConfigBlePositioningTimeoutOperation,     //配置蓝牙定位超时时间
    mk_pb_taskConfigBlePositioningNumberOfMacOperation,     //配置蓝牙定位mac数量
    mk_pb_taskConfigRssiFilterValueOperation,           //配置rssi过滤规则
    mk_pb_taskConfigFilterRelationshipOperation,        //配置广播内容过滤逻辑
    mk_pb_taskConfigFilterByMacPreciseMatchOperation,   //配置精准过滤MAC开关
    mk_pb_taskConfigFilterByMacReverseFilterOperation,  //配置反向过滤MAC开关
    mk_pb_taskConfigFilterMACAddressListOperation,      //配置MAC过滤规则
    mk_pb_taskConfigFilterByAdvNamePreciseMatchOperation,   //配置精准过滤Adv Name开关
    mk_pb_taskConfigFilterByAdvNameReverseFilterOperation,  //配置反向过滤Adv Name开关
    mk_pb_taskConfigFilterAdvNameListOperation,             //配置Adv Name过滤规则
    mk_pb_taskConfigFilterByBeaconStatusOperation,          //配置iBeacon类型过滤开关
    mk_pb_taskConfigFilterByBeaconMajorOperation,           //配置iBeacon类型过滤的Major范围
    mk_pb_taskConfigFilterByBeaconMinorOperation,           //配置iBeacon类型过滤的Minor范围
    mk_pb_taskConfigFilterByBeaconUUIDOperation,            //配置iBeacon类型过滤的UUID
    mk_pb_taskConfigFilterByMKBeaconStatusOperation,          //配置MKiBeacon类型过滤开关
    mk_pb_taskConfigFilterByMKBeaconMajorOperation,           //配置MKiBeacon类型过滤的Major范围
    mk_pb_taskConfigFilterByMKBeaconMinorOperation,           //配置MKiBeacon类型过滤的Minor范围
    mk_pb_taskConfigFilterByMKBeaconUUIDOperation,            //配置MKiBeacon类型过滤的UUID
    mk_pb_taskConfigFilterByMKBeaconAccStatusOperation,          //配置MKiBeacon&ACC类型过滤开关
    mk_pb_taskConfigFilterByMKBeaconAccMajorOperation,           //配置iBeacon类型过滤的Major范围
    mk_pb_taskConfigFilterByMKBeaconAccMinorOperation,           //配置iBeacon类型过滤的Minor范围
    mk_pb_taskConfigFilterByMKBeaconAccUUIDOperation,            //配置iBeacon类型过滤的UUID
    mk_pb_taskConfigFilterByUIDStatusOperation,                 //配置UID类型过滤的开关状态
    mk_pb_taskConfigFilterByUIDNamespaceIDOperation,            //配置UID类型过滤的Namespace ID
    mk_pb_taskConfigFilterByUIDInstanceIDOperation,             //配置UID类型过滤的Instance ID
    mk_pb_taskConfigFilterByURLStatusOperation,                 //配置URL类型过滤的开关状态
    mk_pb_taskConfigFilterByURLContentOperation,                //配置URL类型过滤的内容
    mk_pb_taskConfigFilterByTLMStatusOperation,                 //配置TLM过滤开关
    mk_pb_taskConfigFilterByTLMVersionOperation,                //配置TLM过滤数据类型
    mk_pb_taskConfigBXPAccFilterStatusOperation,            //配置BeaconX Pro-ACC设备过滤开关
    mk_pb_taskConfigBXPTHFilterStatusOperation,             //配置BeaconX Pro-TH设备过滤开关
    mk_pb_taskConfigFilterByOtherStatusOperation,           //配置Other过滤关系开关
    mk_pb_taskConfigFilterByOtherRelationshipOperation,     //配置Other过滤条件逻辑关系
    mk_pb_taskConfigFilterByOtherConditionsOperation,       //配置Other过滤条件列表
    
#pragma mark - 设备LoRa参数配置
    mk_pb_taskConfigRegionOperation,                    //配置LoRaWAN的region
    mk_pb_taskConfigModemOperation,                     //配置LoRaWAN的入网类型
    mk_pb_taskConfigDEVEUIOperation,                    //配置LoRaWAN的devEUI
    mk_pb_taskConfigAPPEUIOperation,                    //配置LoRaWAN的appEUI
    mk_pb_taskConfigAPPKEYOperation,                    //配置LoRaWAN的appKey
    mk_pb_taskConfigDEVADDROperation,                   //配置LoRaWAN的DevAddr
    mk_pb_taskConfigAPPSKEYOperation,                   //配置LoRaWAN的APPSKEY
    mk_pb_taskConfigNWKSKEYOperation,                   //配置LoRaWAN的NwkSKey
    mk_pb_taskConfigMessageTypeOperation,               //配置LoRaWAN的message type
    mk_pb_taskConfigCHValueOperation,                   //配置LoRaWAN的CH值
    mk_pb_taskConfigDRValueOperation,                   //配置LoRaWAN的DR值
    mk_pb_taskConfigUplinkStrategyOperation,            //配置LoRaWAN数据发送策略
    mk_pb_taskConfigDutyCycleStatusOperation,           //配置LoRaWAN的duty cycle
    mk_pb_taskConfigTimeSyncIntervalOperation,          //配置LoRaWAN的同步指令间隔
    mk_pb_taskConfigNetworkCheckIntervalOperation,      //配置LoRaWAN的LinkCheckReq间隔
    mk_pb_taskConfigMaxRetransmissionTimesOperation,    //配置LoRaWAN的重传次数
    mk_pb_taskConfigLorawanADRACKLimitOperation,        //配置ADR_ACK_LIMIT
    mk_pb_taskConfigLorawanADRACKDelayOperation,        //配置ADR_ACK_DELAY
};
