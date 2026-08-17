//
//  MKUrlDefinition.h
//  MKIotCloudManager_Example
//
//  Created by aa on 2025/3/4.
//  Copyright © 2025 aadyx2007@163.com. All rights reserved.
//

#ifndef MKUrlDefinition_h
#define MKUrlDefinition_h

#define HOME_URL                        @"https://iotdm.mokocloud.com/"
#define TEST_URL                        @"https://testiotdm.mokocloud.com/"

#define MKRequstUrl(url)              [NSString stringWithFormat:@"%@%@",HOME_URL,url]
#define MKTestRequstUrl(url)              [NSString stringWithFormat:@"%@%@",TEST_URL,url]

#endif /* MKUrlDefinition_h */
