//
//  VaeAppDelegate.m
//  Vae_ManagerTools
//
//  Created by 闵玉辉 on 2017/12/28.
//  Copyright © 2017年 闵玉辉. All rights reserved.
//

#import "VaeAppDelegate.h"
#import "VaeAppDelegate+ConfigNavBar.h"

void uncaughtExceptionHandler(NSException *exception) {
    NSLog(@"CRASH: %@", exception);
    NSLog(@"Stack Trace: %@", [exception callStackSymbols]);
    // Internal error reporting
}
@interface VaeAppDelegate()

@end
@implementation VaeAppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    VaeTabBarController * tabBar = [[VaeTabBarController alloc]init];
    self.window.rootViewController = tabBar;
    self.tabBarVC = tabBar;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)restoreRootViewController:(UIViewController *)rootViewController
{
    UIWindow *windos = [[UIApplication sharedApplication] keyWindow];
    for (UIView *view in windos.subviews) {
        [view removeFromSuperview];
    }
    
    typedef void (^Animation)(void);
    UIWindow* window = self.window;
    rootViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    Animation animation = ^{
        BOOL oldState = [UIView areAnimationsEnabled];
        [UIView setAnimationsEnabled:NO];
        window.rootViewController = rootViewController;
        [UIView setAnimationsEnabled:oldState];
    };
    
    [UIView transitionWithView:window
                      duration:0.8f
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:animation
                    completion:nil];
}
@end
