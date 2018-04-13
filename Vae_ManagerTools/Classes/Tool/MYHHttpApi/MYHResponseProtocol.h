//
//  MYHResponseProtocol.h
//  CatEntertainment
//
//  Created by 闵玉辉 on 2018/4/11.
//  Copyright © 2018年 闵玉辉. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MYHRequestProtocol.h"
typedef enum : NSInteger
{
    RequestSuccessState = 0,//成功
    RequestNetErrorState = 1,//网络错误
    RequestDataErrorState = 2,//code非200
} MYHRequestState;
@protocol MYHResponseProtocol <NSObject>
@optional;
/// 响应成功后的处理
- (void)apiResponseSuccessOrError:(BOOL)Success request:(id<MYHRequestProtocol>)request;
- (void)apiResponse:(MYHRequestState)requestState request:(id<MYHRequestProtocol>)request;
-(void)apiReceieveErrorMsg:(id)error;
@end

