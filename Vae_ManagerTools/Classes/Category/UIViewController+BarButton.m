//
//  ZTNavigationViewController.h
//  ZTNavigationItem
//
//  Created by ZT on 2017/10/31.
//  Copyright © 2017年 ZT. All rights reserved.
//

#import "UIViewController+BarButton.h"

#define kScreenWidth  ([UIScreen mainScreen].bounds.size.width)
#define kScreenHeight  ([UIScreen mainScreen].bounds.size.height)
#define kBlackColor     [UIColor blackColor]

@implementation UIViewController (BarButton)

- (void)addLeftBarButtonWithImage:(UIImage *)image action:(SEL)action
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    view.backgroundColor = [UIColor clearColor];
    UIButton *firstButton = [UIButton buttonWithType:UIButtonTypeCustom];
    firstButton.frame = CGRectMake(0, 0, 44, 44);
    [firstButton setImage:image forState:UIControlStateNormal];
    [firstButton addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    firstButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [firstButton setImageEdgeInsets:UIEdgeInsetsMake(0, 5 * kScreenWidth / 375.0, 0, 0)];
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:firstButton];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}

- (void)addRightBarButtonWithFirstImage:(UIImage *)firstImage action:(SEL)action
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    view.backgroundColor = [UIColor clearColor];
    
    UIButton *firstButton = [UIButton buttonWithType:UIButtonTypeCustom];
    firstButton.frame = CGRectMake(0, 0, 44, 44);
    [firstButton setImage:firstImage forState:UIControlStateNormal];
    [firstButton addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    firstButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [firstButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5 * kScreenWidth / 375.0)];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:firstButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

- (void)addLeftBarButtonItemWithTitle:(NSString *)itemTitle action:(SEL)action
{
    UIButton *leftbBarButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [leftbBarButton setTitle:itemTitle forState:(UIControlStateNormal)];
    [leftbBarButton setTitleColor:kBlackColor forState:(UIControlStateNormal)];
    leftbBarButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [leftbBarButton addTarget:self action:action forControlEvents:(UIControlEventTouchUpInside)];
    leftbBarButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [leftbBarButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 5 * kScreenWidth/375.0, 0, 0)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftbBarButton];
}

- (void)addRightBarButtonItemWithTitle:(NSString *)itemTitle action:(SEL)action
{
    
    UIButton *rightbBarButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 88, 44)];
    [rightbBarButton setTitle:itemTitle forState:(UIControlStateNormal)];
    [rightbBarButton setTitleColor:kBlackColor forState:(UIControlStateNormal)];
    rightbBarButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightbBarButton addTarget:self action:action forControlEvents:(UIControlEventTouchUpInside)];
    rightbBarButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rightbBarButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5 * kScreenWidth/375.0)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightbBarButton];
}

- (void)addRightTwoBarButtonsWithFirstImage:(UIImage *)firstImage firstAction:(SEL)firstAction secondImage:(UIImage *)secondImage secondAction:(SEL)secondAction
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
    view.backgroundColor = [UIColor clearColor];
    
    UIButton *firstButton = [UIButton buttonWithType:UIButtonTypeCustom];
    firstButton.frame = CGRectMake(40, 0, 40, 44);
    [firstButton setImage:firstImage forState:UIControlStateNormal];
    [firstButton addTarget:self action:firstAction forControlEvents:UIControlEventTouchUpInside];
    firstButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [firstButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, - 8 * kScreenWidth/375.0)];
    [view addSubview:firstButton];
    
    UIButton *secondButton = [UIButton buttonWithType:UIButtonTypeCustom];
    secondButton.frame = CGRectMake(0, 0, 40, 44);
    [secondButton setImage:secondImage forState:UIControlStateNormal];
    [secondButton addTarget:self action:secondAction forControlEvents:UIControlEventTouchUpInside];
    secondButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [secondButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, - 15 * kScreenWidth/375.0)];
    [view addSubview:secondButton];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

- (void)addRightThreeBarButtonsWithFirstImage:(UIImage *)firstImage firstAction:(SEL)firstAction secondImage:(UIImage *)secondImage secondAction:(SEL)secondAction thirdImage:(UIImage *)thirdImage thirdAction:(SEL)thirdAction
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 44)];
    view.backgroundColor = [UIColor clearColor];
    
    UIButton *firstButton = [UIButton buttonWithType:UIButtonTypeCustom];
    firstButton.frame = CGRectMake(80, 0, 40, 44);
    [firstButton setImage:firstImage forState:UIControlStateNormal];
    [firstButton addTarget:self action:firstAction forControlEvents:UIControlEventTouchUpInside];
    firstButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [firstButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, - 8 * kScreenWidth/375.0)];
    [view addSubview:firstButton];
    
    UIButton *secondButton = [UIButton buttonWithType:UIButtonTypeCustom];
    secondButton.frame = CGRectMake(44, 0, 40, 44);
    [secondButton setImage:secondImage forState:UIControlStateNormal];
    [secondButton addTarget:self action:secondAction forControlEvents:UIControlEventTouchUpInside];
    secondButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [secondButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, - 5 * kScreenWidth/375.0)];
    [view addSubview:secondButton];
    
    UIButton *thirdButton = [UIButton buttonWithType:UIButtonTypeCustom];
    thirdButton.frame = CGRectMake(0, 0, 40, 44);
    [thirdButton setImage:thirdImage forState:UIControlStateNormal];
    [thirdButton addTarget:self action:thirdAction forControlEvents:UIControlEventTouchUpInside];
    [thirdButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, - 5 * kScreenWidth/375.0)];
    [view addSubview:thirdButton];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
}

- (void)addRightFourBarButtonsWithFirstImage:(UIImage *)firstImage firstAction:(SEL)firstAction secondImage:(UIImage *)secondImage secondAction:(SEL)secondAction thirdImage:(UIImage *)thirdImage thirdAction:(SEL)thirdAction fourthImage:(UIImage *)fourthImage fourthAction:(SEL)fourthAction{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 145, 44)];
    view.backgroundColor = [UIColor clearColor];
    
    UIButton *firstButton = [UIButton buttonWithType:UIButtonTypeCustom];
    firstButton.frame = CGRectMake(110, 6, 30, 30);
    [firstButton setImage:firstImage forState:UIControlStateNormal];
    [firstButton addTarget:self action:firstAction forControlEvents:UIControlEventTouchUpInside];
    firstButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [firstButton setImageEdgeInsets:UIEdgeInsetsMake(0, 8 * kScreenWidth/375.0, 0, 0)];
    [view addSubview:firstButton];
    
    UIButton *secondButton = [UIButton buttonWithType:UIButtonTypeCustom];
    secondButton.frame = CGRectMake(80, 6, 30, 30);
    [secondButton setImage:secondImage forState:UIControlStateNormal];
    [secondButton addTarget:self action:secondAction forControlEvents:UIControlEventTouchUpInside];
    secondButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [secondButton setImageEdgeInsets:UIEdgeInsetsMake(0, 8 * kScreenWidth/375.0, 0, 0)];
    [view addSubview:secondButton];
    
    UIButton *thirdButton = [UIButton buttonWithType:UIButtonTypeCustom];
    thirdButton.frame = CGRectMake(50, 6, 30, 30);
    [thirdButton setImage:thirdImage forState:UIControlStateNormal];
    thirdButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [thirdButton setImageEdgeInsets:UIEdgeInsetsMake(0, 8 * kScreenWidth/375.0, 0, 0)];
    [thirdButton addTarget:self action:thirdAction forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:thirdButton];
    
    UIButton *fourthButton = [UIButton buttonWithType:UIButtonTypeCustom];
    fourthButton.frame = CGRectMake(15, 6, 30, 30);
    [fourthButton setImage:fourthImage forState:UIControlStateNormal];
    [fourthButton addTarget:self action:fourthAction forControlEvents:UIControlEventTouchUpInside];
    fourthButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [fourthButton setImageEdgeInsets:UIEdgeInsetsMake(0, 8 * kScreenWidth/375.0, 0, 0)];
    [view addSubview:fourthButton];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
}
#pragma mark--设置导航栏按钮
-(UIButton*)setNavButtonImageName:(NSString *)imageName andIsLeft:(BOOL)isLeft andTarget:(id)target andAction:(SEL)selector
{
    self.view.contentMode = UIViewContentModeBottom;
    UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(0, 0, 40, 40);
    btn.showsTouchWhenHighlighted = YES;
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [btn setContentHorizontalAlignment:isLeft?UIControlContentHorizontalAlignmentLeft:UIControlContentHorizontalAlignmentRight];
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * item=[[UIBarButtonItem alloc]initWithCustomView:btn];
    if(isLeft)
    {
        
        if([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0)
            
        {
            UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                           target:nil action:nil];
            negativeSpacer.width = -10;//这个数值可以根据情况自由变化
            self.navigationItem.leftBarButtonItems = @[negativeSpacer, item];
        }else{
            self.navigationItem.leftBarButtonItem = item ;
        }
        
    }else
    {
        if([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0)
            
        {
            UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                           target:nil action:nil];
            negativeSpacer.width = -NAVIBARWIDE;//这个数值可以根据情况自由变化
            self.navigationItem.rightBarButtonItems = @[negativeSpacer, item];
        }else{
            self.navigationItem.rightBarButtonItem = item ;
        }
    }
    return btn;
}
@end
