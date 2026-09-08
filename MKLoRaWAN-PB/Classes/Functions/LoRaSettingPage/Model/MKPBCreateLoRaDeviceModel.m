//
//  MKPBCreateLoRaDeviceModel.m
//  MKLoRaWAN-PB_Example
//
//  Created by aa on 2026/9/8.
//  Copyright © 2026 aadyx2007@163.com. All rights reserved.
//

#import "MKPBCreateLoRaDeviceModel.h"

#import "MKMacroDefines.h"
#import "NSString+MKAdd.h"

@implementation MKPBCreateLoRaDeviceModel

- (NSString *)valid {
    self.macAddress = [self.macAddress stringByReplacingOccurrencesOfString:@":" withString:@""];
    if (![self.macAddress regularExpressions:isHexadecimal] || self.macAddress.length != 12) {
        return @"Mac error";
    }
    self.macAddress = [self.macAddress lowercaseString];
    if (ValidStr(self.gwId) && ![self.gwId regularExpressions:isHexadecimal] && self.gwId.length != 16) {
        return @"gwId error";
    }
    if (self.region < 0 || self.region > 5) {
        return @"Region error";
    }
    if (!ValidStr(self.username)) {
        return @"Username cannot be empty";
    }
    return @"";
}

- (NSDictionary *)params {
    NSString *valid = [self valid];
    if (ValidStr(valid)) {
        return @{
            @"error":valid
        };
    }
    NSString *devEui = [NSString stringWithFormat:@"%@%@%@",[self.macAddress substringToIndex:6],@"ffff",[self.macAddress substringFromIndex:6]];
    NSString *model = @"30";
    NSString *applicationIdFull = @"LW004_PB_V3";
    NSString *profilesType = @"004_PB_V3";
    NSString *devName = [NSString stringWithFormat:@"%@_%@",applicationIdFull,[[devEui substringFromIndex:(devEui.length - 4)] uppercaseString]];
    NSString *gwId = SafeStr([self.gwId lowercaseString]);
    NSString *gwName = @"";
    if (ValidStr(self.gwId)) {
        gwName = [NSString stringWithFormat:@"%@_%@",self.username,[[gwId substringFromIndex:(gwId.length - 4)] uppercaseString]];
    }
    NSString *joinEui = @"70b3d57ed0026b87";
    NSString *nwkKey = [@"2b7e151628aed2a6abf7" stringByAppendingFormat:self.macAddress];
    NSString *regionString = @"AS923";
    if (self.region == 1) {
        regionString = @"EU868";
    }else if (self.region == 2) {
        regionString = @"US915_0";
    }else if (self.region == 3) {
        regionString = @"US915_1";
    }else if (self.region == 4) {
        regionString = @"AU915_0";
    }else if (self.region == 5) {
        regionString = @"AU915_1";
    }
    NSString *devProfilesSearch = [NSString stringWithFormat:@"%@_%@",regionString,profilesType];
    
    return @{
        @"devEui":devEui,
        @"model":model,
        @"applicationIdFull":applicationIdFull,
        @"devName":devName,
        @"devDesc":self.username,
        @"gwId":gwId,
        @"gwName":gwName,
        @"gwSearch":gwName,
        @"gwDesc":gwName,
        @"joinEui":joinEui,
        @"nwkKey":nwkKey,
        @"devProfilesSearch":devProfilesSearch,
    };
}

@end
