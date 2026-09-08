// MKIDMNetworkDefine.h
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, MKIDMNetworkReachabilityStatus) {
    MKIDMNetworkReachabilityStatusUnknown          = -1,
    MKIDMNetworkReachabilityStatusNotReachable     = 0,
    MKIDMNetworkReachabilityStatusReachableViaWWAN = 1,
    MKIDMNetworkReachabilityStatusReachableViaWiFi = 2,
};

/**
 *  请求类型
 */
typedef NS_ENUM(NSInteger, MKIDMNetworkRequestType) {
    MKIDMNetworkRequestPost = 0,
    MKIDMNetworkRequestGet = 1,
    MKIDMNetworkRequestDelete = 2,
    MKIDMNetworkRequestPut = 3,
};

/**
 *  错误类型
 */
typedef NS_ENUM(NSInteger, MKIDMNetworkErrorType){
    MKIDMNetworkErrorDefault             = 0,
    MKIDMNetworkErrorUnauthorized        = -1001,  // 未授权
    MKIDMNetworkErrorAuthorizationExpired = -1002, // 授权过期
    MKIDMNetworkErrorSystemError         = -1003,  // 系统错误
    MKIDMNetworkErrorInvalidURL          = -1004,  // 无效URL
    MKIDMNetworkErrorInvalidParameters   = -1005,  // 无效参数
    MKIDMNetworkErrorFileTooLarge        = -1006,  // 文件太大
    MKIDMNetworkErrorNetworkTimeout      = -1007,  // 网络超时
    MKIDMNetworkErrorNetworkUnavailable  = -1008,  // 网络不可用
    MKIDMNetworkErrorServerError         = -1009,  // 服务器错误
};

/**
 *  内容类型
 */
typedef NS_ENUM(NSInteger, MKIDMContentType) {
    MKIDMContentTypeJSON = 0,           // application/json
    MKIDMContentTypeFormURLEncoded = 1, // application/x-www-form-urlencoded
    MKIDMContentTypeMultipartFormData = 2, // multipart/form-data
};

#pragma mark - 成功失败block
/**
 *  请求成功时的回调
 *
 *  @param returnData 回调的数据
 */
typedef void (^MKIDMNetworkRequestSuccessBlock)(id returnData);

/**
 *  请求错误的回调
 *
 *  @param error 错误信息
 */
typedef void (^MKIDMNetworkRequestFailureBlock)(NSError *error);

/**
 *  上传进度回调
 *
 *  @param progress 进度值 (0.0 ~ 1.0)
 */
typedef void (^MKIDMNetworkUploadProgressBlock)(double progress);

/**
 *  下载进度回调
 *
 *  @param progress 进度值 (0.0 ~ 1.0)
 */
typedef void (^MKIDMNetworkDownloadProgressBlock)(double progress);

