//
//  MKPBFilterByRawDataController.m
//  MKLoRaWAN-PB_Example
//
//  Created by aa on 2022/3/18.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKPBFilterByRawDataController.h"
#import "MKFilterByRawDataController.h"
#import "MKPBFilterByRawDataModel.h"

@implementation MKPBFilterByRawDataController

- (instancetype)init {
    MKPBFilterByRawDataModel *model = [[MKPBFilterByRawDataModel alloc] init];
    self = [super initWithProtocol:model];
    return self;
}

@end
