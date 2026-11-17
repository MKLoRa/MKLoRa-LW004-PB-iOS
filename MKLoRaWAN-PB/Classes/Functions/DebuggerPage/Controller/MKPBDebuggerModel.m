//
//  MKPBDebuggerModel.m
//  MKLoRaWAN-PB_Example
//
//  Created by aa on 2023/7/5.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKPBDebuggerModel.h"

#import "MKPBCentralManager.h"
#import "MKPBDatabaseManager.h"

@interface MKPBDebuggerModel ()<mk_pb_centralManagerLogDelegate>

@property (nonatomic, copy)void (^logBlock)(NSString *log);

@end

@implementation MKPBDebuggerModel

#pragma mark - MKLoRaDebuggerPageProtocol
- (void)fetchLogDataWithSucBlock:(void (^)(NSArray<NSDictionary *> * _Nonnull))sucBlock
                     failedBlock:(void (^)(NSError * _Nonnull))failedBlock {
    [MKPBDatabaseManager readLocalLogsWithMacAddress:self.macAddress
                                            sucBlock:sucBlock
                                         failedBlock:failedBlock];
}

- (void)deleteAllLogsWithSucBlock:(void (^)(void))sucBlock
                      failedBlock:(void (^)(NSError * _Nonnull))failedBlock {
    [MKPBDatabaseManager deleteDatasWithMacAddress:self.macAddress
                                          sucBlock:sucBlock
                                       failedBlock:failedBlock];
}

- (void)insertLogDatas:(NSArray<NSDictionary *> *)logList
            macAddress:(NSString *)macAddress
             sucBlock:(void (^)(void))sucBlock
          failedBlock:(void (^)(NSError * _Nonnull))failedBlock {
    [MKPBDatabaseManager insertLogDatas:logList
                             macAddress:macAddress
                               sucBlock:sucBlock
                            failedBlock:failedBlock];
}

- (void)startDebuggerModeWithLogBlock:(void (^)(NSString * _Nonnull))logBlock {
    self.logBlock = logBlock;
    [MKPBCentralManager shared].logDelegate = self;
    [[MKPBCentralManager shared] notifyLogData:YES];
}

- (void)stopDebuggerMode {
    self.logBlock = nil;
    [[MKPBCentralManager shared] notifyLogData:NO];
}

#pragma mark - mk_pb_centralManagerLogDelegate
- (void)mk_pb_receiveLog:(NSString *)deviceLog {
    if (!self.logBlock || deviceLog.length == 0) {
        return;
    }
    self.logBlock(deviceLog);
}

#pragma mark - getter
- (BOOL)isDeviceConnected {
    return ([MKPBCentralManager shared].connectStatus == mk_pb_centralConnectStatusConnected);
}

@end
