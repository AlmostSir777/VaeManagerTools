//
//  UIButton+Category.h
//  ZhongRenBang-New
//
//  Created by 看楼听雨 on 16/8/26.
//  Copyright © 2016年 XJ. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIButton (Category)

/**
 *  设置不同状态下Button的背景色
 *
 *  @param backgroundColor Button的背景色
 *  @param state           Button的状态
 */
- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state;
- (UIImage *)imageWithColor:(UIColor *)color;

@end
