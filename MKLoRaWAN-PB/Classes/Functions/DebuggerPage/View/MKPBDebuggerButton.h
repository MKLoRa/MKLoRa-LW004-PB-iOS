//
//  MKPBDebuggerButton.h
//  MKLoRaWAN-PB_Example
//
//  Created by aa on 2021/12/29.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKPBDebuggerButton : UIControl

@property (nonatomic, strong, readonly)UIImageView *topIcon;

@property (nonatomic, strong, readonly)UILabel *msgLabel;

@end

NS_ASSUME_NONNULL_END
