//
//  SSRequest.m
//  SmallStuff
//
//  Created by Hy on 2017/3/29.
//  Copyright © 2017年 yuhuimin. All rights reserved.
//

#import "SSRequest.h"
@interface SSRequest ()
@end
@implementation SSRequest
 static SSRequest *ssrequest = nil;
+ (instancetype)request {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ssrequest = [[SSRequest alloc]init];
    });
    
    return ssrequest;
}
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (ssrequest == nil) {
            ssrequest = [super allocWithZone:zone];
        }
    });
    return ssrequest;
}
- (instancetype)init {
    self = [super init];
    if (self) {
        self.sessionManager = [AFHTTPSessionManager manager];
    }
    return self;
}

- (void)GET:(NSString *)URLString
 parameters:(NSDictionary *)parameters
    success:(void (^)(SSRequest *request, NSDictionary *response))success
    failure:(void (^)(SSRequest *request, NSError *error))failure {
    
    self.operationQueue=self.sessionManager.operationQueue;
    self.sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.sessionManager.requestSerializer.timeoutInterval = 10;
    
    AFJSONResponseSerializer *JsonSerializer = [AFJSONResponseSerializer serializer];
    JsonSerializer.removesKeysWithNullValues=YES;
    self.sessionManager.responseSerializer = JsonSerializer;
    
    [self.sessionManager GET:URLString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        success(self,responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        SSLog(@"[SSRequest]: %@",error.localizedDescription);
        failure(self,error);
    }];
    
}

static AFHTTPSessionManager * extracted(SSRequest *object) {
    return object.sessionManager;
}
- (void)POST:(NSString *)URLString
  parameters:(NSMutableDictionary*)parameters
     success:(void (^)(SSRequest *request, id response))success
     failure:(void (^)(SSRequest *request, NSString *errorMsg))failure{
        self.operationQueue = self.sessionManager.operationQueue;
        
        AFJSONResponseSerializer *JsonSerializer = [AFJSONResponseSerializer serializer];
        JsonSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
        JsonSerializer.removesKeysWithNullValues=YES;
        self.sessionManager.responseSerializer = JsonSerializer;
    [self.sessionManager POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         if(success)
         {
             success(self,responseObject);
         }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(failure)
        {
            success(self,error.localizedDescription);
        }
    }];
}


- (void)getWithURL:(NSString *)URLString {
    
    [self GET:URLString parameters:nil success:^(SSRequest *request, NSDictionary *response) {
        if ([self.delegate respondsToSelector:@selector(SSRequest:finished:)]) {
            [self.delegate SSRequest:request finished:response];
        }
    } failure:^(SSRequest *request, NSError *error) {
        if ([self.delegate respondsToSelector:@selector(SSRequest:Error:)]) {
            [self.delegate SSRequest:request Error:error.description];
        }
    }];
}

- (void)cancelAllOperations{
    [self.operationQueue cancelAllOperations];
}

+(void)SSNetType:(NetType)netType URLString:(NSString *)URLString parameters:(NSDictionary *)parameters animationHud:(BOOL)isAnimation animationView:(UIView *)view MJRefreshScroll:(UIScrollView *)scroll refreshType:(SSRefreshType)refreshType success:(void (^)(BaseModel *, BOOL))success failure:(void (^)(NSString *))failure
{
    if(isAnimation)
    {
        SSGifShow(view, @"加载中...");
    }
    if(netType == GET)
    {
        [[SSRequest request] GET:URLString parameters:parameters success:^(SSRequest *request, NSDictionary *response) {
            if(isAnimation)
            {
                SSDissMissMBHud(view, YES);
            }
            if(scroll)
            {
                [[SSRequest request] MJRefreshStop:scroll refreshType:refreshType];
            }
            BaseModel * model = [BaseModel mj_objectWithKeyValues:response];
            if(success)
            {
                success(model,model.succeed);
            }
        } failure:^(SSRequest *request, NSError *error)
         {
             if(isAnimation)
             {
                 SSDissMissMBHud(view, YES);
             }
             if(scroll)
             {
                 [[SSRequest request] MJRefreshStop:scroll refreshType:refreshType];
             }
             if(failure)
             {
                 failure(error.localizedDescription);
             }
         }];
    }
    else
    {
        [[SSRequest request] POST:URLString parameters:[parameters mutableCopy] success:^(SSRequest *request, id response) {
            
            if(isAnimation)
            {
                SSDissMissMBHud(view, YES);
            }
            if(scroll)
            {
                [[SSRequest request] MJRefreshStop:scroll refreshType:refreshType];
            }
            BaseModel * model = [BaseModel mj_objectWithKeyValues:response];
            if(success)
            {
                success(model,model.succeed);
            }
            
        } failure:^(SSRequest *request, NSString *errorMsg) {
            
            if(isAnimation)
            {
                SSDissMissMBHud(view, YES);
            }
            if(scroll)
            {
                [[SSRequest request] MJRefreshStop:scroll refreshType:refreshType];
            }
            if(failure)
            {
                failure(errorMsg);
            }
            
        }];
        
    }
}
-(void)MJRefreshStop:(UIScrollView*)scroll refreshType:(SSRefreshType)type
{
    if(type == SSHeaderRefreshType)
    {
        [scroll.mj_header endRefreshing];
    }else if (type == SSFooterRefreshType)
    {
        [scroll.mj_footer endRefreshing];
    }else
    {
        [scroll.mj_header endRefreshing];
        [scroll.mj_footer endRefreshing];
    }
}
@end
@implementation BaseModel


@end

