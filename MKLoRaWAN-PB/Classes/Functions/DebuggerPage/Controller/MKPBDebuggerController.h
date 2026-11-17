//
//  MKPBDebuggerController.h
//  MKLoRaWAN-PB_Example
//
//  Created by aa on 2023/7/5.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKLoRaDebuggerController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKPBDebuggerController : MKLoRaDebuggerController

/// 兼容原有调用方式：设备信息页 push 前赋值，实际数据由 Model 提供给基础库
@property (nonatomic, copy)NSString *macAddress;

@end

NS_ASSUME_NONNULL_END
