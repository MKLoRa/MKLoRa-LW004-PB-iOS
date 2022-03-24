//
//  MKPBTaskAdopter.h
//  MKLoRaWAN-PB_Example
//
//  Created by aa on 2022/3/15.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString *const mk_pb_totalNumKey;
extern NSString *const mk_pb_totalIndexKey;
extern NSString *const mk_pb_contentKey;

@class CBCharacteristic;
@interface MKPBTaskAdopter : NSObject

+ (NSDictionary *)parseReadDataWithCharacteristic:(CBCharacteristic *)characteristic;

+ (NSDictionary *)parseWriteDataWithCharacteristic:(CBCharacteristic *)characteristic;

@end

NS_ASSUME_NONNULL_END
