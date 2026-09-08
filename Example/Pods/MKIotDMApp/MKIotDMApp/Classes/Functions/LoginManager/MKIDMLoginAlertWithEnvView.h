//
//  MKIDMLoginAlertWithEnvView.h
//  MKIotDMApp
//
//  Created by aa on 2026/7/8.
//  Copyright © 2026 lovexiaoxia. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKIDMLoginAlertWithEnvViewModel : NSObject

/// 默认Account
@property (nonatomic, copy) NSString *accountPlaceholder;
@property (nonatomic, copy) NSString *account;

/// 默认无限制
@property (nonatomic, assign) NSInteger accountMaxLen;

/// 默认Password
@property (nonatomic, copy) NSString *psdPlaceholder;
@property (nonatomic, copy) NSString *password;

/// 默认无限制
@property (nonatomic, assign) NSInteger passwordMaxLen;

/// 是否是正式环境，默认YES
@property (nonatomic, assign) BOOL isHome;

@end

@interface MKIDMLoginAlertWithEnvView : UIView

/// 显示弹窗
/// @param model 配置模型
/// @param completeBlock 完成回调（account, password, isHome）
- (void)showViewWithModel:(MKIDMLoginAlertWithEnvViewModel *)model
            completeBlock:(void(^)(NSString *account, NSString *password, BOOL isHome))completeBlock;

@end

NS_ASSUME_NONNULL_END
