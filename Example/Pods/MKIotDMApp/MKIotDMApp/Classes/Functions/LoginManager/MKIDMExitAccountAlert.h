//
//  MKIDMExitAccountAlert.h
//  MKIotDMApp
//
//  Created by aa on 2026/7/8.
//  Copyright © 2026 lovexiaoxia. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKIDMExitAccountAlert : UIView

/// 显示退出账号确认弹窗
/// @param account 当前登录的账号
/// @param completion 确认退出后的回调
- (void)showWithAccount:(NSString *)account
         completeBlock:(void(^)(void))completion;

@end

NS_ASSUME_NONNULL_END
