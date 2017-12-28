//
//  VaeAppDelegate+ConfigNavBar.m
//  Vae_ManagerTools
//
//  Created by 闵玉辉 on 2017/12/28.
//  Copyright © 2017年 闵玉辉. All rights reserved.
//

#import "VaeAppDelegate+ConfigNavBar.h"
#import <WebKit/WebKit.h>
@implementation VaeAppDelegate (ConfigNavBar)
//全局导航栏处理
-(void)configNavBar
{
    [[UITabBar appearance] setBarTintColor:[Utils colorConvertFromString:@"#f6f6f6"]];
    UINavigationBar *navBar = [UINavigationBar appearance];
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = [UIColor blackColor];
    attrs[NSFontAttributeName] = [UIFont boldSystemFontOfSize:18];
    [navBar setTitleTextAttributes:attrs];
    
    UIBarButtonItem *barItem = [UIBarButtonItem appearance];
    NSMutableDictionary *itemAttrs = [NSMutableDictionary dictionary];
    itemAttrs[NSForegroundColorAttributeName] = KCOLOR(@"#333333");
    itemAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:17.0];
    [barItem setTitleTextAttributes:itemAttrs forState:UIControlStateNormal];
    [barItem setTitleTextAttributes:itemAttrs forState:UIControlStateHighlighted];
    [[UINavigationBar appearance] setBarStyle:UIBarStyleDefault];
    
    //设置系统默认返回按钮颜色
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
    //    [[UINavigationBar appearance] setShadowImage:[UIImage createImageWithColor:KCOLOR(@"#cccccc")]];
//    [[UITabBar appearance] setBackgroundImage:[UIImage createImageWithColor:[UIColor whiteColor]]];
    
    if (@available(iOS 11.0, *)) {
        UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        UITableView.appearance.estimatedRowHeight = 0;
        UITableView.appearance.estimatedSectionFooterHeight = 0;
        UITableView.appearance.estimatedSectionHeaderHeight = 0;
        WKWebView.appearance.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        WKWebView.appearance.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        WKWebView.appearance.scrollView.scrollIndicatorInsets = WKWebView.appearance.scrollView.contentInset;
        
    } else {
        // Fallback on earlier versions
    }
}
@end
