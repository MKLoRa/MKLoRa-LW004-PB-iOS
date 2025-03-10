//
//  MKIoTCloudExitAccountAlert.h
//  MKIotCloudManager_Example
//
//  Created by aa on 2025/3/4.
//  Copyright © 2025 aadyx2007@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKIoTCloudExitAccountAlert : UIView

/// 显示弹窗
/// - Parameters:
///   - account: account
///   - completeBlock: completeBlock
- (void)showWithAccount:(NSString *)account completeBlock:(void(^)(void))completeBlock;

@end

NS_ASSUME_NONNULL_END
