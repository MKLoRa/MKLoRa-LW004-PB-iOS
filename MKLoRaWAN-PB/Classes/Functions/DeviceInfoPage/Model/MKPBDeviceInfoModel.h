//
//  MKPBDeviceInfoModel.h
//  MKLoRaWAN-PB_Example
//
//  Created by aa on 2021/5/27.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MKLoRaDeviceInfoPageProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKPBDeviceInfoModel : NSObject<MKLoRaDeviceInfoPageProtocol>

/**
 软件版本
 */
@property (nonatomic, copy)NSString *software;

/**
 固件版本
 */
@property (nonatomic, copy)NSString *firmware;

/**
 硬件版本
 */
@property (nonatomic, copy)NSString *hardware;

/**
 电池电压，单位mV
 */
@property (nonatomic, copy)NSString *voltage;

/**
 mac地址
 */
@property (nonatomic, copy)NSString *macAddress;

/**
 产品型号
 */
@property (nonatomic, copy)NSString *productMode;

/**
 厂商信息
 */
@property (nonatomic, copy)NSString *manu;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
