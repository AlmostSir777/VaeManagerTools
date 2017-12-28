//
//  HudCenter.m
//  SmallStuff
//
//  Created by Hy on 2017/3/29.
//  Copyright © 2017年 yuhuimin. All rights reserved.
//

#import "HudCenter.h"
#import <SDWebImageManager.h>
#import <SDWebImageCompat.h>
#import <AVFoundation/AVFoundation.h>
#import "MMMaterialDesignSpinner.h"
/** 颜色(RGB) */
#define RGBCOLOR(r, g, b)       [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r, g, b, a)   [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]


@implementation HudCenter


void ShowSuccessStatus(NSString *statues){
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD showSuccess:statues];
        });
    }else{
        [MBProgressHUD showSuccess:statues];
    }
}

void ShowErrorStatus(NSString *statues){
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
             [MBProgressHUD showError:statues];
        });
    }else{
        [MBProgressHUD showError:statues];
    }
}
/*-----------MYH-MB--------------*/
void SSMBToast(NSString *text,UIView * view)
{
    
    if(!view)
    {
        view = MainWindow;
    }
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD showText:text toView:view];
        });
    }else{
        [MBProgressHUD showText:text toView:view];
    }
}
void  SSDissMissMBHud(UIView * view,BOOL isAnimated)
{
    if(!view)
    {
        view = MainWindow;
    }
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:view animated:isAnimated];
        });
    }else{
        [MBProgressHUD hideHUDForView:view animated:isAnimated];
    }
}
void SSSuccessOrErrorToast(NSString *statues,UIView * view,BOOL isSuccess)
{
    if(!view)
    {
        view = MainWindow;
    }
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(isSuccess)
            {
                [MBProgressHUD showSuccess:statues toView:view];
            }else
            {
                [MBProgressHUD showError:statues toView:view];
            }
        });
    }else{
        if(isSuccess)
        {
            [MBProgressHUD showSuccess:statues toView:view];
        }else
        {
            [MBProgressHUD showError:statues toView:view];
        }
    }
}
void SSHudShow(UIView * view,NSString * text)
{
    if(!view)
    {
        view = MainWindow;
    }
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
            if(text){
            hud.detailsLabelText = text;
            }
        });
    }else{
        MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        if(text){
            hud.detailsLabelText = text;
        }
    }
}
extern void SSGifShow(UIView * view,NSString * text)
{

    if(!view)
    {
        view = MainWindow;
    }
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
            MMMaterialDesignSpinner * _activity = [[MMMaterialDesignSpinner alloc] init];
            _activity.lineWidth = 2.f;
            _activity.duration  = 1.f;
            _activity.mj_size = CGSizeMake(30, 30);
            //[[UIColor whiteColor] colorWithAlphaComponent:0.9];
            _activity.tintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9];
            [_activity startAnimating];
            hud.customView = _activity;
            hud.mode = MBProgressHUDModeCustomView;
            if(text){
                hud.detailsLabelText = text;
            }
        });
    }else{
        MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        MMMaterialDesignSpinner * _activity = [[MMMaterialDesignSpinner alloc] init];
        _activity.lineWidth = 2.f;
        _activity.duration  = 1.f;
        //[[UIColor whiteColor] colorWithAlphaComponent:0.9];
        _activity.tintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9];;
        _activity.mj_size = CGSizeMake(30, 30);
        [_activity startAnimating];
        hud.customView = _activity;
        hud.mode = MBProgressHUDModeCustomView;
        if(text){
            hud.detailsLabelText = text;
        }
    }
}
extern void SSDissMissGifHud(UIView * view,BOOL isAnimated)
{
    if(!view)
    {
        view = MainWindow;
    }
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:view animated:isAnimated];
        });
    }else{
        [MBProgressHUD hideHUDForView:view animated:isAnimated];
    }
}
/*-----------MYH-MB--------------*/
@end
