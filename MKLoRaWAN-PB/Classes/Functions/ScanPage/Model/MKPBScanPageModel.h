//
//  MKPBScanPageModel.h
//  MKLoRaWAN-PB_Example
//
//  Created by aa on 2022/3/15.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class CBPeripheral;
@interface MKPBScanPageModel : NSObject

/**
 当前model所在的row
 */
@property (nonatomic, assign)NSInteger index;

@property (nonatomic, assign)NSInteger rssi;

@property (nonatomic, strong)CBPeripheral *peripheral;

@property (nonatomic, copy)NSString *deviceName;

@property (nonatomic, copy)NSString *macAddress;

/// 电压，v
@property (nonatomic, copy)NSString *voltage;

/// 电池电量，%
@property (nonatomic, copy)NSString *battery;

/// 是否需要密码连接
@property (nonatomic, assign)BOOL needPassword;

/// 是否可连接
@property (nonatomic, assign)BOOL connectable;

@property (nonatomic, strong)NSNumber *txPower;

/// cell上面显示的时间
@property (nonatomic, copy)NSString *scanTime;

/**
 上一次扫描到的时间
 */
@property (nonatomic, copy)NSString *lastScanDate;

@end

NS_ASSUME_NONNULL_END
