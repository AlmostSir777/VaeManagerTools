//
//  VaeBaseWebViewController.m
//  Vae_ManagerTools
//
//  Created by 闵玉辉 on 2017/12/28.
//  Copyright © 2017年 闵玉辉. All rights reserved.
//

#import "VaeBaseWebViewController.h"
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
@interface VaeBaseWebViewController ()
@property (nonatomic, copy) NSString *bannerUrl;
@property (nonatomic,assign) WebType webType;
@end

@implementation VaeBaseWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
@implementation WeakScriptMessageDelegate

- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate {
    self = [super init];
    if (self) {
        _scriptDelegate = scriptDelegate;
    }
    return self;
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    [self.scriptDelegate userContentController:userContentController didReceiveScriptMessage:message];
}
-(void)dealloc
{
    NSLog(@"%s",__func__);
}
@end
