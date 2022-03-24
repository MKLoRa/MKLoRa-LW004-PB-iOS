//
//  MKPBFilterByTLMModel.h
//  MKLoRaWAN-PB_Example
//
//  Created by aa on 2021/11/30.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKPBFilterByTLMModel : NSObject

@property (nonatomic, assign)BOOL isOn;

/// 0:过滤所有TLM  1:过滤非加密类型TLM 2:过滤加密类型TLM
@property (nonatomic, assign)NSInteger tlm;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

- (void)configDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
