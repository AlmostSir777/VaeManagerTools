//
//  FourImageCell.m
//  TextDemo
//
//  Created by 闵玉辉 on 2017/12/26.
//  Copyright © 2017年 闵玉辉. All rights reserved.
//

#import "FourImageCell.h"
#import "AddPhotoCell.h"
#import "NSObject+BaseObject.h"
#import "Config.h"
#import "Masonry.h"
#import "FourImageCell.h"
@interface FourImageCell()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) NSMutableArray * dataArray;
@property (nonatomic,strong) UICollectionView * collectionView;
@end
@implementation FourImageCell
-(NSMutableArray *)dataArray
{
    if(_dataArray == nil)
    {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
 static NSString * ID = @"photo";
-(instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self configUI];
    }
    return self;
}
-(void)configUI{
    UICollectionViewFlowLayout * flow = [[UICollectionViewFlowLayout alloc]init];
    flow.minimumLineSpacing = self.sizeH(10.f);
    flow.minimumInteritemSpacing = self.sizeW(10.f);
    //    flow.sectionInset = UIEdgeInsetsMake(0, self.sizeW(20.f), 0, self.sizeW(20.f));
    CGFloat width = (ScreenWidth - self.sizeW(30+40))/4.0;
    flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flow.itemSize = CGSizeMake(width, width);
    
    UICollectionView * collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flow];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.showsVerticalScrollIndicator  = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.backgroundColor = [UIColor whiteColor];
    [collectionView registerClass:[AddPhotoCell class] forCellWithReuseIdentifier:ID];
    [self.contentView addSubview:collectionView];
    self.collectionView = collectionView;
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}
#pragma mark--delegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AddPhotoCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.isShow = NO;
    cell.image = self.dataArray[indexPath.row];
    return cell;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, self.sizeW(20), 0, self.sizeW(20.f));
}
-(void)setData:(NSArray *)data
{
    self.dataArray = [NSMutableArray arrayWithArray:data];
    [self.collectionView reloadData];
}
@end
