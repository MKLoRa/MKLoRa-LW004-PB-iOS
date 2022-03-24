//
//  MKPBFilterByAdvNameModel.h
//  MKLoRaWAN-PB_Example
//
//  Created by aa on 2022/3/17.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKPBFilterByAdvNameModel : NSObject

@property (nonatomic, assign)BOOL match;

@property (nonatomic, assign)BOOL filter;

@property (nonatomic, strong)NSArray *nameList;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

- (void)configDataWithNameList:(NSArray <NSString *>*)nameList
                      sucBlock:(void (^)(void))sucBlock
                   failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
