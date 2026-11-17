//
//  MKPBDebuggerController.m
//  MKLoRaWAN-PB_Example
//
//  Created by aa on 2023/7/5.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKPBDebuggerController.h"

#import "MKPBDebuggerModel.h"

#import "MKPBCentralManager.h"

/// 基础库 Debugger 控制器内部方法，设备断开时由子类转发本模块连接状态通知
@interface MKLoRaDebuggerController (MKPBSubclassAccess)

- (void)deviceDisconnect;

@end

@implementation MKPBDebuggerController

- (instancetype)init {
    if (self = [super init]) {
        self.protocol = [[MKPBDebuggerModel alloc] init];
    }
    return self;
}

- (void)dealloc {
    //通知本模块的TabBar退出Debugger模式
    [[NSNotificationCenter defaultCenter] postNotificationName:@"mk_pb_stopDebuggerMode" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //通知本模块的TabBar进入Debugger模式
    [[NSNotificationCenter defaultCenter] postNotificationName:@"mk_pb_startDebuggerMode" object:nil];
    //基础库监听的是公共模块的连接状态通知，这里补充本模块的连接状态通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deviceDisconnect)
                                                 name:mk_pb_peripheralConnectStateChangedNotification
                                               object:nil];
}

#pragma mark - super method
- (void)leftButtonMethod {
    if (!self.protocol.isDeviceConnected) {
        //当前设备已经断开连接，则返回扫描页面
        [[NSNotificationCenter defaultCenter] postNotificationName:@"mk_pb_popToRootViewControllerNotification" object:nil];
        return;
    }
    [super leftButtonMethod];
}

#pragma mark - getter
- (NSString *)macAddress {
    return self.protocol.macAddress;
}

- (void)setMacAddress:(NSString *)macAddress {
    [(MKPBDebuggerModel *)self.protocol setMacAddress:macAddress];
}

@end
