//
//  CBPeripheral+MKPBAdd.h
//  MKLoRaWAN-PB_Example
//
//  Created by aa on 2022/3/15.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>

NS_ASSUME_NONNULL_BEGIN

@interface CBPeripheral (MKPBAdd)

/// R
@property (nonatomic, strong, readonly)CBCharacteristic *pb_manufacturer;

/// R
@property (nonatomic, strong, readonly)CBCharacteristic *pb_deviceModel;

/// R
@property (nonatomic, strong, readonly)CBCharacteristic *pb_hardware;

/// R
@property (nonatomic, strong, readonly)CBCharacteristic *pb_software;

/// R
@property (nonatomic, strong, readonly)CBCharacteristic *pb_firmware;

#pragma mark - custom

/// W/N
@property (nonatomic, strong, readonly)CBCharacteristic *pb_password;

/// N
@property (nonatomic, strong, readonly)CBCharacteristic *pb_disconnectType;

/// N
@property (nonatomic, strong, readonly)CBCharacteristic *pb_log;

/// W/N
@property (nonatomic, strong, readonly)CBCharacteristic *pb_custom;

- (void)pb_updateCharacterWithService:(CBService *)service;

- (void)pb_updateCurrentNotifySuccess:(CBCharacteristic *)characteristic;

- (BOOL)pb_connectSuccess;

- (void)pb_setNil;

@end

NS_ASSUME_NONNULL_END
