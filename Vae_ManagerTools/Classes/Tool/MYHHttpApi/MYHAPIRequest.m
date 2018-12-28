//
//  MYHAPIRequest.m
//  CatEntertainment
//
//  Created by 闵玉辉 on 2018/4/11.
//  Copyright © 2018年 闵玉辉. All rights reserved.
//

#import "MYHAPIRequest.h"

@implementation MYHAPIRequest
-(instancetype)initWithDelegate:(id<MYHResponseProtocol>)delegate
{
    if(self = [super init])
    {
        if ([self conformsToProtocol:@protocol(MYHRequestProtocol)]) {
            self.request = (id<MYHRequestProtocol>)self;
        } else {
            // 不遵守这个protocol的就让他crash，防止派生类乱来。
            NSAssert(NO, @"子类必须要实现APIManager这个protocol");
        }
        self.delegate = delegate;
    }
    return self;
}
- (instancetype)init {
    self = [super init];
    if ([self conformsToProtocol:@protocol(MYHRequestProtocol)]) {
        self.request = (id<MYHRequestProtocol>)self;
    } else {
        // 不遵守这个protocol的就让他crash，防止派生类乱来。
        NSAssert(NO, @"子类必须要实现APIManager这个protocol");
    }
    return self;
}
- (void)startApiRuquest{
    
    NSString *url = [self.request apiRequestURL];
    NSMutableDictionary *params = [self.request apiRequestParams].mutableCopy;
    if([self.request shouldPaging])
    {
        [params setObject:@(self.currentPage) forKey:self.pageKey];
    }
//    [[SSRequest request] POSTWithAllReturn:url parameters:params success:^(SSRequest *request, id response) {
//        if(RequestStateCode == completionCode)
//        {
//            [self successCallBack:response];
//        }else
//        {
//            [self errorCallBack:response];
//        }
//    } failure:^(SSRequest *request, NSString *errorMsg) {
//        [self errorCallBack:errorMsg];
//    }];
    
}
-(void)errorCallBack:(id)error
{
    self.responseError = error;
    if ([self.delegate respondsToSelector:@selector(apiResponseSuccessOrError:request:)]) {
        [self.delegate apiResponseSuccessOrError:NO request:self.request];
    }
    if([self.delegate respondsToSelector:@selector(apiReceieveErrorMsg:)])
    {
        if([error isKindOfClass:[NSDictionary class]])
        {
            [self.delegate apiReceieveErrorMsg:error[@"msg"]];
        }else{
            [self.delegate apiReceieveErrorMsg:error];
        }
    }
    if([error isKindOfClass:[NSDictionary class]])
    {
        if([self.delegate respondsToSelector:@selector(apiResponse:request:)])
        {
            [self.delegate apiResponse:RequestDataErrorState request:self.request];
        }
    }else{
        if([self.delegate respondsToSelector:@selector(apiResponse:request:)])
        {
            [self.delegate apiResponse:RequestNetErrorState request:self.request];
        }
    }
}
- (void)successCallBack:(NSDictionary *)data {
    self.responseData  = data;
    if ([self.delegate respondsToSelector:@selector(apiResponseSuccessOrError:request:)]) {
        [self.delegate apiResponseSuccessOrError:YES request:self.request];
    }
    if([self.delegate respondsToSelector:@selector(apiResponse:request:)])
    {
        [self.delegate apiResponse:RequestSuccessState request:self.request];
    }
}
@end

