//
//  VaeAppDelegate.h
//  Vae_ManagerTools
//
//  Created by 闵玉辉 on 2017/12/28.
//  Copyright © 2017年 闵玉辉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VaeTabBarController.h"
@interface VaeAppDelegate : UIResponder<UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
//动画更换根控制器
- (void)restoreRootViewController:(UIViewController *)rootViewController;
@property (nonatomic,strong) VaeTabBarController * tabBarVC;
@end
