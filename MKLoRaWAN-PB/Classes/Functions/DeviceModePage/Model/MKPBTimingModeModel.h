//
//  MKPBTimingModeModel.h
//  MKLoRaWAN-PB_Example
//
//  Created by aa on 2021/5/24.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MKPBSDKNormalDefines.h"
#import "MKLoRaTimingModePageProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKPBTimingModeTimePointModel : MKLoRaTimingModeTimePointModel<mk_pb_timingModeReportingTimePointProtocol>

@end

@interface MKPBTimingModeModel : NSObject<MKLoRaTimingModePageProtocol>

/*
 0:BLE
 1:GPS
 2:GPS+BLE
 */
@property (nonatomic, assign)NSInteger strategy;

@property (nonatomic, strong)NSArray <MKLoRaTimingModeTimePointModel *>*pointList;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

- (void)configDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

- (void)configData:(NSArray <MKLoRaTimingModeTimePointModel *>*)pointList
          sucBlock:(void (^)(void))sucBlock
       failedBlock:(void (^)(NSError *error))failedBlock;



@property (nonatomic, assign)NSInteger maxPointList;

@property (nonatomic, copy)NSArray<NSString *> *strategyDataList;

@end

NS_ASSUME_NONNULL_END
