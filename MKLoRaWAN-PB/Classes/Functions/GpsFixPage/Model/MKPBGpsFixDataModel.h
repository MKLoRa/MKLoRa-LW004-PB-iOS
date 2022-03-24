//
//  MKPBGpsFixDataModel.h
//  MKLoRaWAN-PB_Example
//
//  Created by aa on 2022/3/21.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKPBGpsFixDataModel : NSObject

@property (nonatomic, copy)NSString *timeout;

@property (nonatomic, copy)NSString *pdop;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

- (void)configDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
