//
//  MKPBFilterByRawDataModel.h
//  MKLoRaWAN-PB_Example
//
//  Created by aa on 2022/3/18.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MKFilterByRawDataProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKPBFilterByRawDataModel : NSObject <MKFilterByRawDataProtocol>

@property (nonatomic, copy) NSString *pageTitle;

// section0
@property (nonatomic, assign) BOOL iBeacon;
@property (nonatomic, assign) BOOL uid;
@property (nonatomic, assign) BOOL url;
@property (nonatomic, assign) BOOL tlm;
@property (nonatomic, assign) BOOL bxpBeacon;

// section1
@property (nonatomic, assign) BOOL bxpDeviceInfo;  // PB 硬件不支持，固定 NO
@property (nonatomic, assign) BOOL bxpAcc;
@property (nonatomic, assign) BOOL bxpTH;

// section2
@property (nonatomic, assign) BOOL bxpButton;  // PB 硬件不支持，固定 NO
@property (nonatomic, assign) BOOL bxpTag;     // PB 硬件不支持，固定 NO
@property (nonatomic, assign) BOOL pir;        // PB 硬件不支持，固定 NO
@property (nonatomic, assign) BOOL tof;        // PB 硬件不支持，固定 NO
@property (nonatomic, assign) BOOL nanoBeacon; // PB 硬件不支持，固定 NO
@property (nonatomic, assign) BOOL other;

@end

NS_ASSUME_NONNULL_END
