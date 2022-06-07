//
//  MKPBSelftestModel.h
//  MKLoRaWAN-PB_Example
//
//  Created by aa on 2022/5/26.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKPBSelftestModel : NSObject

@property (nonatomic, copy)NSString *bit0;

@property (nonatomic, copy)NSString *bit1;

@property (nonatomic, copy)NSString *pcbaStatus;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;;

@end

NS_ASSUME_NONNULL_END
