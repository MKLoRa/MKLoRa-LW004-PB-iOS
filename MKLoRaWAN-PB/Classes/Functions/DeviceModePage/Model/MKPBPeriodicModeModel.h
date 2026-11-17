//
//  MKPBPeriodicModeModel.h
//  MKLoRaWAN-PB_Example
//
//  Created by aa on 2021/5/24.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MKLoRaPeriodicModePageProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKPBPeriodicModeModel : NSObject<MKLoRaPeriodicModePageProtocol>

@property (nonatomic, copy)NSArray<NSString *> *strategyDataList;
@property (nonatomic, copy)NSString *intervalPlaceholder;
@property (nonatomic, copy)NSString *intervalUnit;

@end

NS_ASSUME_NONNULL_END
