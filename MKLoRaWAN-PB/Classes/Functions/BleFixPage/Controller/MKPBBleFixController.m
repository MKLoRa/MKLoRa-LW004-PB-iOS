//
//  MKPBBleFixController.m
//  MKLoRaWAN-PB_Example
//
//  Created by aa on 2022/3/16.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKPBBleFixController.h"
#import "MKFilterBleFixController.h"
#import "MKPBBleFixDataModel.h"

@implementation MKPBBleFixController

- (instancetype)init {
    MKPBBleFixDataModel *model = [[MKPBBleFixDataModel alloc] init];
    self = [super initWithProtocol:model];
    return self;
}

@end
