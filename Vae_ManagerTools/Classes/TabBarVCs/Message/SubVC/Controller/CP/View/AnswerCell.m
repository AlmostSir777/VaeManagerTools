//
//  AnswerCell.m
//  Vae_ManagerTools
//
//  Created by mac on 2019/3/7.
//  Copyright © 2019年 闵玉辉. All rights reserved.
//

#import "AnswerCell.h"
#import "AnswerModel.h"
#define answerMaxNum 3
@interface AnswerCell()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,weak) UILabel * questionLable;
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) AnswerModel * model;
@end
@implementation AnswerCell
static NSString * ID = @"cell";
-(AnswerModel *)model
{
    if(!_model){
    _model = [AnswerModel new];
    }
return _model;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]){
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self configUI];
    }
    return self;
}
-(void)configUI{
    UILabel * questionLable = [[UILabel alloc]init];
    questionLable.numberOfLines = 0;
    questionLable.font = [UIFont systemFontOfSize:17];
    questionLable.textColor = [UIColor blackColor];
    [self.contentView addSubview:questionLable];
    self.questionLable = questionLable;
    UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.tableFooterView = [UIView new];
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;
    [tableView registerClass:[AnswerSubCell class] forCellReuseIdentifier:ID];
    [self.contentView addSubview:tableView];
    self.tableView = tableView;
    
    [self.questionLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(10.f);
        make.right.equalTo(self.contentView).offset(-10.f);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.top.equalTo(self.questionLable.mas_bottom).offset(30.f);
    }];
}
-(void)refreshModel:(AnswerModel*)model{
    self.model = model;
    //因为文本有间隔m，应该是富文本的，自己写
    self.questionLable.text = model.question;
    [self.tableView reloadData];
}
#pragma mark--tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.model.answerArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.f;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AnswerSubCell * cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    cell.model = self.model.answerArr[indexPath.row];
    __weak typeof(self) weakSelf = self;
    cell.ansBlock = ^(AnswerSubCell * _Nonnull cell) {
        NSIndexPath * indexPath = [weakSelf.tableView indexPathForCell:cell];
        [weakSelf.model.answerArr enumerateObjectsUsingBlock:^(AnswerSubModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.isSelect = idx==indexPath.row;
        }];
        [weakSelf.tableView reloadData];
        if(weakSelf.delegate&&[weakSelf.delegate respondsToSelector:@selector(answerChange:model:)]){
            [weakSelf.delegate answerChange:weakSelf model:weakSelf.model];
        }
    };
    return cell;
}
@end
@interface AnswerTopView()
@property (nonatomic,strong) NSMutableArray<UILabel *>* lableArr;
@property (nonatomic,weak) UIView * backSlider;
@property (nonatomic,weak) UIView * shadowSlider;
@property (nonatomic,assign) NSInteger index;
@end
@implementation AnswerTopView
-(NSMutableArray<UILabel *> *)lableArr
{
    if(!_lableArr){
        _lableArr = @[].mutableCopy;
    }
    return _lableArr;
}
-(instancetype)init
{
    if(self = [super init]){
        self.backgroundColor = [UIColor whiteColor];
        [self configUI];
    }
    return self;
}
-(void)configUI{
    
    for(int i=0;i<answerMaxNum;i++){
    
        UILabel * nameTipLable = [[UILabel alloc]init];
        nameTipLable.font = [UIFont systemFontOfSize:14];
        nameTipLable.text = [NSString stringWithFormat:@"Q%d",i+1];
        nameTipLable.textColor = i == 0?KCOLOR(@"#1087EA"):[UIColor grayColor];
        [self addSubview:nameTipLable];
        [self.lableArr addObject:nameTipLable];
        
    }
    UIView * backView = [UIView new];
    backView.backgroundColor = KCOLOR(@"#DEDEDE");
    backView.layer.cornerRadius = 5.f;
    backView.layer.masksToBounds = YES;
    [self addSubview:backView];
    self.backSlider = backView;
    
    UIView * shadowV = [UIView new];
    shadowV.backgroundColor = KCOLOR(@"#1087EA");
    shadowV.layer.cornerRadius = 5.f;
    shadowV.layer.masksToBounds = YES;
    [self.backSlider addSubview:shadowV];
    self.shadowSlider = shadowV;
    
    [self.backSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15.f);
        make.right.equalTo(self).offset(-15.f);
        make.top.equalTo(self).offset(55.f);
        make.height.mas_equalTo(10.f);
    }];
    [self.shadowSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backSlider);
        make.centerY.equalTo(self.backSlider);
        make.height.mas_equalTo(self.backSlider);
        make.width.mas_equalTo((ScreenWidth - 30)*(1.0/answerMaxNum));
    }];
    CGFloat space = (ScreenWidth - 30)/(answerMaxNum-1);
    [self.lableArr enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(idx == 0){
            [obj mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.backSlider.mas_top).offset(-10.f);
                make.left.equalTo(self.backSlider);
            }];
        }else if (idx == self.lableArr.count-1){
            [obj mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.backSlider.mas_top).offset(-10.f);
                make.right.equalTo(self.backSlider);
            }];
        }else
        {
            [obj mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.backSlider.mas_top).offset(-10.f);
                make.centerX.equalTo(self.backSlider.mas_left).offset(space*idx);
            }];
        }
    }];
}
-(void)refreshIndex:(NSInteger)index
{
    self.index = index;
    CGFloat page = index+1.000001f;
    [self.lableArr enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
      obj.textColor = index == idx?KCOLOR(@"#1087EA"):[UIColor grayColor];
    }];
    [self.shadowSlider mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo((ScreenWidth - 30)*(page/answerMaxNum));
    }];
    [UIView animateWithDuration:0.6f animations:^{
     [self.backSlider layoutIfNeeded];
    }];
}
@end
@interface AnswerSubCell()
@property (nonatomic,weak) UIButton * answerBtn;
@end
@implementation AnswerSubCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self configUI];
    }
    return self;
}
-(void)configUI{
    UIButton * ansBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [ansBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [ansBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    ansBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    ansBtn.layer.cornerRadius = 30.f;
    ansBtn.layer.maskedCorners = YES;
    [ansBtn addTarget:self action:@selector(ansBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:ansBtn];
    self.answerBtn = ansBtn;
    
    [self.answerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.contentView).offset(10.f);
        make.width.mas_equalTo(ScreenWidth - 80*2);
        make.height.mas_equalTo(60.f);
    }];
}
-(void)setModel:(AnswerSubModel *)model
{
    _model = model;
    [self.answerBtn setTitle:model.answer forState:UIControlStateNormal];
    [self.answerBtn setTitle:model.answer forState:UIControlStateSelected];
    self.answerBtn.backgroundColor = self.answerBtn.isSelected?KCOLOR(@"#1087EA"):[UIColor whiteColor];
    self.answerBtn.layer.borderWidth = self.answerBtn.isSelected?0.f:0.8f;
    self.answerBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;

}
-(void)ansBtnClick:(UIButton*)sender{
    sender.selected = !sender.isSelected;
    sender.backgroundColor = sender.isSelected?KCOLOR(@"#1087EA"):[UIColor whiteColor];
    sender.layer.borderWidth = sender.isSelected?0.f:0.8f;
    self.answerBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    if(self.ansBlock){
        self.ansBlock(self);
    }
}
@end
