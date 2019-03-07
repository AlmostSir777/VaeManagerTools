//
//  CPQuestionCell.m
//  Vae_ManagerTools
//
//  Created by mac on 2019/3/4.
//  Copyright © 2019年 闵玉辉. All rights reserved.
//

#import "CPQuestionCell.h"
#import "CPQuestionModel.h"
@interface CPQuestionCell()
@property (nonatomic,weak) UIView * backView;
@property (nonatomic,weak) UIButton * selectBtn;
@property (nonatomic,weak) UILabel * descLable;
@property (nonatomic,weak) UIImageView * rightImg;
@property (nonatomic,strong) CPQuestionModel * model;
@end
@implementation CPQuestionCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
//        self.contentView.backgroundColor = [UIColor colorWithRGBAColorRed:246/255.f green:246/255.f blue:246/255.f alpha:1.f];
        [self configUI];
    }
    return self;
}
-(void)configUI{
    
    UIView * backView  = [UIView new];
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.cornerRadius = 22.5f;
    [self.contentView addSubview:backView];
    self.backView = backView;
    
    UIButton * selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [selectBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateSelected];
    [selectBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.backView addSubview:selectBtn];
    self.selectBtn = selectBtn;
    
    UILabel * desc = [UILabel new];
    desc.font = [UIFont systemFontOfSize:14];
    desc.textColor = [UIColor blackColor];
    [self.backView addSubview:desc];
    self.descLable = desc;
    
    UIImageView * rightImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@""]];
    [self.backView addSubview:rightImg];
    self.rightImg = rightImg;
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(6, 6, 6, 6));
    }];
    
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backView).offset(6.f);
        make.centerY.equalTo(self.backView);
        make.size.mas_equalTo(CGSizeMake(30, 30)); //可以不用设置，有图自适应
    }];
    
    [self.rightImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.backView);
        make.right.equalTo(self.backView).offset(-10.f);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    
    [self.descLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.selectBtn.mas_right).offset(6.f);
        make.centerY.equalTo(self.backView);
        make.right.equalTo(self.rightImg.mas_left).offset(-8.f).priorityLow();
    }];
    
    self.selectBtn.backgroundColor = [UIColor redColor];
    self.rightImg.backgroundColor = [UIColor redColor];
}
-(void)btnClick:(UIButton*)sender{
    sender.selected = !sender.isSelected;
    if(self.selectBlock){
        self.selectBlock(self);
    }
}
-(void)refreshModel:(CPQuestionModel *)model
{
    self.model = model;
    self.selectBtn.selected = model.isSelect;
    self.descLable.text = model.title;
}
@end

@interface CPQuestionHeaderView()
@property (nonatomic,weak) UIImageView * leftImgV;
@property (nonatomic,weak) UILabel * nameLable;
@end
@implementation CPQuestionHeaderView
-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithReuseIdentifier:reuseIdentifier]){
//        self.contentView.backgroundColor =   [UIColor colorWithRGBAColorRed:247/255.f green:247/255.f blue:247/255.f alpha:1.f];
        [self configUI];
    }
    return self;
}
-(void)configUI{
    UIImageView * leftimgV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@""]];
    [self.contentView addSubview:leftimgV];
    self.leftImgV = leftimgV;
    
    UILabel * namelable = [UILabel new];
    namelable.font = [UIFont systemFontOfSize:14];
    namelable.textColor = [UIColor blackColor];
    [self.contentView addSubview:namelable];
    self.nameLable = namelable;
    
    [self.leftImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(8.f);
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    
    [self.nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.leftImgV);
        make.left.equalTo(self.leftImgV.mas_right).offset(8.f);
    }];
    
    self.leftImgV.backgroundColor = [UIColor redColor];
    self.nameLable.text = @"风骚程序，在线出题";
}

@end

@interface CPQuestionFooterView()
@property (nonatomic,weak) UIControl * backView;
@property (nonatomic,weak) UIButton * addBtn;
@end
@implementation CPQuestionFooterView

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithReuseIdentifier:reuseIdentifier]){
//        self.contentView.backgroundColor =   [UIColor colorWithRGBAColorRed:246/255.f green:246/255.f blue:246/255.f alpha:1.f];
        [self configUI];
    }
    return self;
}
-(void)configUI{
    UIControl * view = [[UIControl alloc]init];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.cornerRadius = 22.5;
    view.layer.masksToBounds = YES;
    [view addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:view];
    self.backView = view;
    
    UIButton * addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [addBtn setTitle:@"    成为出题人" forState:UIControlStateNormal];
    addBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [addBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.backView addSubview:addBtn];
    self.addBtn = addBtn;
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).offset(UIEdgeInsetsMake(4, 30, 4, 30));
    }];
    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.backView);
    }];
    
}
-(void)addBtnClick{
    if(self.addBlock){
        self.addBlock();
    }
}
@end
