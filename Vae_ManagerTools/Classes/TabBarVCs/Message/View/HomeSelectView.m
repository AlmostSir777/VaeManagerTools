

//
//  HomeSelectView.m
//  CatEntertainment
//
//  Created by 闵玉辉 on 2017/10/10.
//  Copyright © 2017年 闵玉辉. All rights reserved.
//

#import "HomeSelectView.h"
@interface HomeSelectView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic,weak) UICollectionView * collectionView;
@property (nonatomic,strong) NSMutableArray <HomeSelectModel*> * dataArray;
@property (nonatomic,assign) NSInteger selectIndex;
@property (nonatomic,weak) UILabel * line;
@property (nonatomic,weak) UILabel * sliderLable;

@property (nonatomic,weak) UILabel *  line2;
@end
@implementation HomeSelectView
-(NSMutableArray<HomeSelectModel *> *)dataArray
{
    if(_dataArray == nil)
    {
        _dataArray = [NSMutableArray array];
        NSArray * titleArray = @[@"推荐",@"文娱",@"生活",@"视频",@"音乐"];
        [titleArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            HomeSelectModel * model = [[HomeSelectModel alloc]init];
            model.name = obj;
            model.isSelect = idx == 0?YES:NO;
            [_dataArray addObject:model];
        }];
    }
    return _dataArray;
}
-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
      if(self = [super initWithReuseIdentifier:reuseIdentifier])
      {
          self.index = 0;
          self.contentView.backgroundColor = [UIColor whiteColor];
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
    layout.itemSize = CGSizeMake(ScreenWidth/6.f, 39.f);
    
    UICollectionView * collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.scrollEnabled = NO;
    collectionView.delegate = self;
    collectionView.dataSource = self;
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
        make.top.equalTo(self).offset(0.8);
        make.left.right.equalTo(self);
        make.bottom.equalTo(self).offset(-3.f);
    }];
    
    [self.line  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(0.8);
    }];
//    [self.line2  mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.top.right.equalTo(self);
//        make.height.mas_equalTo(0.8);
//    }];
    CGFloat x = ScreenWidth/12.0;
    [self.sliderLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(x-15.5);
        make.bottom.equalTo(self);
        make.height.mas_equalTo(3.f);
        make.width.mas_equalTo(31.f);
    }];
    
}
-(void)setIndex:(NSInteger)index
{
    _index = index;
    
    [self.dataArray enumerateObjectsUsingBlock:^(HomeSelectModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.isSelect = index == idx?YES:NO;
    }];
    CGFloat x = ScreenWidth/12.0;
    [self.sliderLable mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo((index*x*2)+ x-15.5);
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
      if(self.selectBlock)
      {
          if(self.dataArray[indexPath.row].isSelect)return;
          self.selectBlock(indexPath.row);
          self.index = indexPath.row;
      }
}
@end
@implementation HomeSelectModel
@end
@interface HomeSelectCell()
@property (nonatomic,weak) UILabel * nameLable;
@end
@implementation HomeSelectCell
-(instancetype)initWithFrame:(CGRect)frame
{
     if(self = [super initWithFrame:frame])
     {
         UILabel * nameLable = [[UILabel alloc]init];
         nameLable.font = KFONT(15);
         nameLable.textAlignment = NSTextAlignmentCenter;
         [self.contentView addSubview:nameLable];
         self.nameLable = nameLable;
         [self.nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
             make.edges.equalTo(self.contentView);
         }];
     }
    return self;
}
-(void)setModel:(HomeSelectModel *)model
{
    _model = model;
    self.nameLable.textColor = model.isSelect?KCOLOR(@"#F7634D"):KCOLOR(@"#333333");
    self.nameLable.font =model.isSelect?[UIFont boldSystemFontOfSize:20]:[UIFont systemFontOfSize:20];
    self.nameLable.text = model.name;
    
}
@end
