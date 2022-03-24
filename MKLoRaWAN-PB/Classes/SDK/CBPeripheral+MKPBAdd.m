//
//  CBPeripheral+MKPBAdd.m
//  MKLoRaWAN-PB_Example
//
//  Created by aa on 2022/3/15.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "CBPeripheral+MKPBAdd.h"

#import <objc/runtime.h>

static const char *pb_manufacturerKey = "pb_manufacturerKey";
static const char *pb_deviceModelKey = "pb_deviceModelKey";
static const char *pb_hardwareKey = "pb_hardwareKey";
static const char *pb_softwareKey = "pb_softwareKey";
static const char *pb_firmwareKey = "pb_firmwareKey";

static const char *pb_passwordKey = "pb_passwordKey";
static const char *pb_disconnectTypeKey = "pb_disconnectTypeKey";
static const char *pb_customKey = "pb_customKey";
static const char *pb_logKey = "pb_logKey";

static const char *pb_passwordNotifySuccessKey = "pb_passwordNotifySuccessKey";
static const char *pb_disconnectTypeNotifySuccessKey = "pb_disconnectTypeNotifySuccessKey";
static const char *pb_customNotifySuccessKey = "pb_customNotifySuccessKey";

@implementation CBPeripheral (MKPBAdd)

- (void)pb_updateCharacterWithService:(CBService *)service {
    NSArray *characteristicList = service.characteristics;
    if ([service.UUID isEqual:[CBUUID UUIDWithString:@"180A"]]) {
        //设备信息
        for (CBCharacteristic *characteristic in characteristicList) {
            if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A24"]]) {
                objc_setAssociatedObject(self, &pb_deviceModelKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A26"]]) {
                objc_setAssociatedObject(self, &pb_firmwareKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A27"]]) {
                objc_setAssociatedObject(self, &pb_hardwareKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A28"]]) {
                objc_setAssociatedObject(self, &pb_softwareKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A29"]]) {
                objc_setAssociatedObject(self, &pb_manufacturerKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
        }
        return;
    }
    if ([service.UUID isEqual:[CBUUID UUIDWithString:@"AA00"]]) {
        //自定义
        for (CBCharacteristic *characteristic in characteristicList) {
            if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA00"]]) {
                objc_setAssociatedObject(self, &pb_passwordKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                [self setNotifyValue:YES forCharacteristic:characteristic];
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA01"]]) {
                objc_setAssociatedObject(self, &pb_disconnectTypeKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                [self setNotifyValue:YES forCharacteristic:characteristic];
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA02"]]) {
                objc_setAssociatedObject(self, &pb_logKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA04"]]) {
                objc_setAssociatedObject(self, &pb_customKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                [self setNotifyValue:YES forCharacteristic:characteristic];
            }
        }
        return;
    }
}

- (void)pb_updateCurrentNotifySuccess:(CBCharacteristic *)characteristic {
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA00"]]) {
        objc_setAssociatedObject(self, &pb_passwordNotifySuccessKey, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return;
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA01"]]) {
        objc_setAssociatedObject(self, &pb_disconnectTypeNotifySuccessKey, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return;
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA04"]]) {
        objc_setAssociatedObject(self, &pb_customNotifySuccessKey, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return;
    }
}

- (BOOL)pb_connectSuccess {
    if (![objc_getAssociatedObject(self, &pb_customNotifySuccessKey) boolValue] || ![objc_getAssociatedObject(self, &pb_passwordNotifySuccessKey) boolValue] || ![objc_getAssociatedObject(self, &pb_disconnectTypeNotifySuccessKey) boolValue]) {
        return NO;
    }
    if (!self.pb_manufacturer || !self.pb_deviceModel || !self.pb_hardware || !self.pb_software || !self.pb_firmware) {
        return NO;
    }
    if (!self.pb_password || !self.pb_disconnectType || !self.pb_custom || !self.pb_log) {
        return NO;
    }
    return YES;
}

- (void)pb_setNil {
    objc_setAssociatedObject(self, &pb_manufacturerKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &pb_deviceModelKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &pb_hardwareKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &pb_softwareKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &pb_firmwareKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    objc_setAssociatedObject(self, &pb_passwordKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &pb_disconnectTypeKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &pb_customKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &pb_logKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    objc_setAssociatedObject(self, &pb_passwordNotifySuccessKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &pb_disconnectTypeNotifySuccessKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &pb_customNotifySuccessKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - getter

- (CBCharacteristic *)pb_manufacturer {
    return objc_getAssociatedObject(self, &pb_manufacturerKey);
}

- (CBCharacteristic *)pb_deviceModel {
    return objc_getAssociatedObject(self, &pb_deviceModelKey);
}

- (CBCharacteristic *)pb_hardware {
    return objc_getAssociatedObject(self, &pb_hardwareKey);
}

- (CBCharacteristic *)pb_software {
    return objc_getAssociatedObject(self, &pb_softwareKey);
}

- (CBCharacteristic *)pb_firmware {
    return objc_getAssociatedObject(self, &pb_firmwareKey);
}

- (CBCharacteristic *)pb_password {
    return objc_getAssociatedObject(self, &pb_passwordKey);
}

- (CBCharacteristic *)pb_disconnectType {
    return objc_getAssociatedObject(self, &pb_disconnectTypeKey);
}

- (CBCharacteristic *)pb_custom {
    return objc_getAssociatedObject(self, &pb_customKey);
}

- (CBCharacteristic *)pb_log {
    return objc_getAssociatedObject(self, &pb_logKey);
}

@end
