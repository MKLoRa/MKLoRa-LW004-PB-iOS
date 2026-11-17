//
//  MKPBMotionModeModel.h
//  MKLoRaWAN-PB_Example
//
//  Created by aa on 2021/5/24.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MKPBSDKNormalDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKPBMotionModeEventsModel : NSObject<mk_pb_motionModeEventsProtocol>

@property (nonatomic, assign)BOOL fixOnStart;

@property (nonatomic, assign)BOOL fixInTrip;

@property (nonatomic, assign)BOOL fixOnEnd;

@property (nonatomic, assign)BOOL notifyEventOnStart;

@property (nonatomic, assign)BOOL notifyEventInTrip;

@property (nonatomic, assign)BOOL notifyEventOnEnd;

@end

@interface MKPBMotionModeModel : NSObject

@property (nonatomic, assign)BOOL fixOnStart;

@property (nonatomic, copy)NSString *numberOfFixOnStart;

/*
 0:BLE
 1:GPS
 2:GPS+BLE
 */
@property (nonatomic, assign)NSInteger posStrategyOnStart;

@property (nonatomic, assign)BOOL fixInTrip;

@property (nonatomic, copy)NSString *reportIntervalInTrip;

/*
 0:BLE
 1:GPS
 2:GPS+BLE
 */
@property (nonatomic, assign)NSInteger posStrategyInTrip;

@property (nonatomic, assign)BOOL fixOnEnd;

@property (nonatomic, copy)NSString *tripEndTimeout;

@property (nonatomic, copy)NSString *numberOfFixOnEnd;

@property (nonatomic, copy)NSString *reportIntervalOnEnd;

/*
 0:BLE
 1:GPS
 2:GPS+BLE
 */
@property (nonatomic, assign)NSInteger posStrategyOnEnd;

@property (nonatomic, assign)BOOL notifyEventOnStart;

@property (nonatomic, assign)BOOL notifyEventInTrip;

@property (nonatomic, assign)BOOL notifyEventOnEnd;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

- (void)configDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@property (nonatomic, copy)NSArray<NSString *> *posStrategyDataList;
@property (nonatomic, copy)NSArray<NSString *> *posStrategyInTripDataList;
@property (nonatomic, assign)BOOL hideStationary;
@property (nonatomic, copy)NSString *fixCountOnStartPlaceholder;
@property (nonatomic, copy)NSString *tripEndTimeoutPlaceholder;
@property (nonatomic, copy)NSString *numberOfFixOnEndPlaceholder;

@end

NS_ASSUME_NONNULL_END
