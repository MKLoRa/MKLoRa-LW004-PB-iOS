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

#import "MKUrlDefinition.h"
#import "MKNetworkDefine.h"
#import "MKNetworkingStatus.h"
#import "MKBaseService.h"
#import "MKNormalService.h"
#import "MKIoTCloudAccountLoginAlertView.h"
#import "MKIoTCloudExitAccountAlert.h"

FOUNDATION_EXPORT double MKIotCloudManagerVersionNumber;
FOUNDATION_EXPORT const unsigned char MKIotCloudManagerVersionString[];

