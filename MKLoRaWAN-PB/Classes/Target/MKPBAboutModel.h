//
//  MKPBAboutModel.h
//  MKLoRaWAN-PB_Example
//
//  Created by aa on 2022/3/15.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "MKLoRaAboutPageProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKPBAboutModel : NSObject <MKLoRaAboutPageProtocol>

@property (nonatomic, copy) NSString *appName;

@property (nonatomic, copy) NSString *appVersionLabel;

@property (nonatomic, copy) NSString *firmwareLabel;

@property (nonatomic, strong, nullable) UIImage *aboutIcon;

@property (nonatomic, strong, nullable) UIImage *bottomIcon;

@end

NS_ASSUME_NONNULL_END
