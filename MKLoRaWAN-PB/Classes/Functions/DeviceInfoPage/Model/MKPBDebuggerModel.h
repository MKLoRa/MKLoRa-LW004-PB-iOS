//
//  MKPBDebuggerModel.h
//  MKLoRaWAN-PB_Example
//
//  Created by aa on 2023/7/5.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MKLoRaDebuggerPageProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKPBDebuggerModel : NSObject<MKLoRaDebuggerPageProtocol>

/// 设备mac地址，由控制器赋值
@property (nonatomic, copy)NSString *macAddress;

/// 设备连接状态，由CentralManager实时提供
@property (nonatomic, assign)BOOL isDeviceConnected;

@end

NS_ASSUME_NONNULL_END
