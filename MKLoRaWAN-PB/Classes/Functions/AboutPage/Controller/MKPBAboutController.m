//
//  MKPBAboutController.m
//  MKLoRaWAN-PB_Example
//
//  Created by aa on 2022/3/15.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKPBAboutController.h"

#import "MKMacroDefines.h"

#import "MKPBAboutModel.h"

@implementation MKPBAboutController

- (instancetype)init {
    if (self = [super init]) {
        self.protocol = [[MKPBAboutModel alloc] init];
    }
    return self;
}

#pragma mark - Subclass Override

- (UIImage *)aboutIconImage {
    return LOADICON(@"MKLoRaWAN-PB", @"MKPBAboutController", @"pb_aboutIcon.png");
}

- (UIImage *)bottomIconImage {
    return LOADICON(@"MKLoRaWAN-PB", @"MKPBAboutController", @"pb_aboutBottomIcon.png");
}

@end
