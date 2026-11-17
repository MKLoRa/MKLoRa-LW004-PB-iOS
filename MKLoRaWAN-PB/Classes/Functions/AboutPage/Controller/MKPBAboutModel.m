//
//  MKPBAboutModel.m
//  MKLoRaWAN-PB_Example
//
//  Created by aa on 2022/3/15.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKPBAboutModel.h"

@implementation MKPBAboutModel

- (instancetype)init {
    if (self = [super init]) {
        self.appName = @"LW004-PB";
        self.firmwareLabel = @"FW Version:V3.1";
    }
    return self;
}

@end
