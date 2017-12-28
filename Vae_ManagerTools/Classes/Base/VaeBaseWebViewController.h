//
//  VaeBaseWebViewController.h
//  Vae_ManagerTools
//
//  Created by 闵玉辉 on 2017/12/28.
//  Copyright © 2017年 闵玉辉. All rights reserved.
//

#import "VaeBaseViewController.h"
#import <WebKit/WebKit.h>
typedef NS_ENUM(NSUInteger, WebType) {
    /**
     *  webview
     */
    NormalType       = 0,
    /**
     *  wkWebView
     */
    WKType             = 1,
    
};
@interface VaeBaseWebViewController : VaeBaseViewController
-(instancetype)initWebWithUrl:(NSString*)bannerUrl webType:(WebType)webType;
@property (nonatomic, copy) NSString *bannerUrl;
@property (nonatomic,assign) WebType webType;
@end
@interface WeakScriptMessageDelegate : NSObject<WKScriptMessageHandler>

@property (nonatomic, weak) id<WKScriptMessageHandler> scriptDelegate;

- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate;

@end

