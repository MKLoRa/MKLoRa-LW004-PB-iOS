#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "MKIDMLoginManager.h"
#import "MKIDMLoginAlertWithEnvView.h"
#import "MKIDMExitAccountAlert.h"
#import "MKIDMNetworkDefine.h"
#import "MKIDMNetworkingStatus.h"
#import "MKIDMNetWorkRequest.h"
#import "MKIDMEnvironmentManager.h"
#import "MKIDMUrlDefinition.h"
#import "MKIDMUserManager.h"
#import "MKIDMBaseService.h"
#import "MKIDMAccountService.h"

FOUNDATION_EXPORT double MKIotDMAppVersionNumber;
FOUNDATION_EXPORT const unsigned char MKIotDMAppVersionString[];

