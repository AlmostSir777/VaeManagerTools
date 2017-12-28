//
//  SNLoading.m
//  ZhongRenBang
//
//  Created by 童臣001 on 16/7/26.
//  Copyright © 2016年 ZengWei. All rights reserved.
//

#import "SNLoading.h"
#import "MBProgressHUD.h"

static MBProgressHUD *progressHud = nil;

@implementation SNLoading

+ (void)showWithTitle:(NSString *)title
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (!progressHud)
        {
            [progressHud removeFromSuperview];
            progressHud = nil;
        }
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        progressHud = [[MBProgressHUD alloc] initWithWindow:window];
#warning TODO 谁求知道
//        progressHud.labelText = title ? title : GBLocalizedString(@"Loading");
        progressHud.removeFromSuperViewOnHide = YES;
        [window addSubview:progressHud];
        [progressHud show:YES];
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        
    });
}

+ (void)hideWithTitle:(NSString *)title
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
//        progressHud.labelText = title ? title : GBLocalizedString(@"Loaded");
        [progressHud hide:YES];
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
    });
}

+ (void)updateWithTitle:(NSString *)title detailsText:(NSString *)detailsText
{
//    progressHud.labelText = title ? title : GBLocalizedString(@"Loading");
    progressHud.detailsLabelText = detailsText;
}

@end
