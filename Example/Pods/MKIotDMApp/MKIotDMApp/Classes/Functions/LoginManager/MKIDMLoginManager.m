//
//  MKIDMLoginManager.m
//  MKIotDMApp_Example
//
//  Created by aa on 2026/7/8.
//  Copyright © 2026 lovexiaoxia. All rights reserved.
//

#import "MKIDMLoginManager.h"

#import <objc/message.h>

#import "UIViewController+HHTransition.h"

#import "MKIDMUserManager.h"
#import "MKIDMAccountService.h"
#import "MKIDMEnvironmentManager.h"
#import "MKIDMNetWorkRequest.h"

#import "MKIDMLoginAlertWithEnvView.h"
#import "MKIDMExitAccountAlert.h"
// MKIDMLoginAlertView 不在 LoginManager 子规格中（依赖 MainTabBar）
// 通过 NSClassFromString 动态调用，避免编译依赖

#import "MKMacroDefines.h"
#import "MKHudManager.h"
#import "UIView+MKAdd.h"

static MKIDMLoginManager *instance = nil;
static dispatch_once_t onceToken;

@interface MKIDMLoginManager ()

@property (nonatomic, weak) UIViewController *presentingVC;
@property (nonatomic, copy) void (^completion)(void);
@property (nonatomic, assign) BOOL navigateToTabBar;

@end

@implementation MKIDMLoginManager

+ (instancetype)sharedManager {
    dispatch_once(&onceToken, ^{
        instance = [[MKIDMLoginManager alloc] init];
    });
    return instance;
}

+ (void)singleDealloc {
    [MKIDMUserManager singleDealloc];
    [MKIDMNetWorkRequest singleDealloc];
    [MKIDMEnvironmentManager singleDealloc];
    
    onceToken = 0;
    instance = nil;
}

- (BOOL)isLoggedIn {
    return [MKIDMUserManager sharedManager].isLoggedIn;
}

- (NSDictionary *)userInfo {
    MKIDMUserModel *currentUser = [MKIDMUserManager sharedManager].currentUser;
    if (!currentUser) {
        return @{};
    }
    
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    info[@"userId"] = @(currentUser.userId);
    info[@"username"] = currentUser.username ?: @"";
    info[@"email"] = currentUser.email ?: @"";
    info[@"accessToken"] = currentUser.accessToken ?: @"";
    info[@"permissions"] = currentUser.permissions ?: @[];
    info[@"permissionPsd"] = @(currentUser.permissionPsd);
    info[@"createTime"] = currentUser.createTime ?: @"";
    
    return [info copy];
}

- (NSString *)baseURL {
    return [MKIDMEnvironmentManager sharedManager].baseURL;
}

- (void)logout {
    [[MKIDMUserManager sharedManager] logout];
}

#pragma mark - Public Methods - Login

- (void)showLoginFromViewController:(UIViewController *)presentingVC
                         completion:(nullable void(^)(void))completion {
    [self showLoginFromViewController:presentingVC navigateToTabBar:NO completion:completion];
}

- (void)showLoginFromViewController:(UIViewController *)presentingVC
                   navigateToTabBar:(BOOL)navigateToTabBar
                         completion:(nullable void(^)(void))completion {
    if (self.isLoggedIn) {
        if (completion) {
            completion();
        }
        return;
    }

    self.presentingVC = presentingVC;
    self.completion = completion;
    self.navigateToTabBar = navigateToTabBar;

    if ([[MKIDMEnvironmentManager sharedManager] isReleaseEnvironment]) {
        // Release: 无环境切换
        // 壳工程: 使用 MKIDMLoginAlertView
        // 子组件: MKIDMLoginAlertView 不存在，降级为 MKIDMLoginAlertWithEnvView（自动隐藏环境切换按钮）
        Class alertClass = NSClassFromString(@"MKIDMLoginAlertView");
        if (alertClass) {
            id alertView = [[alertClass alloc] init];
            SEL showSelector = @selector(showFromViewController:completion:);
            if ([alertView respondsToSelector:showSelector]) {
                ((void (*)(id, SEL, UIViewController *, void (^)(void)))
                 objc_msgSend)(alertView, showSelector, presentingVC, completion);
                return;
            }
        }
    }

    // Adhoc/Debug: 带环境切换
    // Release(子组件): MKIDMLoginAlertWithEnvView 自动隐藏环境切换按钮
    [self showLoginWithEnvFromViewController:presentingVC
                            navigateToTabBar:navigateToTabBar
                                  completion:completion];
}

- (void)showLoginWithEnvFromViewController:(UIViewController *)presentingVC
                                completion:(nullable void(^)(void))completion {
    [self showLoginWithEnvFromViewController:presentingVC navigateToTabBar:NO completion:completion];
}

- (void)showLoginWithEnvFromViewController:(UIViewController *)presentingVC
                          navigateToTabBar:(BOOL)navigateToTabBar
                                completion:(nullable void(^)(void))completion {
    if (self.isLoggedIn) {
        if (completion) {
            completion();
        }
        return;
    }
    
    self.presentingVC = presentingVC;
    self.completion = completion;
    self.navigateToTabBar = navigateToTabBar;
    
    MKIDMLoginAlertWithEnvViewModel *model = [[MKIDMLoginAlertWithEnvViewModel alloc] init];
    model.accountPlaceholder = @"Account";
    model.psdPlaceholder = @"Password";
    model.isHome = YES;
    
    MKIDMLoginAlertWithEnvView *alertView = [[MKIDMLoginAlertWithEnvView alloc] init];
    [alertView showViewWithModel:model completeBlock:^(NSString *account, NSString *password, BOOL isHome) {
        if (isHome) {
            [[MKIDMEnvironmentManager sharedManager] switchToEnvironment:MKIDMEnvironmentTypeProduction];
        } else {
            [[MKIDMEnvironmentManager sharedManager] switchToEnvironment:MKIDMEnvironmentTypeDevelopment];
        }
        
        [self performLoginWithAccount:account password:password completion:completion];
    }];
}

- (void)showExitAlertFromViewController:(UIViewController *)presentingVC
                              completion:(nullable void(^)(void))completion {
    if (!self.isLoggedIn) {
        if (completion) {
            completion();
        }
        return;
    }
    
    self.presentingVC = presentingVC;
    self.completion = completion;
    
    MKIDMUserModel *currentUser = [MKIDMUserManager sharedManager].currentUser;
    NSString *account = currentUser.username ?: @"";
    if (account.length == 0) {
        account = currentUser.email ?: @"当前账号";
    }
    
    MKIDMExitAccountAlert *alertView = [[MKIDMExitAccountAlert alloc] init];
    [alertView showWithAccount:account completeBlock:^{
        [self logout];
        if (completion) {
            completion();
        }
        if (self.completion) {
            self.completion();
        }
    }];
}

#pragma mark - Public Methods - TabBar 跳转

- (void)navigateToMainTabBarFromViewController:(UIViewController *)presentingVC {
    [self navigateToMainTabBarFromViewController:presentingVC completion:nil];
}

- (void)navigateToMainTabBarFromViewController:(UIViewController *)presentingVC
                                    completion:(nullable void(^)(void))completion {
    if (!presentingVC) {
        NSLog(@"[MKIDMLoginManager] presentingVC 为空，无法跳转 MainTabBar");
        if (completion) {
            completion();
        }
        return;
    }
    
    // 动态创建 MainTabBarController，避免编译期依赖
    Class tabBarClass = NSClassFromString(@"MKIDMMainTabBarController");
    if (!tabBarClass) {
        NSLog(@"[MKIDMLoginManager] MKIDMMainTabBarController 不存在，无法跳转");
        if (completion) {
            completion();
        }
        return;
    }
    
    id rawVC = [[tabBarClass alloc] init];
    if (![rawVC isKindOfClass:[UIViewController class]]) {
        if (completion) {
            completion();
        }
        return;
    }
    
    UIViewController *mainVC = (UIViewController *)rawVC;
    mainVC.modalPresentationStyle = UIModalPresentationFullScreen;
    
    [presentingVC hh_presentViewController:mainVC
                              presentStyle:HHPresentStyleErected
                                completion:^{
        if (completion) {
            completion();
        }
    }];
}

#pragma mark - Public Methods - Network Request

- (void)postWithPath:(NSString *)path
              params:(nullable id)params
            sucBlock:(void(^)(id returnData))sucBlock
           failBlock:(void(^)(NSError *error))failBlock {
    [self requestWithPath:path method:@"POST" params:params sucBlock:sucBlock failBlock:failBlock];
}

- (void)getWithPath:(NSString *)path
             params:(nullable NSDictionary *)params
           sucBlock:(void(^)(id returnData))sucBlock
          failBlock:(void(^)(NSError *error))failBlock {
    [self requestWithPath:path method:@"GET" params:params sucBlock:sucBlock failBlock:failBlock];
}

- (void)putWithPath:(NSString *)path
             params:(nullable NSDictionary *)params
           sucBlock:(void(^)(id returnData))sucBlock
          failBlock:(void(^)(NSError *error))failBlock {
    [self requestWithPath:path method:@"PUT" params:params sucBlock:sucBlock failBlock:failBlock];
}

- (void)deleteWithPath:(NSString *)path
                params:(nullable NSDictionary *)params
              sucBlock:(void(^)(id returnData))sucBlock
             failBlock:(void(^)(NSError *error))failBlock {
    [self requestWithPath:path method:@"DELETE" params:params sucBlock:sucBlock failBlock:failBlock];
}

#pragma mark - Private Methods

- (void)requestWithPath:(NSString *)path
                 method:(NSString *)method
                 params:(nullable id)params
               sucBlock:(void(^)(id returnData))sucBlock
              failBlock:(void(^)(NSError *error))failBlock {
    if (!self.isLoggedIn) {
        NSError *error = [NSError errorWithDomain:@"MKIDMLoginManager"
                                             code:1001
                                         userInfo:@{NSLocalizedDescriptionKey: @"Please login first"}];
        if (failBlock) {
            failBlock(error);
        }
        return;
    }
    
    if (!ValidStr(path)) {
        NSError *error = [NSError errorWithDomain:@"MKIDMLoginManager"
                                             code:1002
                                         userInfo:@{NSLocalizedDescriptionKey: @"Path cannot be empty"}];
        if (failBlock) {
            failBlock(error);
        }
        return;
    }
    
    NSString *fullURL = [NSString stringWithFormat:@"%@%@", self.baseURL, path];
    
    if ([method isEqualToString:@"GET"]) {
        [[MKIDMNetWorkRequest shared] GET:fullURL
                                parameters:params
                              successBlock:^(id returnData) {
            if (sucBlock) sucBlock(returnData);
        } failureBlock:^(NSError *error) {
            if (failBlock) failBlock(error);
        }];
    } else if ([method isEqualToString:@"PUT"]) {
        [[MKIDMNetWorkRequest shared] PUT:fullURL
                                parameters:params
                              successBlock:^(id returnData) {
            if (sucBlock) sucBlock(returnData);
        } failureBlock:^(NSError *error) {
            if (failBlock) failBlock(error);
        }];
    } else if ([method isEqualToString:@"DELETE"]) {
        [[MKIDMNetWorkRequest shared] DELETE:fullURL
                                   parameters:params
                                 successBlock:^(id returnData) {
            if (sucBlock) sucBlock(returnData);
        } failureBlock:^(NSError *error) {
            if (failBlock) failBlock(error);
        }];
    } else {
        [[MKIDMNetWorkRequest shared] POST:fullURL
                                 parameters:params
                               successBlock:^(id returnData) {
            if (sucBlock) sucBlock(returnData);
        } failureBlock:^(NSError *error) {
            if (failBlock) failBlock(error);
        }];
    }
}

- (void)performLoginWithAccount:(NSString *)account
                       password:(NSString *)password
                     completion:(void(^)(void))completion {
    [[MKHudManager share] showHUDWithTitle:@"Login..." inView:kAppWindow isPenetration:NO];
    
    [[MKIDMAccountService share] loginWithUsername:account
                                           password:password
                                           sucBlock:^(id returnData) {
        [[MKIDMUserManager sharedManager] handleLoginSuccessWithResponse:returnData];
        [self fetchUserInfoWithCompletion:completion];
    } failBlock:^(NSError *error) {
        [[MKHudManager share] hide];
        [kAppWindow showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)fetchUserInfoWithCompletion:(void(^)(void))completion {
    [[MKIDMAccountService share] getUserInfoWithSucBlock:^(id returnData) {
        [[MKIDMUserManager sharedManager] handleUserInfoWithData:returnData];
        [[MKHudManager share] hide];
        if (self.navigateToTabBar) {
            [self navigateToMainTabBarWithCompletion:completion];
        } else {
            if (completion) {
                completion();
            }
        }
    } failBlock:^(NSError *error) {
        [[MKHudManager share] hide];
        [kAppWindow showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - Private Methods - TabBar Navigation

/// 登录流程内部使用的 TabBar 跳转（依赖 self.presentingVC / self.completion）
- (void)navigateToMainTabBarWithCompletion:(void(^)(void))completion {
    // 合并回调：先执行外部传入的，再执行登录保存的
    void (^finalCompletion)(void) = ^{
        if (completion) {
            completion();
        }
        if (self.completion) {
            self.completion();
        }
    };
    
    // 没有 presentingVC 则直接回调
    if (!self.presentingVC) {
        if (finalCompletion) {
            finalCompletion();
        }
        return;
    }
    
    [self navigateToMainTabBarFromViewController:self.presentingVC completion:finalCompletion];
}

@end
