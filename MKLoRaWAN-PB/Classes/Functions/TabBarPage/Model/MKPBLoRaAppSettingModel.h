//
//  MKPBLoRaAppSettingModel.h
//  MKLoRaWAN-PB_Example
//
//  Created by aa on 2022/3/16.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MKLoRaApplicationPageProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKPBLoRaAppSettingModel : NSObject<MKLoRaApplicationPageProtocol>

@property (nonatomic, copy)NSString *timeSyncInterval;

@property (nonatomic, copy)NSString *checkInterval;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

- (void)configDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;


@property (nonatomic, assign)BOOL hideMessageType;
@property (nonatomic, copy)NSString *checkIntervalTitle;

@end

NS_ASSUME_NONNULL_END
