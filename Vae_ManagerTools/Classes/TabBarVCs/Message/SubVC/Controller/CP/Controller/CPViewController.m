//
//  CPViewController.m
//  Vae_ManagerTools
//
//  Created by mac on 2019/3/4.
//  Copyright © 2019年 闵玉辉. All rights reserved.
//

#import "CPViewController.h"
#import "CPQuestionCell.h"
#import "CPQuestionModel.h"
#import "EditCPViewController.h"
#define backColor  KCOLOR(@"#F6F6F6")
@interface CPViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSMutableArray <NSMutableArray<CPQuestionModel*>*>* dataArray;
@end

@implementation CPViewController
static NSString * ID = @"cell";
static NSString * head = @"head";
static NSString * foot = @"foot";
-(UITableView *)tableView
{
    if(!_tableView){
       
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 60.f;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[CPQuestionCell class] forCellReuseIdentifier:ID];
        [_tableView registerClass:[CPQuestionHeaderView class] forHeaderFooterViewReuseIdentifier:head];
        [_tableView registerClass:[CPQuestionFooterView class] forHeaderFooterViewReuseIdentifier:foot];
    }
    return _tableView;
}
-(NSMutableArray<NSMutableArray<CPQuestionModel *> *> *)dataArray
{
    if(!_dataArray){
        _dataArray = @[].mutableCopy;
        NSMutableArray * data1 = @[].mutableCopy;
        NSMutableArray * data2 = @[].mutableCopy;
        for(int i=0;i<3;i++){
            CPQuestionModel * model = [CPQuestionModel new];
            model.title = @"女朋友姨妈痛怎么办？";
            model.isSelect = arc4random()%2;
            [data1 addObject:model];
        }
        for(int i=0;i<6;i++){
            CPQuestionModel * model = [CPQuestionModel new];
            model.title = @"女朋友姨妈痛怎么办？";
            model.isSelect = arc4random()%2;
            [data2 addObject:model];
        }
        [_dataArray addObject:data1];
        [_dataArray addObject:data2];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"出题组CP";
    self.view.backgroundColor = [UIColor whiteColor];
    [self configUI];
}
-(void)configUI{
    self.tableView.backgroundColor = backColor;
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
#pragma mark--Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray[section].count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return section==1?0.001:50.f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section==0?0.001:50.f;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CPQuestionCell * cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    [cell refreshModel:self.dataArray[indexPath.section][indexPath.row]];
    __weak typeof(self) weakSelf = self;
    cell.selectBlock = ^(CPQuestionCell * _Nonnull cell) {
        NSIndexPath * indexPath = [weakSelf.tableView indexPathForCell:cell];
        weakSelf.dataArray[indexPath.section][indexPath.row].isSelect = !weakSelf.dataArray[indexPath.section][indexPath.row].isSelect;
    };
    cell.contentView.backgroundColor = backColor;
    return cell;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section == 0)return [UIView new];
    CPQuestionHeaderView * header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:head];
    if(!header){
        header = [[CPQuestionHeaderView alloc]initWithReuseIdentifier:head];
    }
    header.contentView.backgroundColor = backColor;
    return header;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
     if(section == 1)return [UIView new];
    CPQuestionFooterView * footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:foot];
    if(!footer){
        footer = [[CPQuestionFooterView alloc]initWithReuseIdentifier:foot];
    }
    __weak typeof(self) weakSelf = self;
    footer.addBlock = ^{
    [weakSelf gotoSubVC];
    };
    footer.contentView.backgroundColor = backColor;
    return footer;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EditCPViewController * VC = [[EditCPViewController alloc]initWithVCType:Select_ActionType];
    [self.navigationController pushViewController:VC animated:YES];
}
-(void)gotoSubVC{
    EditCPViewController * VC = [[EditCPViewController alloc]initWithVCType:Edit_ActionType];
    [self.navigationController pushViewController:VC animated:YES];
}
@end
