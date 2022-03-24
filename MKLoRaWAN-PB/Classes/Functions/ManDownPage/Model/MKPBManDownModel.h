//
//  MKPBManDownModel.h
//  MKLoRaWAN-PB_Example
//
//  Created by aa on 2022/3/22.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKPBManDownModel : NSObject

@property (nonatomic, assign)BOOL detection;

@property (nonatomic, copy)NSString *timeout;

/*
 0:BLE
 1:GPS
 2:GPS+BLE
 */
@property (nonatomic, assign)NSInteger strategy;

@property (nonatomic, copy)NSString *interval;

@property (nonatomic, assign)BOOL start;

@property (nonatomic, assign)BOOL end;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

- (void)configDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
