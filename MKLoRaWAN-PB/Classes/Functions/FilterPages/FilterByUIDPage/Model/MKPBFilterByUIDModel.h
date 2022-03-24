//
//  MKPBFilterByUIDModel.h
//  MKLoRaWAN-PB_Example
//
//  Created by aa on 2021/11/30.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKPBFilterByUIDModel : NSObject

@property (nonatomic, assign)BOOL isOn;

@property (nonatomic, copy)NSString *namespaceID;

@property (nonatomic, copy)NSString *instanceID;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

- (void)configDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
