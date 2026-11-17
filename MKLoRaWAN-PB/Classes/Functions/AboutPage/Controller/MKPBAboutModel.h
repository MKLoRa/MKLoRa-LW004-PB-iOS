//
//  MKPBAboutModel.h
//  MKLoRaWAN-PB_Example
//
//  Created by aa on 2022/3/15.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MKLoRaAboutPageProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKPBAboutModel : NSObject <MKLoRaAboutPageProtocol>

@property (nonatomic, copy) NSString *appName;

@property (nonatomic, copy) NSString *firmwareLabel;

@end

NS_ASSUME_NONNULL_END
