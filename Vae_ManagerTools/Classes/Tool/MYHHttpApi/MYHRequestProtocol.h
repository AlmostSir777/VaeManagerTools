//
//  MYHRequestProtocol.h
//  CatEntertainment
//
//  Created by 闵玉辉 on 2018/4/11.
//  Copyright © 2018年 闵玉辉. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MYHExtentionProtocol.h"
@protocol MYHRequestProtocol <NSObject>
@required;
/// 请求的URL
- (NSString *)apiRequestURL;
/// 请求的参数
- (NSDictionary *)apiRequestParams;
/// 请求成功的数据加工
- (id)fetchDataWithReformer:(id <MYHExtentionProtocol>)reformer;
/// 请求成功的数据加工
- (id)fetchData;
///需要分页
-(BOOL)shouldPaging;
@end
