//
//  NextViewController.m
//  TextDemo
//
//  Created by 闵玉辉 on 2017/12/26.
//  Copyright © 2017年 闵玉辉. All rights reserved.
//

#import "NextViewController.h"
#import "Masonry.h"
#import "Config.h"
#import "NSObject+BaseObject.h"
#import "AddPhotoCell.h"
#import "FourImageCell.h"
@interface NextViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
>
@property (nonatomic,weak) UICollectionView * collectionView;
@property (nonatomic,strong) NSMutableArray * dataArray;
@property (nonatomic,strong) UIPageControl * pageController;

@property (nonatomic,assign) BOOL jk_isContentViewScrolling;
@property (nonatomic,assign) BOOL didEndDecelerating;
@property (nonatomic,assign) NSInteger jk_currentIndex;
@end

@implementation NextViewController
- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
- (UIPageControl *)pageController{
    if (!_pageController) {
        _pageController = [[UIPageControl alloc]init];
        _pageController.numberOfPages = 1;
        _pageController.hidesForSinglePage = YES;

        _pageController.backgroundColor = [UIColor clearColor];
        _pageController.currentPageIndicatorTintColor = [UIColor redColor];
        _pageController.pageIndicatorTintColor = [UIColor darkGrayColor];
        _pageController.userInteractionEnabled = YES;
        _pageController.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        [_pageController addTarget:self action:@selector(handlePageControlTapAction) forControlEvents:UIControlEventTouchUpInside];
    }return _pageController;
}
- (void)handlePageControlTapAction {
    [self.collectionView setContentOffset:CGPointMake(self.pageController.currentPage * self.collectionView.bounds.size.width, 0) animated:YES];
}
-(NSMutableArray *)dataArray
{
    if(_dataArray == nil)
    {
        _dataArray = [NSMutableArray array];
        for(int i=0;i<4;i++)
        {
            NSMutableArray * data = [NSMutableArray array];
            for(int i=0;i<4;i++)
            {
                [data addObject:[self imageWithColor:[UIColor redColor]]];
            }
            [_dataArray addObject:data];
        }
    }
    return _dataArray;
}
 static NSString * ID = @"four";
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UICollectionViewFlowLayout * flow = [[UICollectionViewFlowLayout alloc]init];
    flow.minimumLineSpacing = self.sizeH(0.f);
    flow.minimumInteritemSpacing = self.sizeW(0.f);
//    flow.sectionInset = UIEdgeInsetsMake(0, self.sizeW(20.f), 0, self.sizeW(20.f));
    CGFloat width = (ScreenWidth - self.sizeW(30+40))/4.0;
    flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flow.itemSize = CGSizeMake(ScreenWidth, width);
    
    UICollectionView * collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flow];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.showsVerticalScrollIndicator  = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.pagingEnabled = YES;
    [collectionView registerClass:[FourImageCell class] forCellWithReuseIdentifier:ID];
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(width);
        make.top.equalTo(self.view).offset(self.sizeH(100.f));
    }];
    [self.collectionView reloadData];
    
    [self.view addSubview:self.pageController];
    
    
    [self.pageController mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.collectionView.mas_bottom).offset(10.f);
        make.height.mas_equalTo(40.f);
        make.width.mas_equalTo(ScreenWidth);
        make.centerX.equalTo(self.view);
    }];
    self.pageController.numberOfPages = self.dataArray.count;
    self.pageController.currentPage = 0;
    self.pageController.hidden = self.dataArray.count>1?NO:YES;
}
#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    _jk_isContentViewScrolling = YES;
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    _jk_isContentViewScrolling = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    self.didEndDecelerating = YES;
    _jk_isContentViewScrolling = NO;
    [self scrollViewObservedDidChangePageWithOffsetX:scrollView.contentOffset.x];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    self.didEndDecelerating = NO;
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (!self.didEndDecelerating) {
        CGFloat index = scrollView.contentOffset.x/ScreenWidth;
        [self scrollViewObservedDidChangePageWithOffsetX:roundf(index)*ScreenWidth];
    }
}

- (void)scrollViewObservedDidChangePageWithOffsetX:(CGFloat)offsetX{
    self.jk_currentIndex   = (NSInteger)(offsetX / ScreenWidth);
    self.pageController.currentPage = self.jk_currentIndex;
}

#pragma mark--delegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
        return self.dataArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FourImageCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    [cell setData:self.dataArray[indexPath.row]];
    return cell;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0,0, 0, 0);
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
