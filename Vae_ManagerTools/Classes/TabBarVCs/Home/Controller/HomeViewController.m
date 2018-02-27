//
//  HomeViewController.m
//  Vae_ManagerTools
//
//  Created by 闵玉辉 on 2017/12/28.
//  Copyright © 2017年 闵玉辉. All rights reserved.
//

#import "HomeViewController.h"
#import <WeexSDK.h>
#import <TBWXDevTool/WXDevTool.h>
@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [WXDevTool setDebug:YES];
    [WXDevTool launchDevToolDebugWithUrl:@"ws://30.30.31.7:8088/debugProxy/native"];
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationRefreshInstance:) name:@"RefreshInstance" object:nil];
}
-(void)notificationRefreshInstance:(NSNotification*)noti
{
    SSLog(@"5555");
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
