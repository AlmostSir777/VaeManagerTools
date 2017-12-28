//
//  SSLayerAnimation.h
//  SmallStuff
//
//  Created by 闵玉辉 on 2017/7/14.
//  Copyright © 2017年 yuhuimin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, TabbarAnimationType) {
    RotationAnimationRound = 0,//旋转360
    BounceAnimation = 1,//放大缩小
    RotationAnimationLeftRight = 2,//左右翻转
};
@interface SSLayerAnimation : NSObject
+(void)animationWithTabbarIndex:(NSInteger)index type:(TabbarAnimationType)type;
+(void)aniamtionWithTarBarView:(UIView*)view type:(TabbarAnimationType)type;
+(void)aniamtionWithView:(UIView *)view type:(TabbarAnimationType)type;
+(void)shakeAnimationForView:(UIView *) view;
@end
