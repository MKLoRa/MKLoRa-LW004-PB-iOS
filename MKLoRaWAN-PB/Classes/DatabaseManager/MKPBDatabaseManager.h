//
//  MKPBDatabaseManager.h
//  MKLoRaWAN-PB_Example
//
//  Created by aa on 2021/12/30.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKPBDatabaseManager : NSObject

/// 插入设备日志
/// @param logList 日志列表
/// @param macAddress 设备的mac地址，作为数据库前缀名字区分不同设备
/// @param sucBlock 成功回调
/// @param failedBlock 失败回调
+ (void)insertLogDatas:(NSArray <NSDictionary *>*)logList
            macAddress:(NSString *)macAddress
              sucBlock:(void (^)(void))sucBlock
           failedBlock:(void (^)(NSError *error))failedBlock;

+ (void)readLocalLogsWithMacAddress:(NSString *)macAddress
                           sucBlock:(void (^)(NSArray <NSDictionary *>*logList))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock;

+ (void)deleteDatasWithMacAddress:(NSString *)macAddress
                         sucBlock:(void (^)(void))sucBlock
                      failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
