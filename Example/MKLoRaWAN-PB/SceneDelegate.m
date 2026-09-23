//
//  SceneDelegate.m
//  MKLoRaWAN-PB_Example
//
//  Created by aa on 2026/9/23.
//  Copyright © 2026 aadyx2007@163.com. All rights reserved.
//

#import "SceneDelegate.h"

#import "MKPBScanController.h"

@implementation SceneDelegate

- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    if (![scene isKindOfClass:[UIWindowScene class]]) {
        return;
    }
    UIWindowScene *windowScene = (UIWindowScene *)scene;
    self.window = [[UIWindow alloc] initWithWindowScene:windowScene];
    self.window.backgroundColor = [UIColor whiteColor];
    MKPBScanController *vc = [[MKPBScanController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
}

@end
