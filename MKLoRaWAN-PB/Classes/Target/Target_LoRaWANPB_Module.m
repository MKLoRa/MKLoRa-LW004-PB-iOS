//
//  Target_LoRaWANPB_Module.m
//  MKLoRaWAN-PB_Example
//
//  Created by aa on 2021/12/22.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "Target_LoRaWANPB_Module.h"

#import "MKPBScanController.h"

#import "MKPBAboutController.h"

@implementation Target_LoRaWANPB_Module

/// 扫描页面
- (UIViewController *)Action_LoRaWANPB_Module_ScanController:(NSDictionary *)params {
    return [[MKPBScanController alloc] init];
}

/// 关于页面
- (UIViewController *)Action_LoRaWANPB_Module_AboutController:(NSDictionary *)params {
    return [[MKPBAboutController alloc] init];
}

@end
