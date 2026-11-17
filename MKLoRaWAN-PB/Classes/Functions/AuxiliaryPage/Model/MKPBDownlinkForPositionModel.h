//
//  MKPBDownlinkForPositionModel.h
//  MKLoRaWAN-PB_Example
//
//  Created by aa on 2022/3/22.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MKLoRaDownlinkPageProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKPBDownlinkForPositionModel : NSObject<MKLoRaDownlinkPageProtocol>

/*
 0:BLE
 1:GPS
 2:GPS+BLE
 */
@property (nonatomic, assign)NSInteger positioningStrategy;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

- (void)configDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;



@property (nonatomic, copy)NSArray<NSString *> *strategyDataList;

@end

NS_ASSUME_NONNULL_END
