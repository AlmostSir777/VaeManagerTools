//
//  HudCenter.h
//  SmallStuff
//
//  Created by Hy on 2017/3/29.
//  Copyright © 2017年 yuhuimin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface HudCenter : NSObject

extern void ShowSuccessStatus(NSString *statues);
extern void ShowErrorStatus(NSString *statues);
// MBP
/**
 * 纯文本
 **/
extern void SSMBToast(NSString *text,UIView * view);
/**
 * 隐藏mbhud
 **/
extern void SSDissMissMBHud(UIView * view,BOOL isAnimated);
/**
 * 显示错误或者成功
 **/
extern void SSSuccessOrErrorToast(NSString *statues,UIView * view,BOOL isSuccess);
/**
 * 添加hud在view
 **/
extern void SSHudShow(UIView * view,NSString * text);

extern void SSGifShow(UIView * view,NSString * text);

extern void SSDissMissGifHud(UIView * view,BOOL isAnimated);
@end
