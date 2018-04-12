//
//  MessageViewController.m
//  Vae_ManagerTools
//
//  Created by 闵玉辉 on 2017/12/28.
//  Copyright © 2017年 闵玉辉. All rights reserved.
//

#import "MessageViewController.h"
#import "MineOrderTopView.h"
#import "MessageSubViewController.h"
@interface MessageViewController ()
<UIPageViewControllerDelegate,
UIPageViewControllerDataSource,UIScrollViewDelegate>
@property (nonatomic,weak) UIScrollView * pageScrollView;
@property (nonatomic,strong) UIPageViewController * pageViewController;
@property (nonatomic,strong) NSMutableArray * dataArrays;
@property (nonatomic,weak) MineOrderTopView * headerView;
@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"新闻资讯";
    [self prepareViewControllers];
    [self configPageViewController];
    [self makeMas];
}
-(NSMutableArray *)dataArrays {
    if(_dataArrays == nil){
        _dataArrays = [NSMutableArray array];
    }return _dataArrays;
}

-(NSInteger)currrentPage {
    if(!_currrentPage){
        _currrentPage = 0;
    }return _currrentPage;
}
-(void)configPageViewController
{
    MineOrderTopView * header = [[MineOrderTopView alloc]initWithIndex:self.currrentPage];
    WS()
    header.orderBlock = ^(NSInteger index) {
        MessageSubViewController * base = weakSelf.dataArrays[index];
        weakSelf.pageViewController.view.userInteractionEnabled = NO;
        [weakSelf.pageViewController setViewControllers:@[base] direction:index>weakSelf.currrentPage?NO:YES animated:NO completion:^(BOOL finished) {
            if(finished){
                weakSelf.currrentPage = index;
                weakSelf.pageViewController.view.userInteractionEnabled = YES;
            }
        }];
    } ;
    [self.view addSubview:header];
    self.headerView = header;
    
    UIPageViewController * pageViewController = [[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    MessageSubViewController * base = self.dataArrays[self.currrentPage];
    [pageViewController setViewControllers:@[base] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    pageViewController.delegate = self;
    pageViewController.dataSource = self;
    [self.view addSubview:
     pageViewController.view];
    [self addChildViewController:pageViewController];
    [pageViewController didMoveToParentViewController:self];
    //获取显示所有view的滚动视图
    UIScrollView *sv=pageViewController.view.subviews[0];
    sv.delegate=self;
    self.pageViewController = pageViewController;
    for (UIView *view in self.pageViewController.view.subviews) {
        if ([view isKindOfClass:[UIScrollView class]]) {
            //监听拖动手势
            self.pageScrollView = (UIScrollView *)view;
            [self.pageScrollView addObserver:self
                                  forKeyPath:@"panGestureRecognizer.state"
                                     options:NSKeyValueObservingOptionNew
                                     context:nil];
        }
    }
    
}
-(void)dealloc
{
    [self.pageScrollView removeObserver:self forKeyPath:@"panGestureRecognizer.state"];
}
//监听拖拽手势的回调
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context {
    if (((UIScrollView *)object).panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        NSLog(@"bottomSView 滑动了");
        self.headerView.userInteractionEnabled = NO;
    } else if (((UIScrollView *)object).panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        NSLog(@"结束拖拽");
        self.headerView.userInteractionEnabled =  YES;
    }
}
-(void)makeMas{
    [self.headerView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.mas_equalTo(self.sizeH(53.f));
    }];
    [self.pageViewController.view mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.headerView.mas_bottom);
    }];
}

#pragma mark--准备pageViewcontrollerde的数据
-(void)prepareViewControllers
{
    for(int i=0;i<4;i++)
    {
        MessageSubViewController * sub = [[MessageSubViewController alloc]init];
        sub.type = i;
        [self.dataArrays addObject:sub];
    }
}

#pragma mark--pageviewcontroller的代理
#pragma mark -- pageViewController的协议方法
-(UIViewController*)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSInteger index=[_dataArrays indexOfObject:viewController];
    UIScrollView *sv=self.pageViewController.view.subviews[0];
    if(index >= self.dataArrays.count-1)
    {
        return nil;
    }else
    {
        sv.bounces=YES;
    }
    
    return self.dataArrays[++index];
}

-(UIViewController*)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSInteger index=[self.dataArrays indexOfObject:viewController];
    UIScrollView *sv=self.pageViewController.view.subviews[0];
    if(index==0)
    {
        return nil;
        
    }else
    {
        
        sv.bounces=YES;
    }
    return self.dataArrays[--index];
}

//翻页成功后执行的协议方法
-(void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    self.currrentPage=[_dataArrays indexOfObject:pageViewController.viewControllers[0]];
    self.headerView.index = self.currrentPage;
    self.pageViewController.view.userInteractionEnabled = YES;
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
