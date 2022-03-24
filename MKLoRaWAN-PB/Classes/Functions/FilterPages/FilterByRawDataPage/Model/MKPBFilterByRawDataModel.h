//
//  MKPBFilterByRawDataModel.h
//  MKLoRaWAN-PB_Example
//
//  Created by aa on 2022/3/18.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKPBFilterByRawDataModel : NSObject

@property (nonatomic, assign)BOOL iBeacon;

@property (nonatomic, assign)BOOL uid;

@property (nonatomic, assign)BOOL url;

@property (nonatomic, assign)BOOL tlm;

@property (nonatomic, assign)BOOL mk_iBeacon;

@property (nonatomic, assign)BOOL mk_iBeaconAcc;

@property (nonatomic, assign)BOOL bxpAcc;

@property (nonatomic, assign)BOOL bxpTH;

@property (nonatomic, assign)BOOL other;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
