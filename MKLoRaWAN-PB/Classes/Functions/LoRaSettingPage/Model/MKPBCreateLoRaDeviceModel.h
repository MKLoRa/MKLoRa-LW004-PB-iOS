//
//  MKPBCreateLoRaDeviceModel.h
//  MKLoRaWAN-PB_Example
//
//  Created by aa on 2026/9/8.
//  Copyright © 2026 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKPBCreateLoRaDeviceModel : NSObject

@property (nonatomic, copy)NSString *macAddress;

/// 是否是正式环境
@property (nonatomic, assign)BOOL isHome;

/// 网关ID，空或者八个字节
@property (nonatomic, copy)NSString *gwId;

/*
 0:AS923
 1:EU868
 2:US915-0
 3:US915-1
 4:AU915-0
 5:AU915-1
 */
@property (nonatomic, assign)NSInteger region;

/// 登录用户名
@property (nonatomic, copy)NSString *username;

- (NSDictionary *)params;

@end

NS_ASSUME_NONNULL_END
