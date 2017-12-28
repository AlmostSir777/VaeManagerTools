//
//  VaeBaseWebViewController.m
//  Vae_ManagerTools
//
//  Created by 闵玉辉 on 2017/12/28.
//  Copyright © 2017年 闵玉辉. All rights reserved.
//

#import "VaeBaseWebViewController.h"
#import "YHWebViewProgress.h"
#import "YHWebViewProgressView.h"
@interface VaeBaseWebViewController ()<
UIWebViewDelegate,
WKNavigationDelegate,
WKUIDelegate,
UIGestureRecognizerDelegate,
WKScriptMessageHandler>
@property (nonatomic,strong) YHWebViewProgressView * progressView;
@property (strong, nonatomic) YHWebViewProgress *progressProxy;
@property (nonatomic, strong) UIBarButtonItem *backItem;
@property (nonatomic, strong) UIBarButtonItem *closeItem;
@property (nonatomic,strong) WKWebView * wkWeb;
@property (nonatomic,weak) WKWebViewConfiguration * wkConfig;

@property (nonatomic, strong) UIWebView *webView;
@end

@implementation VaeBaseWebViewController
-(instancetype)initWebWithUrl:(NSString *)bannerUrl webType:(WebType)webType
{
    if(self = [super init])
    {
        self.bannerUrl = bannerUrl;
        self.webType = webType;
    }
    return self;
}
- (UIBarButtonItem *)backItem
{
    if (!_backItem) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [button setImage:[UIImage imageNamed:@"back_black"] forState:UIControlStateNormal];
        [button setTitle:@"返回" forState:UIControlStateNormal];
        [button setTitleColor:KCOLOR(@"#333333") forState:UIControlStateNormal];
        button.imageEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 0);
        [button addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        _backItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    
    return _backItem;
}
- (UIBarButtonItem *)closeItem
{
    if (!_closeItem) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        button.titleEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 0);
        [button setTitle:@"关闭" forState:UIControlStateNormal];
        [button setTitleColor:KCOLOR(@"#333333") forState:UIControlStateNormal];
        [button addTarget:self action:@selector(closeSelf) forControlEvents:UIControlEventTouchUpInside];
        _closeItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    
    return _closeItem;
}
#pragma mark - Action

- (void)backAction
{
    if ([self.wkWeb canGoBack]) {
        [self.wkWeb goBack];
    } else {
        [self closeSelf];
    }
}


- (void)closeSelf
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self resolveURL];
 self.navigationItem.leftBarButtonItem = self.backItem;
}
- (void)createUI
{
    if(self.webType == NormalType) {
        [self.view addSubview:self.webView];
        [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(self.view);
        }];
    }else {
        [self.view addSubview:self.wkWeb];
            [self.wkWeb mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.view);
            }];
    }
    // 创建进度条代理，用于处理进度控制
    _progressProxy = [[YHWebViewProgress alloc] init];
    // 创建进度条
    YHWebViewProgressView *progressView = [[YHWebViewProgressView alloc] initWithFrame:CGRectMake(0,0,ScreenWidth, 2)];
    progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin;
    // 添加到视图
    [self.view addSubview:progressView];
    self.progressView = progressView;
    [self.view bringSubviewToFront:_progressView];
}
-(void)resolveURL
{
        if(self.webType == NormalType){
            // 将UIWebView代理指向YHWebViewProgress
            // 设置进度条
            self.progressProxy.progressView = self.progressView;
            // 设置webview代理转发到self（可选）
            self.progressProxy.webViewProxy = self;
    
            self.webView.delegate = self.progressProxy;
    
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_bannerUrl]]];
        }else
        {
            [self.progressView useWkWebView:self.wkWeb];
    [self.wkWeb addObserver:self
                 forKeyPath:@"loading"
                    options:NSKeyValueObservingOptionNew
                    context:nil];
    
    [self.wkWeb addObserver:self
                 forKeyPath:@"title"
                    options:NSKeyValueObservingOptionNew
                    context:nil];
    
    [self.wkWeb addObserver:self
                 forKeyPath:@"estimatedProgress"
                    options:NSKeyValueObservingOptionNew
                    context:nil];
    [self.wkWeb addObserver:self
                 forKeyPath:goGack
                    options:NSKeyValueObservingOptionNew
                    context:nil];
    [self.wkWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_bannerUrl]]];
        }
}
#pragma mark--KVO
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:@"loading"])
    {
        //         self.navigationItem.title = @"加载中...";
        
    } else if ([keyPath isEqualToString:@"title"])
    {
        self.navigationItem.title = self.wkWeb.title;
    } else if ([keyPath isEqualToString:@"estimatedProgress"])
    {
        [self.progressView setProgress:[change[@"new"] doubleValue] animated:YES];
        
    }else if ([keyPath isEqualToString:goGack])
    {
        [self updateButtonItems];
    }
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.navigationItem.title = title;
}
/**
 *  在发送请求之前，决定是否跳转
 *
 *  @param webView          实现该代理的webview
 *  @param navigationAction 当前navigation
 *  @param decisionHandler  是否调转block
 */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    
    //允许跳转
    decisionHandler(WKNavigationActionPolicyAllow);
}
- (void)updateButtonItems
{
    
    if ([self.wkWeb canGoBack]&&self.navigationItem.leftBarButtonItems.count!=2) {
        self.navigationItem.leftBarButtonItems = @[self.backItem, self.closeItem];
    }
    else
    {
        
        self.navigationItem.leftBarButtonItems = @[self.backItem];
    }
}

-(void)dealloc
{
    SSLog(@"%s",__func__);
    [self.wkConfig.userContentController removeScriptMessageHandlerForName:feedbackMessagehandler];
    [self.wkConfig.userContentController removeScriptMessageHandlerForName:GoHome];
    [self.wkConfig.userContentController removeScriptMessageHandlerForName:back];
    [self.wkConfig.userContentController removeScriptMessageHandlerForName:invite];
    [_wkWeb removeObserver:self forKeyPath:@"loading" context:nil];//移除kvo
    [_wkWeb removeObserver:self forKeyPath:@"title" context:nil];
    [_wkWeb removeObserver:self forKeyPath:@"estimatedProgress" context:nil];
    [_wkWeb removeObserver:self forKeyPath:goGack context:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    //接收处理各种js
    if([message.name isEqualToString:isFriendMessagehandler])
    {
        SSLog(@"%@__%@", message.name,message.body);
        [self callHandler:message.body];
    }else if ([message.name isEqualToString:feedbackMessagehandler])
    {
        //主动给web发送js交互
        [self.wkWeb evaluateJavaScript:[NSString stringWithFormat:@"showProfile(%@,%d)",message.body,YES] completionHandler:^(id _Nullable response, NSError * _Nullable error) {
            NSLog(@"%@ %@",response,error);

        }];
    }
}
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
    
}
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    //    DLOG(@"msg = %@ frmae = %@",message,frame);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }])];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = defaultText;
    }];
    [alertController addAction:([UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(alertController.textFields[0].text?:@"");
    }])];
    
    
    [self presentViewController:alertController animated:YES completion:nil];
}
//handler name
static NSString *isFriendMessagehandler = @"isFriend";
static NSString *feedbackMessagehandler = @"feedback";
static NSString *goGack = @"canGoBack";

static NSString *isFriendCB = @"isFriendCB";
static NSString *GoHome = @"goHome";
static NSString * back = @"back";
static NSString * payOrder = @"maidan";
static NSString * invite = @"invite";
-(WKWebView *)wkWeb
{
    if(_wkWeb == nil)
    {
        
        WKWebViewConfiguration *wkConfig = [[WKWebViewConfiguration alloc] init];
        wkConfig.userContentController = [[WKUserContentController alloc] init];
        self.wkConfig = wkConfig;
        _wkWeb = [[WKWebView alloc]initWithFrame:CGRectZero configuration:self.wkConfig];
        _wkWeb.UIDelegate = self;
        _wkWeb.navigationDelegate = self;
        //开启手势触摸
        [_wkWeb.scrollView setAlwaysBounceVertical:YES];
        // 这行代码可以是侧滑返回webView的上一级，而不是根控制器（*只针对侧滑有效）
        [_wkWeb setAllowsBackForwardNavigationGestures:true];
        _wkWeb.backgroundColor = [UIColor whiteColor];
        /*
         [[WeakScriptMessageDelegate alloc] initWithDelegate:self]
         间接建立js，因为直接用delegate会导致界面之间强引用，界面不走delloc
         */
        [self.wkConfig.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:feedbackMessagehandler];
        [self.wkConfig.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:GoHome];
        [self.wkConfig.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:back];
        [self.wkConfig.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:invite];
    }
    return _wkWeb;
}
- (UIWebView *)webView
{
    if (!_webView) {
        _webView = [[UIWebView alloc] init];
        _webView.delegate = self;
        _webView.opaque = NO;
        _webView.scalesPageToFit = YES;
        _webView.autoresizesSubviews = NO;
        _webView.backgroundColor = White_Color;
    }return _webView;
}

#pragma mark--群聊卡片弹框
- (void)callHandler:(id)data {
    
    
    
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
