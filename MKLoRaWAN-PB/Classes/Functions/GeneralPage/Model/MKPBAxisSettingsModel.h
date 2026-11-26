//
//  MKPBAxisSettingsModel.h
//  MKLoRaWAN-PB_Example
//
//  Created by aa on 2022/3/23.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MKLoRaAxisSettingPageProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKPBAxisSettingsModel : NSObject<MKLoRaAxisSettingPageProtocol>

/// Motion Wakeup Threshold
@property (nonatomic, copy)NSString *wakeupThreshold;

/// Motion Wakeup Duration
@property (nonatomic, copy)NSString *wakeupDuration;

/// Motion Threshold
@property (nonatomic, copy)NSString *motionThreshold;

/// Motion Duration
@property (nonatomic, copy)NSString *motionDuration;

- (void)readWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

- (void)configWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
