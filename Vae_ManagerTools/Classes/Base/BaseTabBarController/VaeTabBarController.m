//
//  VaeTabBarController.m
//  Vae_ManagerTools
//
//  Created by 闵玉辉 on 2017/12/28.
//  Copyright © 2017年 闵玉辉. All rights reserved.
//
#import "VaeBaseViewController.h"
#import "VaeNavigationController.h"
#import "VaeTabBarController.h"
#import "VaeTabBar.h"
#import "SSLayerAnimation.h"
@interface VaeTabBarController ()<UITabBarControllerDelegate>
@property (nonatomic,assign) NSInteger indexFlag;
@end

@implementation VaeTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configVC];
    self.delegate = self;
    VaeTabBar *tabbar = [[VaeTabBar alloc]init];
    [self setValue:tabbar forKeyPath:@"tabBar"];
}
-(void)configVC
{
    
    NSArray * classNames = @[@"HomeViewController",@"MessageViewController",@"MineViewController"];
    NSArray * titles = @[@"主页",@"消息",@"我"];
    NSArray * normalImg = @[@"tab_homeUnSelect",@"tab_findUnSelect",@"tab_mineUnSelect"];
    NSArray * selectImg = @[@"tab_homeSelect",@"tab_findSelect",@"tab_mineSelect"];
    for(int i=0;i<classNames.count;i++)
    {
        Class class=NSClassFromString(classNames[i]);
        VaeBaseViewController * root=[[class alloc]init];
        [self addChildController:root title:titles[i] imageName:normalImg[i] selectedImageName:selectImg[i] navVc:[VaeNavigationController class]];
    }
}
- (void)addChildController:(UIViewController*)childController title:(NSString*)title imageName:(NSString*)imageName selectedImageName:(NSString*)selectedImageName navVc:(Class)navVc
{
    
    childController.title = title;
    childController.tabBarItem.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childController.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    // 设置一下选中tabbar文字颜色
    
    [childController.tabBarItem setTitleTextAttributes:@{ NSForegroundColorAttributeName : KCOLOR(@"#933BFF") }forState:UIControlStateSelected];
    [childController.tabBarItem setTitleTextAttributes:@{ NSForegroundColorAttributeName : KCOLOR(@"#999999") }forState:UIControlStateNormal];
    UINavigationController * nav = [[navVc alloc] initWithRootViewController:childController];
    
    [self addChildViewController:nav];
}
-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait ;
}

- (BOOL)shouldAutorotate
{
    return NO;
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    
    return UIStatusBarStyleDefault;
    
}

-(UIViewController*)childViewControllerForStatusBarStyle {
    UINavigationController * nav = self.selectedViewController;
    return nav.topViewController;
}
#pragma mark- UITabBarControllerDelegate
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    
    NSInteger index = [self.tabBar.items indexOfObject:item];
    if (self.indexFlag != index) {
        [self animationWithIndex:index];
    }else
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:TabBarRefresh object:@(index)];
    }
    
}
// 动画
- (void)animationWithIndex:(NSInteger) index {
    
    [SSLayerAnimation animationWithTabbarIndex:index type:BounceAnimation];
    self.indexFlag = index;
    
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
