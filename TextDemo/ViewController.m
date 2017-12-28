//
//  ViewController.m
//  TextDemo
//
//  Created by 闵玉辉 on 2017/12/26.
//  Copyright © 2017年 闵玉辉. All rights reserved.
//

#import "ViewController.h"
#import "ComplainSubmitBtnView.h"
#import "AddPhotoCell.h"
#import "PubTextView.h"
#import "Config.h"
#import "Masonry.h"
#import "NSObject+BaseObject.h"
#import "NextViewController.h"
/*
 //加入宏文件
 #define MAS_SHORTHAND_GLOBALS
 #import "Masonry.h"
 */
@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic,weak) PubTextView * textView;
//图片数组
@property (nonatomic,strong) NSMutableArray * selectArr;
@property (nonatomic,weak) UICollectionView * collectionView;
@end
static NSString * ID = @"cell";
static NSString * footer = @"footer";
@implementation ViewController

-(NSMutableArray *)selectArr {
    if(_selectArr == nil){
        _selectArr = [NSMutableArray array];
        for(int i=0;i<3;i++)
        {
            [_selectArr addObject:[self imageWithColor:[UIColor redColor]]];
        }
    }return _selectArr;
}
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

- (UILabel *)labelWithTitle:(NSString *)title font:(CGFloat)font textColor:(UIColor *)color textAlignment:(NSTextAlignment)textAlignment;
{
    UILabel *label = [UILabel new];
    label.text = title ? title : @"";
    label.font = Font_Size(font);
    label.textAlignment = textAlignment ? textAlignment : NSTextAlignmentLeft;
    if ([color isKindOfClass:[UIColor class]]) {
        label.textColor = color;
    }else if ([color isKindOfClass:[NSString class]])
    {
        label.textColor = color;
    }
    return label;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"投诉";
    
    self.view.backgroundColor = KCOLOR(@"#F8F8F8");
    UILabel *lab = [self labelWithTitle:@"请详细描述事件的过程" font:13 textColor:KCOLOR(@"#333333") textAlignment:0];
    [self.view addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(80.f);
        make.left.equalTo(self.view).offset(self.sizeW(16.f));
        make.right.equalTo(self.view).offset(self.sizeW(-16.f));
    }];
    
    UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(-1, 74, ScreenWidth+2, self.sizeH(100.f))];
    whiteView.backgroundColor = White_Color;
    whiteView.layer.borderColor = KCOLOR(@"#DDDDDD").CGColor;
    whiteView.layer.borderWidth = 0.7f;
    [self.view addSubview:whiteView];
    
    PubTextView * textView = [[PubTextView alloc]init];
    textView.font = KFONT(15);
    textView.textColor = KCOLOR(@"#333333");
    textView.placeTextFont = KFONT(16);
    textView.placeText = @"请输入报修的主要事宜的详情描述";
    textView.placeTextColor = KCOLOR(@"#999999");
    [whiteView addSubview:textView];
    self.textView = textView;
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(10.f, self.sizeW(12.f), 10.f, self.sizeW(12.f)));
    }];
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = self.sizeW(5);
    layout.minimumInteritemSpacing = self.sizeW(5);
    CGFloat width = (ScreenWidth - self.sizeW(25)-self.sizeW(10))/4.0;
    layout.itemSize = CGSizeMake(width, width);
    
    UICollectionView * collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.backgroundColor = Clear_Color;
    collectionView.delegate  = self;
    collectionView.dataSource = self;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.showsVerticalScrollIndicator = NO;
    [collectionView registerClass:[AddPhotoCell class] forCellWithReuseIdentifier:ID];
    [collectionView registerClass:[ComplainSubmitBtnView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footer];
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(whiteView.mas_bottom).offset(10.f);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"下一页" style:UIBarButtonItemStylePlain target:self action:@selector(nextVC)];
}
-(void)nextVC{
    NextViewController * VC = [[NextViewController alloc]init];
    VC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:VC animated:YES];
}
#pragma mark--collection delegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.selectArr.count<8?self.selectArr.count+1:self.selectArr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AddPhotoCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    WS()
    cell.deleteBlock = ^(AddPhotoCell* cell){
        NSIndexPath * index = [weakSelf.collectionView indexPathForCell:cell];
        [weakSelf.selectArr removeObjectAtIndex:index.row];
        
        [weakSelf.collectionView performBatchUpdates:^{
            if(weakSelf.selectArr.count == 8){
                [weakSelf.collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObject:index]];
            }else{
                [weakSelf.collectionView deleteItemsAtIndexPaths:[NSArray arrayWithObject:index]];
            }
        } completion:^(BOOL finished) {
            [weakSelf.collectionView reloadData];
        }];
    };
    if(self.selectArr.count<8)
    {
        if(indexPath.row == self.selectArr.count)
        {
            cell.isShow = NO;
            cell.image = K_IMG(@"sendAdd");
        }else
        {
            cell.isShow = YES;
            cell.image = self.selectArr[indexPath.row];
        }
    }else
    {
        cell.image = self.selectArr[indexPath.row];
        cell.isShow = YES;
    }
    return cell;
}

-(UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        ComplainSubmitBtnView * footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footer forIndexPath:indexPath];
        WS()
        footerView.tapBlock = ^(){
            //发送操作
        };
        return footerView;
    }
    return nil;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(ScreenWidth, self.sizeH(140.f));
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, self.sizeW(5), 0, self.sizeW(5));
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.selectArr.count < 8&&indexPath.row == self.selectArr.count)
    {
      //添加图片
 [self.selectArr addObject:[self imageWithColor:[UIColor redColor]]];
 [self.collectionView reloadData];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
