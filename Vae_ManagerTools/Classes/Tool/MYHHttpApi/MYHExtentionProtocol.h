//
//  MYHExtentionProtocol.h
//  CatEntertainment
//
//  Created by 闵玉辉 on 2018/4/11.
//  Copyright © 2018年 闵玉辉. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MYHExtentionProtocol <NSObject>
/**
 将原始数据转换成外部可以直接使用的数据
 
 @param originData 原始数据
 @return 转换后数据
 */
- (id)reformData:(id)originData;

@end
