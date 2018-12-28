//
//  MessageSubViewController.m
//  Vae_ManagerTools
//
//  Created by 闵玉辉 on 2018/4/9.
//  Copyright © 2018年 闵玉辉. All rights reserved.
//

#import "MessageSubViewController.h"
#import "MessageModel.h"
#import "MessageCell.h"
#import <Masonry.h>
#import "TestViewController.h"
@interface MessageSubViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,weak) UITableView * tableView;
@property (nonatomic,strong) NSMutableArray <MessageModel*>* dataArray;
@end

@implementation MessageSubViewController
-(NSMutableArray<MessageModel *> *)dataArray
{
    if(!_dataArray)
    {
        _dataArray = @[].mutableCopy;
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self configUI];
    [self loadData];
}
-(void)configUI{
    UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = self.sizeH(143.f);
    tableView.separatorColor = [UIColor lightGrayColor];
    tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [MessageCell registCellForTableView:tableView];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
-(void)loadData{
    NSInteger index = arc4random()%20;
    if(index<10){
        index+=10;
    }
    NSArray * title = @[@"台湾哈USA的撒的健康卡私搭乱建暗示健康的卡萨科技的金卡是可敬的就撒",@"印度的撒进口量达科技了圣诞节卡数据库的空间拉斯科技来得及卡拉斯科技",@"非洲的撒打算的哈萨克李稻葵就拉上来看佳都科技爱神的箭卡几十块的空间拉伸"];
    NSArray *   list = @[@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1522675350757&di=20b0be10e453658d7a77d8e39d466f63&imgtype=0&src=http%3A%2F%2Fimg5.xiazaizhijia.com%2Fwalls%2F20160708%2F1440x900_2f172c09d079701.jpg",
                         @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1522675350753&di=0165c34ba3b983a0e2429afda3930bcf&imgtype=0&src=http%3A%2F%2Fpic1.win4000.com%2Fwallpaper%2F2017-12-19%2F5a387cb8439ea.jpg",
                         @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1522675373088&di=a4a66c00b95dbba8039d3a89336b45eb&imgtype=0&src=http%3A%2F%2Fimg5.zdface.com%2F006yCHQygy1fjdkv231doj30jg0t6ju1.jpg",
                         @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1522675414077&di=5771347881981c4d8afda27b2b87708f&imgtype=0&src=http%3A%2F%2Fpic1.win4000.com%2Fwallpaper%2F2017-10-14%2F59e1bb9f01314.jpg",
                         @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1522675466479&di=f1693149d674e28ac90b26fc2ddfb248&imgtype=jpg&src=http%3A%2F%2Fimg3.imgtn.bdimg.com%2Fit%2Fu%3D1390586188%2C150083133%26fm%3D214%26gp%3D0.jpg"];
    for(int i=0;i<index;i++)
    {
        MessageModel * model = [[MessageModel alloc]init];
        model.title = title[i%3];
        model.imgUrl = list[i%5];
        model.cellType = i%3;
        model.isSee = i%2;
        model.seeNum = 100+i;
        [self.dataArray addObject:model];
    }
    [self.tableView reloadData];
}
#pragma mark--tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageCell * cell = [MessageCell cellForTableView:tableView];
    [cell refreshData:self.dataArray[indexPath.row]];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UINavigationController * nav = g_App.tabBarVC.selectedViewController;
    TestViewController * vc = [[TestViewController alloc]init];
    [nav pushViewController:vc animated:YES];
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
