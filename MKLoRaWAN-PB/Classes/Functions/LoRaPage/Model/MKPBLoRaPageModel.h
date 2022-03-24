//
//  MKPBLoRaPageModel.h
//  MKLoRaWAN-PB_Example
//
//  Created by aa on 2022/3/15.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKPBLoRaPageModel : NSObject

@property (nonatomic, copy)NSString *modem;

@property (nonatomic, copy)NSString *region;

@property (nonatomic, copy)NSString *classType;

/// 网络连接状态
@property (nonatomic, copy)NSString *networkStatus;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
