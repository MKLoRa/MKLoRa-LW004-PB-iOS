//
//  MKPBCentralManager.h
//  MKLoRaWAN-PB_Example
//
//  Created by aa on 2022/3/15.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MKBaseBleModule/MKBLEBaseDataProtocol.h>

#import "MKPBOperationID.h"
#import "MKPBSDKNormalDefines.h"

NS_ASSUME_NONNULL_BEGIN

//Notification of device connection status changes.
extern NSString *const mk_pb_peripheralConnectStateChangedNotification;

//Notification of changes in the status of the Bluetooth Center.
extern NSString *const mk_pb_centralManagerStateChangedNotification;

/*
 After connecting the device, if no password is entered within one minute, it returns 0x01. After successful password change, it returns 0x03, the device has no data communication for three consecutive minutes, it returns 0x02, and the shutdown protocol is sent to make the device shut down and return 0x04.Reset the device, return 0x05.
 */
extern NSString *const mk_pb_deviceDisconnectTypeNotification;

@class CBCentralManager,CBPeripheral;
@class MKPBOperation;

@interface MKPBCentralManager : NSObject<MKBLEBaseCentralManagerProtocol>

@property (nonatomic, weak)id <mk_pb_centralManagerScanDelegate>delegate;

@property (nonatomic, weak)id <mk_pb_centralManagerLogDelegate>logDelegate;

/// Current connection status
@property (nonatomic, assign, readonly)mk_pb_centralConnectStatus connectStatus;

+ (MKPBCentralManager *)shared;

/// Destroy the MKPBCentralManager singleton and the MKBLEBaseCentralManager singleton. After the dfu upgrade, you need to destroy these two and then reinitialize.
+ (void)sharedDealloc;

/// Destroy the MKPBCentralManager singleton and remove the manager list of MKBLEBaseCentralManager.
+ (void)removeFromCentralList;

- (nonnull CBCentralManager *)centralManager;

/// Currently connected devices
- (nullable CBPeripheral *)peripheral;

/// Current Bluetooth center status
- (mk_pb_centralManagerStatus )centralStatus;

/// Bluetooth Center starts scanning
- (void)startScan;

/// Bluetooth center stops scanning
- (void)stopScan;

/// Connect device function.
/// @param peripheral peripheral
/// @param password Device connection password,8 characters long ascii code
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
- (void)connectPeripheral:(nonnull CBPeripheral *)peripheral
                 password:(nonnull NSString *)password
                 sucBlock:(void (^)(CBPeripheral *peripheral))sucBlock
              failedBlock:(void (^)(NSError *error))failedBlock;

/// Connect device function.
/// @param peripheral peripheral
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
- (void)connectPeripheral:(nonnull CBPeripheral *)peripheral
                 sucBlock:(void (^)(CBPeripheral *peripheral))sucBlock
              failedBlock:(void (^)(NSError *error))failedBlock;

- (void)disconnect;

/// Start a task for data communication with the device
/// @param operationID operation id
/// @param characteristic characteristic for communication
/// @param commandData Data to be sent to the device for this communication
/// @param successBlock Successful callback
/// @param failureBlock Failure callback
- (void)addTaskWithTaskID:(mk_pb_taskOperationID)operationID
           characteristic:(CBCharacteristic *)characteristic
              commandData:(NSString *)commandData
             successBlock:(void (^)(id returnData))successBlock
             failureBlock:(void (^)(NSError *error))failureBlock;

/// Start a task to read device characteristic data
/// @param operationID operation id
/// @param characteristic characteristic for communication
/// @param successBlock Successful callback
/// @param failureBlock Failure callback
- (void)addReadTaskWithTaskID:(mk_pb_taskOperationID)operationID
               characteristic:(CBCharacteristic *)characteristic
                 successBlock:(void (^)(id returnData))successBlock
                 failureBlock:(void (^)(NSError *error))failureBlock;

- (void)addOperation:(MKPBOperation *)operation;

/// Whether to open log data monitoring.
/// @param notify notify
- (BOOL)notifyLogData:(BOOL)notify;

@end

NS_ASSUME_NONNULL_END
