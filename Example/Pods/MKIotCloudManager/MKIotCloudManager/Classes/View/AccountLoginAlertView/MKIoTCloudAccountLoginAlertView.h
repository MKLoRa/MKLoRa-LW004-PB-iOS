//
//  MKIoTCloudAccountLoginAlertView.h
//  MKIotCloudManager_Example
//
//  Created by aa on 2025/3/3.
//  Copyright © 2025 aadyx2007@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKIoTCloudAccountLoginAlertViewModel : NSObject

/// 默认Account
@property (nonatomic, copy)NSString *accountPlaceholder;

@property (nonatomic, copy)NSString *account;

/// 默认无限制
@property (nonatomic, assign)NSInteger accountMaxLen;

/// 默认Password
@property (nonatomic, copy)NSString *psdPlaceholder;

@property (nonatomic, copy)NSString *password;

/// 默认无限制
@property (nonatomic, assign)NSInteger passwordMaxLen;

/// 是否是正式环境，默认YES
@property (nonatomic, assign)BOOL isHome;

@end

@interface MKIoTCloudAccountLoginAlertView : UIView

/// 显示弹窗
/// - Parameters:
///   - model: MKIoTCloudAccountLoginAlertViewModel
///   - completeBlock: completeBlock
- (void)showViewWithModel:(MKIoTCloudAccountLoginAlertViewModel *)model
            completeBlock:(void(^)(NSString *account, NSString *password, BOOL isHome))completeBlock;

@end

NS_ASSUME_NONNULL_END
