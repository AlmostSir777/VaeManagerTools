//
//  AnswerViewController.m
//  Vae_ManagerTools
//
//  Created by mac on 2019/3/7.
//  Copyright © 2019年 闵玉辉. All rights reserved.
//

#import "AnswerViewController.h"
#import "AnswerCell.h"
#import "AnswerModel.h"

@interface AnswerViewController ()<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout,
AnswerDelegate>
@property (nonatomic,weak) AnswerTopView * topView;
@property (nonatomic,weak) UICollectionView * collectionView;
@property (nonatomic,strong) NSMutableArray <AnswerModel*> * dataArray;
@property (nonatomic,weak) UIButton * nextBtn;//下一页
@property (nonatomic,weak) UIButton * lastBtn;//上一页
@property (nonatomic,assign) NSInteger currentPage;
@end

@implementation AnswerViewController
static NSString * ID = @"answer";
-(NSMutableArray<AnswerModel *> *)dataArray
{
    if(!_dataArray){
        _dataArray = @[].mutableCopy;
        
        for(int i=0;i<3;i++){
            AnswerModel * aModel = [AnswerModel new];
            if(i == 0){
                aModel.question = @"Q1:老四啥时候买车？";
                for(int j=0;j<3;j++){
                    AnswerSubModel * model = [AnswerSubModel new];
                    model.isSelect = j==0;
                    model.answer = [NSString stringWithFormat:@"%d月",j+1];
                    [aModel.answerArr addObject:model];
                }
            }else if (i == 1){
                aModel.question = @"Q2:老四啥时候订婚？";
                for(int j=0;j<4;j++){
                    AnswerSubModel * model = [AnswerSubModel new];
                    model.isSelect = j==0;
                    model.answer = [NSString stringWithFormat:@"%d月",j+7];
                    [aModel.answerArr addObject:model];
                }
            }else
            {
                aModel.question = @"Q3:老四啥时候结婚？";
                for(int j=0;j<3;j++){
                    AnswerSubModel * model = [AnswerSubModel new];
                    model.isSelect = j==0;
                    model.answer = [NSString stringWithFormat:@"%d月",j];
                    [aModel.answerArr addObject:model];
                }
            }
            [_dataArray addObject:aModel];
        }
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"答题得知己";
    self.currentPage = 0;
    [self configUI];
}
-(void)configUI{
    
    AnswerTopView * topView = [[AnswerTopView alloc]init];
    [self.view addSubview:topView];
    self.topView = topView;
    
    UICollectionViewFlowLayout * layout = [UICollectionViewFlowLayout new];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0.f;
    layout.minimumInteritemSpacing = 0.f;
    
    UICollectionView * collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.pagingEnabled = YES;
//    collectionView.scrollEnabled = NO;
    [collectionView registerClass:[AnswerCell class] forCellWithReuseIdentifier:ID];
    collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    
    UIButton * lastBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [lastBtn setTitle:@"上一页" forState:UIControlStateNormal];
    [lastBtn setTitleColor:KCOLOR(@"#1087EA") forState:UIControlStateNormal];
    lastBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [lastBtn addTarget:self action:@selector(lastPage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:lastBtn];
    self.lastBtn = lastBtn;
    
    UIButton * nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextBtn setTitle:@"下一页" forState:UIControlStateNormal];
    [nextBtn setTitleColor:KCOLOR(@"#1087EA") forState:UIControlStateNormal];
    nextBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [nextBtn addTarget:self action:@selector(nextPage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];
    self.nextBtn = nextBtn;
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(100.f);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.topView.mas_bottom);
        make.bottom.equalTo(self.view).offset(-80.f);
    }];
    
    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_centerX).offset(20.f);
        make.top.equalTo(self.collectionView.mas_bottom).offset(10.f);
    }];
    
    [self.lastBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_centerX).offset(-20.f);
        make.top.equalTo(self.collectionView.mas_bottom).offset(10.f);
    }];
}
-(void)nextPage{
    if(self.currentPage == self.dataArray.count-1)return;
    self.currentPage++ ;
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentPage inSection:0] atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
    [self.topView refreshIndex:self.currentPage];
}
-(void)lastPage{
    if(self.currentPage == 0)return;
    self.currentPage-- ;
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentPage inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    [self.topView refreshIndex:self.currentPage];
}
#pragma mark--collectionView
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(ScreenWidth, self.view.frame.size.height-180);
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AnswerCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.delegate  = self;
    [cell refreshModel:self.dataArray[indexPath.row]];
    return cell;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint point = scrollView.contentOffset;
    NSInteger index = (NSInteger)(point.x/ScreenWidth);
    if(index == self.currentPage)return;
    self.currentPage = index;
    [self.topView refreshIndex:self.currentPage];
}
-(void)answerChange:(AnswerCell *)cell model:(AnswerModel *)model
{
    NSIndexPath * indexPath = [self.collectionView indexPathForCell:cell];
    self.dataArray[indexPath.row] = model;
}
@end
