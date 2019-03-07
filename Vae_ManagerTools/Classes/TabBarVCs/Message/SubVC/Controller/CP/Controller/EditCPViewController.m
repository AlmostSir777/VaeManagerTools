//
//  EditCPViewController.m
//  Vae_ManagerTools
//
//  Created by mac on 2019/3/5.
//  Copyright © 2019年 闵玉辉. All rights reserved.
//

#import "EditCPViewController.h"
#import "EditCPCell.h"
#import "EditCPModel.h"
@interface EditCPViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,assign) ActionType type;
@property (nonatomic,strong) EditHeaderView * headerView;
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSMutableArray <EditCPModel*>* dataArr;
@end

@implementation EditCPViewController
static NSString * ID = @"cell";
-(instancetype)initWithVCType:(ActionType)type
{
    if(self = [super init]){
        self.type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavBar];
    [self configUI];
}
-(void)setNavBar{
    if(self.type == Edit_ActionType){
       //编辑模式
        
    }else
    {
       //普通选择模式
        
    }
}
-(void)configUI{
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
#pragma mark--tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EditCPCell * cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    [cell refreshModel:self.dataArr[indexPath.row]];
    __weak typeof(self) weakSelf = self;
    cell.textChangeBlock = ^(NSString * _Nonnull text, EditCPCell * _Nonnull cell) {
    weakSelf.dataArr[indexPath.row].text = text;
    };
    [cell refreshState:self.type];
    return cell;
}
#pragma mark--lazy
-(NSMutableArray<EditCPModel *> *)dataArr
{
    if(!_dataArr){
        _dataArr = @[].mutableCopy;
        for(int i=0;i<5;i++){
            [_dataArr addObject:[EditCPModel new]];
        }
    }
    return _dataArr;
}
-(EditHeaderView *)headerView
{
    if(!_headerView){
        _headerView = [[EditHeaderView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 200.f)];
        [_headerView refreshState:self.type];
    }
    return _headerView;
}
-(UITableView *)tableView
{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[EditCPCell class] forCellReuseIdentifier:ID];
        _tableView.rowHeight = 60.f;
        _tableView.tableHeaderView = self.headerView;
        _tableView.backgroundColor = KCOLOR(@"#f6f6f6");
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
@end
