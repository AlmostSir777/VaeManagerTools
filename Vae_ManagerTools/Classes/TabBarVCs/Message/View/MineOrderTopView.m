//
//  MineOrderTopView.m
//  CatEntertainment
//
//  Created by 闵玉辉 on 2017/10/20.
//  Copyright © 2017年 闵玉辉. All rights reserved.
//

#import "MineOrderTopView.h"
#import "HomeSelectView.h"
@interface MineOrderTopView()
<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic,weak) UICollectionView * collectionView;
@property (nonatomic,strong) NSMutableArray <HomeSelectModel*> * dataArray;
@property (nonatomic,weak) UILabel * line;
@property (nonatomic,weak) UILabel * sliderLable;
@end
@implementation MineOrderTopView
-(NSMutableArray<HomeSelectModel *> *)dataArray
{
    if(_dataArray == nil)
    {
        _dataArray = [NSMutableArray array];
        NSArray * titleArray = @[@"推荐",@"文娱",@"生活",@"视频",@"音乐"];
        [titleArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            HomeSelectModel * model = [[HomeSelectModel alloc]init];
            model.name = obj;
            model.isSelect = idx == self.selectIndex?YES:NO;
            [_dataArray addObject:model];
        }];
    }
    return _dataArray;
}
-(instancetype)initWithIndex:(NSInteger)index
{
    if(self = [super init])
    {
        self.selectIndex = index;
        [self createUI];
        [self makeMas];
        
    }
    return self;
}
static NSString * ID = @"cell";
-(void)createUI{
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.itemSize = CGSizeMake(ScreenWidth/5.f, 39.f);
    
    UICollectionView * collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.scrollEnabled = NO;
    collectionView.backgroundColor = [UIColor whiteColor];
    [collectionView registerClass:[HomeSelectCell class] forCellWithReuseIdentifier:ID];
    [self addSubview:collectionView];
    self.collectionView = collectionView;
    
    UILabel * line = [[UILabel alloc]init];
    line.backgroundColor = KCOLOR(@"#dddddd");
    [self addSubview:line];
    self.line = line;
    
    UILabel * sliderLable = [[UILabel alloc]init];
    sliderLable.backgroundColor = KCOLOR(@"#F7634D");
    [self addSubview:sliderLable];
    self.sliderLable = sliderLable;
}
-(void)makeMas{
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(39.f);
    }];
    
    [self.line  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(0.8);
    }];
    CGFloat x = ScreenWidth/10.0;
    [self.sliderLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo((self.selectIndex*x*2)+ x-[self widthForText:self.selectIndex]*0.5);
        make.width.mas_equalTo([self widthForText:self.selectIndex]);
        make.bottom.equalTo(self);
        make.height.mas_equalTo(4.f);
    }];
    [self bringSubviewToFront:self.sliderLable];
}
-(CGFloat)widthForText:(NSInteger)index
{
    return 50;
}
-(void)setIndex:(NSInteger)index
{
    _index = index;
    
    [self.dataArray enumerateObjectsUsingBlock:^(HomeSelectModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.isSelect = index == idx?YES:NO;
    }];
    CGFloat x = ScreenWidth/10.0;
    [self.sliderLable mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo((index*x*2)+ x-[self widthForText:index]*0.5);
        make.width.mas_equalTo([self widthForText:index]);
    }];
    self.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.6f animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        if(finished){
            self.userInteractionEnabled = YES;
            [self.collectionView reloadData];
        }
    }];
}
#pragma mark--collectionView delegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HomeSelectCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.orderBlock)
    {
        if(self.dataArray[indexPath.row].isSelect)return;
        self.orderBlock(indexPath.row);
        self.index = indexPath.row;
    }
}
@end
