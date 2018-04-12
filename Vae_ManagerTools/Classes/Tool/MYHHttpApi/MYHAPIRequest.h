//
//  MYHAPIRequest.h
//  CatEntertainment
//
//  Created by 闵玉辉 on 2018/4/11.
//  Copyright © 2018年 闵玉辉. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSRequest.h"
#import "MYHRequestProtocol.h"
#import "MYHResponseProtocol.h"
@interface MYHAPIRequest : NSObject
/**
 * requset 对象
 **/
@property (nonatomic,weak) id<MYHRequestProtocol>request;
/**
 * 数据代理对象
 **/
@property (nonatomic,weak) id<MYHResponseProtocol>delegate;
/**
 * 请求返回的原始数据
 **/
@property (nonatomic, copy) NSDictionary *responseData;
/**
 * 请求返回error对象
 **/
@property (nonatomic, strong) id responseError;
/**
 *  分页page，shouldPaging属性开了才允许使用
 **/
@property (nonatomic,assign) NSInteger currentPage;
/**
 *  分页键值，shouldPaging属性开了才允许使用
 **/
@property (nonatomic,copy) NSString * pageKey;
-(void)startApiRuquest;
@end
