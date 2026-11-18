//
//  MKPBLoRaController.m
//  MKLoRaWAN-PB_Example
//
//  Created by aa on 2022/3/15.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKPBLoRaController.h"

#import "MKPBLoRaPageModel.h"
#import "MKLoRaApplicationController.h"

#import "MKPBLoRaAppSettingModel.h"
#import "MKLoRaFullSettingController.h"
#import "MKPBLoRaSettingModel.h"

@implementation MKPBLoRaController

- (instancetype)init {
    if (self = [super init]) {
        self.protocol = [[MKPBLoRaPageModel alloc] init];
    }
    return self;
}

#pragma mark - super method

- (void)leftButtonMethod {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"mk_pb_popToRootViewControllerNotification" object:nil];
}

#pragma mark - Subclass Override

- (void)pushToLoRaSettingPage {
    MKLoRaFullSettingController *vc = [[MKLoRaFullSettingController alloc] initWithProtocol:[[MKPBLoRaSettingModel alloc] init]];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pushToLoRaApplicationPage {
    MKLoRaApplicationController *vc = [[MKLoRaApplicationController alloc] init];
    vc.protocol = [[MKPBLoRaAppSettingModel alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
