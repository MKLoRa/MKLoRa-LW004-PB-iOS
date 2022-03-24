//
//  MKPBDeviceSettingModel.h
//  MKLoRaWAN-PB_Example
//
//  Created by aa on 2022/3/15.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKPBDeviceSettingModel : NSObject

@property (nonatomic, assign)NSInteger timeZone;

/// 0:10%  1:20%   2:30%   3:40%   4:50%   5:60%
@property (nonatomic, assign)NSInteger lowPowerPrompt;

@property (nonatomic, assign)BOOL payload;

/// 0:No  1:Low  2:Medium  3:High
@property (nonatomic, assign)NSInteger vibrationIntensity;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;


@end

NS_ASSUME_NONNULL_END
