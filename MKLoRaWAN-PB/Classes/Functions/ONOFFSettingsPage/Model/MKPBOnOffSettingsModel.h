//
//  MKPBOnOffSettingsModel.h
//  MKLoRaWAN-PB_Example
//
//  Created by aa on 2022/3/24.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKPBOnOffSettingsModel : NSObject

@property (nonatomic, assign)BOOL payload;

@property (nonatomic, assign)BOOL button;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
