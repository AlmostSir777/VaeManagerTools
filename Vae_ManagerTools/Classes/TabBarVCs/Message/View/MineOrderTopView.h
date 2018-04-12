//
//  MineOrderTopView.h
//  CatEntertainment
//
//  Created by 闵玉辉 on 2017/10/20.
//  Copyright © 2017年 闵玉辉. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineOrderTopView : UIView
-(instancetype)initWithIndex:(NSInteger)index;
@property (nonatomic,assign) NSInteger index;
@property (nonatomic,copy)void(^orderBlock)(NSInteger index);
@property (nonatomic,assign) NSInteger selectIndex;
@end
