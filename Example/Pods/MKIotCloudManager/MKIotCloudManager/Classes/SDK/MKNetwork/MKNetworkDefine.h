//
//  MKNetworkDefine.h
//  MKIotCloudManager
//
//  Created by aa on 2024/12/6.
//  Copyright © 2024 lovexiaoxia. All rights reserved.
//

#ifndef MKNetworkDefine_h
#define MKNetworkDefine_h

/**
 *  请求类型
 */
typedef NS_ENUM(NSInteger, MKNetworkRequestType) {
    MKNetworkRequestGet = 0,
    MKNetworkRequestPost = 1,
};

/**
 *  错误类型
 */
typedef NS_ENUM(NSInteger, MKNetworkErrorType){
    MKNetworkErrorDefault   = 0,
    MKNetworkErrorNoServer  = -1003,
    MKNetworkErrorTimeOut   = -1001,
    MKNetworkErrorNoNetwork = -1009
};

#pragma mark - 成功失败block
/**
 *  请求成功时的回调
 *
 *  @param responseObject 回调的对象
 *  @param task           请求task
 */
typedef void (^MKNetworkRequestSuccessBlock)(id returnData);
/**
 *  请求错误的回调
 *
 *  @param error 错误回调的对象
 *  @param task  请求task
 */
typedef void (^MKNetworkRequestFailureBlock)(NSError *error);


#pragma mark -                           常见HTTP错误编码表

/**
 *  @breif                               成功
 */
#define RESULT_SUCCESS                   200

/**
 *  @breif                               无结果
 */
#define RESULT_EMPTY                     204

/**
 *  @breif                               请求参数不对，如json格式不对，或必填得参数没有携带
 */
#define RESULT_PARA_ERROR                400

/**
 *  @breif                               未授权(需要客户端对自己认证)
 */
#define RESULT_VERIFY_USER_ERROR         401

/**
 *  @breif                               服务器拒接访问
 */
#define RESULT_SERVER_DENIED             403

/**
 *  @breif                               未找到服务器资源
 */
#define RESULT_SERVER_NOT_FOUND          404

/**
 *  @breif                               不允许使用的方法
 */
#define RESULT_SERVER_NOT_ALLOW          405

/**
 *  @breif                               网络不给力
 */
#define RESULT_SERVER_TIMEOUT            408

/**
 *  @breif                               请求冲突(发出的请求在资源上造成了一些冲突)
 */
#define RESULT_SERVER_REQUEST_CONFLICGT  409

/**
 *  @breif                               请求实体太大
 */
#define RESULT_SERVER_TOO_LARGE          413

/**
 *  @breif                               请求URL太长
 */
#define RESULT_SERVER_URL_LONG           414

/**
 *  @breif                               不支持的媒体类型
 */
#define RESULT_SERVER_UNSUPPORT_TYPE     415

/**
 *  @breif                               Server端内部错误，具体错误见response输出
 */
#define RESULT_SERVER_ERROR              500

/**
 *  @breif                               网关故障
 */
#define RESULT_SERVER_BAD_GATEWAY        502

/**
 *  @breif                               网关超时
 */
#define RESULT_SERVER_GATEWAY_TIMEOUT    504

/**
 *  @breif                               服务器收到的请求使用了它不支持的HTTP协议版本
 */
#define RESULT_SERVER_UNSUPPORT_PROTOCOL 505


#pragma mark -                       接口调用参数错误编码

/**
 *                                   服务器正常响应
 */
#define RESULT_API_SUCCESS           0

/**
 *                                   用户手动中断
 */
#define RESULT_API_USER_BREAK        1022

/**
 *                                   网络不给力
 */
#define RESULT_API_UNKNOW_ERROR      0

/**
 *                                   必须参数为空
 */
#define RESULT_API_PARAMS_EMPTY      5001


/**
 *                                   参数超出允许的最大值
 */
#define RESULT_API_PARAMS_TOO_LARGE  0

/**
 *                                   参数小于允许的最小值
 */
#define RESULT_API_PARAMS_TOO_SMALL  0

/**
 *                                   参数与允许的类型不匹配
 */
#define RESULT_API_PARAMS_TYPE_ERROR 0

/**
 *                                   接口数据格式错误,与允许数据格式不匹配
 */
#define RESULT_API_DATA_TYPE_ERROR   0

/**
 *                                   参数非法，参数必须为正整数
 */
#define RESULT_API_PARAMS_MUST_INT   0

/**
 *                                   参数非法,参数不能为空字符串
 */
#define RESULT_API_PARAMS_IS_NULL    0

/**
 *                                   参数非法,参数长度超出允许的最大值
 */
#define RESULT_API_PARAMS_TOO_LONG   0
/**
 *                                   参数非法：参数长度超出允许的最小值
 */
#define RESULT_API_PARAMS_TOO_SHORT  0

/**
 *  状态信息出错,如未返回状态信息等
 */
#define RESULT_API_STATUS_ERROR      0

/**
 *  返回的字典为nil或者为Null ,[Dic objectForkey:@"data"]为nil或Null对象
 */
#define RESULT_API_DATA_IS_NULL      0


#endif /* MKNetworkDefine_h */
