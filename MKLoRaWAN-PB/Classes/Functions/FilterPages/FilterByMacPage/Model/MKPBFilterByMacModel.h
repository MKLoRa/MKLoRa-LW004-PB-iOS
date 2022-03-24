//
//  MKPBFilterByMacModel.h
//  MKLoRaWAN-PB_Example
//
//  Created by aa on 2022/3/17.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKPBFilterByMacModel : NSObject

@property (nonatomic, assign)BOOL match;

@property (nonatomic, assign)BOOL filter;

@property (nonatomic, strong)NSArray *macList;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

- (void)configDataWithMacList:(NSArray <NSString *>*)macList
                     sucBlock:(void (^)(void))sucBlock
                  failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
