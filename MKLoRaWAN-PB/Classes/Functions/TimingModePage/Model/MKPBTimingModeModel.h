//
//  MKPBTimingModeModel.h
//  MKLoRaWAN-PB_Example
//
//  Created by aa on 2021/5/24.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MKPBSDKNormalDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKPBTimingModeTimePointModel : NSObject<mk_pb_timingModeReportingTimePointProtocol>

/// 0~23
@property (nonatomic, assign)NSInteger hour;

/// 0:00   1:15   2:30   3:45
@property (nonatomic, assign)NSInteger minuteGear;

@end

@interface MKPBTimingModeModel : NSObject

/*
 0:BLE
 1:GPS
 2:GPS+BLE
 */
@property (nonatomic, assign)NSInteger strategy;

@property (nonatomic, strong)NSArray <MKPBTimingModeTimePointModel *>*pointList;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

- (void)configData:(NSArray <MKPBTimingModeTimePointModel *>*)pointList
          sucBlock:(void (^)(void))sucBlock
       failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
