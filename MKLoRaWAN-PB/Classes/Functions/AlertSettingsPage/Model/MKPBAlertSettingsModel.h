//
//  MKPBAlertSettingsModel.h
//  MKLoRaWAN-PB_Example
//
//  Created by aa on 2022/3/22.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKPBAlertSettingsModel : NSObject

/*
 0:Single Click
 1:Double Click
 2:Long Press 1s
 3:Long Press 2s
 4:Long Press 3s
 5:Long Press 4s
 6:Long Press 5s
 */
@property (nonatomic, assign)NSInteger triggerMode;

/*
 0:BLE
 1:GPS
 2:BLE&GPS
 */
@property (nonatomic, assign)NSInteger strategy;

@property (nonatomic, assign)BOOL start;

@property (nonatomic, assign)BOOL end;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

- (void)configDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
