//
//  VaeNavigationController.m
//  Vae_ManagerTools
//
//  Created by 闵玉辉 on 2017/12/28.
//  Copyright © 2017年 闵玉辉. All rights reserved.
//

#import "VaeNavigationController.h"
#import "UIBarButtonItem+Extension.h"
@interface VaeNavigationController ()

@end

@implementation VaeNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) {// 如果现在push的不是栈底控制器(最先push进来的那个控制器)
        viewController.hidesBottomBarWhenPushed = YES;
        if(@available(iOS 11.0, *))
        {
            UIButton *firstButton = [UIButton buttonWithType:UIButtonTypeCustom];
            firstButton.frame = CGRectMake(0, 0, 40, 44);
            [firstButton setImage:[UIImage imageNamed:@"back_black"] forState:UIControlStateNormal];
            [firstButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
            firstButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [firstButton setImageEdgeInsets:UIEdgeInsetsMake(0,0, 0, 0)];
            
            UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:firstButton];
            
            viewController.navigationItem.leftBarButtonItem = leftBarButtonItem;
        }else{
            UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
            negativeSpacer.width = -15;
            //设置导航栏的按钮
            UIBarButtonItem *backButton = [UIBarButtonItem itemWithImageName:@"back_black" highImageName:@"back_black" target:self action:@selector(back)];
            
            viewController.navigationItem.leftBarButtonItems =@[negativeSpacer,backButton];
        }
        // 就有滑动返回功能
        self.interactivePopGestureRecognizer.delegate = nil;
    }
  [super pushViewController:viewController animated:animated];
}
-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait ;
}

- (BOOL)shouldAutorotate
{
    return NO;
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (UIViewController *)childViewControllerForStatusBarStyle{
    return self.topViewController;
}
- (void)back {
    [self popViewControllerAnimated:YES];
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
