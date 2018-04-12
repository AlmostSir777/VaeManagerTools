//
//  SSRequest.h
//  SmallStuff
//
//  Created by Hy on 2017/3/29.
//  Copyright © 2017年 yuhuimin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>




#define RequestStateCode ([response[@"ret"] integerValue])

static NSInteger const completionCode = 200;

@class SSRequest;
@protocol SSRequestDelegate <NSObject>

- (void)SSRequest:(SSRequest *)request finished:(NSDictionary *)response;
- (void)SSRequest:(SSRequest *)request Error:(NSString *)error;

@end
typedef NS_ENUM(NSUInteger, NetType) {
     GET = 0,//get
     POST = 1,//post
};
typedef NS_ENUM(NSUInteger, SSRefreshType) {
    NoneRefreshType = 0,//无刷新
    SSHeaderRefreshType = 1,//只有上拉
    SSFooterRefreshType = 2,//只有下拉
    SSDoubleRefreshType = 3,//上拉下拉都有
};
@class BaseModel;
@interface SSRequest : NSObject

@property (nonatomic,weak) id<SSRequestDelegate> delegate;


/**
 *[AFNetWorking]的operationManager对象
 */
@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

/**
 *当前的请求operation队列
 */
@property (nonatomic, strong) NSOperationQueue *operationQueue;

/**
 *功能: 创建SSRequest的对象方法
 */
+ (instancetype)request;

/**
 *功能：GET请求
 *参数：(1)请求的url: urlString
 *     (2)请求成功调用的Block: success
 *     (3)请求失败调用的Block: failure
 */
- (void)GET:(NSString *)URLString
 parameters:(NSDictionary *)parameters
    success:(void (^)(SSRequest *request, NSDictionary *response))success
    failure:(void (^)(SSRequest *request, NSError *error))failure;

/**
 *功能：POST请求
 *参数：(1)请求的url: urlString
 *     (2)POST请求体参数:parameters
 *     (3)请求成功调用的Block: success
 *     (4)请求失败调用的Block: failure
 */
- (void)POST:(NSString *)URLString
  parameters:(NSMutableDictionary *)parameters
     success:(void (^)(SSRequest *request, id response))success
     failure:(void (^)(SSRequest *request, NSString *errorMsg))failure;


/**
 *功能：POST请求-->   ret != 200时  也需要返回的ret的情况
 *参数：(1)请求的url: urlString
 *     (2)POST请求体参数:parameters
 *     (3)请求成功调用的Block: success
 *     (4)请求失败调用的Block: failure
 */
//- (void)POSTWithAllReturn:(NSString *)URLString
//               parameters:(NSMutableDictionary*)parameters
//                  success:(void (^)(SSRequest *request, id response))success
//                  failure:(void (^)(SSRequest *request, NSString *errorMsg))failure;

/**
 *功能：POST请求不带Token
 *参数：(1)请求的url: urlString
 *     (2)POST请求体参数:parameters
 *     (3)请求成功调用的Block: success
 *     (4)请求失败调用的Block: failure
 */
//- (void)POSTNoToken:(NSString *)URLString
//         parameters:(NSDictionary *)parameters
//            success:(void (^)(SSRequest *request, id response))success
//            failure:(void (^)(SSRequest *request, NSError *error))failure;
/**
 *  get 请求
 *
 *  @param URLString 请求网址
 */
- (void)getWithURL:(NSString *)URLString;

/**
 *取消当前请求队列的所有请求
 */
- (void)cancelAllOperations;


/**
 *功能：POST请求
 *参数：(1)请求的url: urlString
 *     (2)POST请求体参数:parameters
 *     (3)请求成功调用的Block: success
 *     (4)请求失败调用的Block: failure
 *     (5)是否有hud 以及哪个scroll是否存在刷新
 */
+ (void)SSNetType:(NetType)netType
      URLString:(NSString *)URLString
     parameters:(NSDictionary *)parameters
     animationHud:(BOOL)isAnimation
     animationView:(UIView*)view
     MJRefreshScroll:(UIScrollView*)scroll
     refreshType:(SSRefreshType)refreshType
     success:(void (^)(BaseModel * model,BOOL isSuccess))success
     failure:(void (^)(NSString  *errorMsg))failure;
@end
@interface BaseModel:NSObject
@property (nonatomic,assign) BOOL succeed;
@property (nonatomic,assign) NSInteger errCode;
@property (nonatomic,strong) id  data;
@property (nonatomic,copy) NSString * errMsg;
@end
