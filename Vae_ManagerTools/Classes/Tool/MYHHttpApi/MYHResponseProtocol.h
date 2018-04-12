//
//  MYHResponseProtocol.h
//  CatEntertainment
//
//  Created by 闵玉辉 on 2018/4/11.
//  Copyright © 2018年 闵玉辉. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MYHRequestProtocol.h"
@protocol MYHResponseProtocol <NSObject>
@optional;
/// 响应成功后的处理
- (void)apiResponseSuccessOrError:(BOOL)Success request:(id<MYHRequestProtocol>)request;
-(void)apiReceieveErrorMsg:(id)error;
@end
