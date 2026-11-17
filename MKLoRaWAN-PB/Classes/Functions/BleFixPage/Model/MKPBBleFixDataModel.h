//
//  MKPBBleFixDataModel.h
//  MKLoRaWAN-PB_Example
//
//  Created by aa on 2022/3/16.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MKPBFilterBleFixProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKPBBleFixDataModel : NSObject <MKPBFilterBleFixProtocol>

@property (nonatomic, copy) NSString *pageTitle;
@property (nonatomic, copy) NSString *saveIconName;

@property (nonatomic, copy) NSString *timeout;
@property (nonatomic, copy) NSString *number;

@property (nonatomic, assign) NSInteger priority;
@property (nonatomic, assign) NSInteger phy;

@property (nonatomic, assign) NSInteger rssi;
@property (nonatomic, assign) NSInteger relationship;

@end

NS_ASSUME_NONNULL_END
