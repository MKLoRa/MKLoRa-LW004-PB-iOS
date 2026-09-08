//
//  MKIDMUrlDefinition.h
//  MKIotDMApp
//
//  Created by aa on 2025/11/25.
//  Copyright © 2025 lovexiaoxia. All rights reserved.
//

#ifndef MKIDMUrlDefinition_h
#define MKIDMUrlDefinition_h

#import "MKIDMEnvironmentManager.h"

// 获取 Base URL（支持外部调用）
static inline NSString* MKIDMGetBaseURL(void) {
    return [MKIDMEnvironmentManager sharedManager].baseURL;
}

// 宏定义（内部使用，外部也可用）
#define MKIDMHOME_BASE_URL MKIDMGetBaseURL()

#define MKIDMRequstUrl(url)              [NSString stringWithFormat:@"%@%@", MKIDMHOME_BASE_URL, url]
#define MKIDMRequstDomainUrl(domain,url) [NSString stringWithFormat:@"%@%@", domain, url]

#endif /* MKIDMUrlDefinition_h */
