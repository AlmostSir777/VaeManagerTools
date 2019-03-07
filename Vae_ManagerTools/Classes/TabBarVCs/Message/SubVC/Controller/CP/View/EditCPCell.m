//
//  EditCPCell.m
//  Vae_ManagerTools
//
//  Created by mac on 2019/3/5.
//  Copyright © 2019年 闵玉辉. All rights reserved.
//

#import "EditCPCell.h"
#import "EditCPModel.h"
@interface EditCPCell()
@property (nonatomic,weak) UIView * backView;
@property (nonatomic,weak) UITextField * textField;
@property (nonatomic,weak) UILabel * placeLable;
@property (nonatomic,strong) EditCPModel * model;
@end
@implementation EditCPCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
          self.contentView.backgroundColor = KCOLOR(@"#F6F6F6");
        [self  configUI];
    }
    return self;
}
-(void)configUI{
    
    UIView * backView = [UIView new];
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.cornerRadius = 22.5;
    backView.layer.masksToBounds = YES;
    backView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    backView.layer.borderWidth = 0.8f;
    [self.contentView addSubview:backView];
    self.backView = backView;
    
    UITextField * textField = [[UITextField alloc]init];
    textField.font = [UIFont systemFontOfSize:14];
    textField.textColor = [UIColor blackColor];
    textField.textAlignment = NSTextAlignmentCenter;
    textField.placeholder = @"输入答案，最多10个字";
    [textField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [textField setValue:[UIFont systemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
     [textField setValue:@(NSTextAlignmentCenter) forKeyPath:@"_placeholderLabel.textAlignment"];
    [self.backView addSubview:textField];
    self.textField = textField;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextFieldTextDidChangeNotification object:self.textField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidBeginEditing:) name:UITextFieldTextDidBeginEditingNotification object:self.textField];
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(8, 40, 0, 40));
    }];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.backView);
        make.left.equalTo(self.backView).offset(10.f);
        make.right.equalTo(self.backView).offset(-10.f);
    }];
    
}
#pragma mark--textfield 
-(void)textDidChange:(NSNotification*)noti{
    if(self.textField.text.length>10){
        self.textField.text = [self.textField.text substringWithRange:NSMakeRange(0, 10)];
    }
    if(self.textChangeBlock){
        self.textChangeBlock(self.textField.text, self);
    }
}
-(void)textFieldDidBeginEditing:(NSNotification *)noti
{
    if(self.textFieldBeginBlock){
        self.textFieldBeginBlock(noti.object, self);
    }
}
-(void)refreshModel:(EditCPModel *)model
{
    self.model = model;
    self.textField.text = model.text;
}
-(void)refreshState:(ActionType)type
{
    self.textField.userInteractionEnabled = type==Edit_ActionType;
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
@interface EditHeaderView()
@property (nonatomic,weak) UIView * backView;
@property (nonatomic,weak) UITextView * textView;
@property (nonatomic,weak) UILabel * placeLable;
@end
@implementation EditHeaderView
-(instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = KCOLOR(@"#F6F6F6");
        [self configUI];
    }
    return self;
}
-(void)configUI{
    
    UIView * backView = [[UIView alloc]init];
    backView.backgroundColor = [UIColor whiteColor];
    [self addSubview:backView];
    self.backView = backView;
    
    UITextView * textView = [[UITextView alloc]init];
    textView.font = [UIFont systemFontOfSize:14];
    [self.backView addSubview:textView];
    self.textView = textView;
    
    UILabel * optionLable = [[UILabel alloc]init];
    optionLable.text = @"请输入你的题目，最多50个字...";
    optionLable.font = [UIFont systemFontOfSize:14];
    optionLable.textColor = [UIColor lightGrayColor];
    [self.textView addSubview:optionLable];
    self.placeLable = optionLable;
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10.f);
        make.left.right.equalTo(self);
        make.bottom.equalTo(self).offset(-10.f);
    }];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(6, 8, 6, 8));
    }];
    
    [self.placeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textView).offset(8.f);
        make.left.equalTo(self.textView).offset(4.f);
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChangeNoti:) name:UITextViewTextDidChangeNotification object:self.textView];
    
}
-(void)textChangeNoti:(NSNotification*)noti{
    self.placeLable.hidden = self.textView.text.length>0?YES:NO;
    if(self.textView.text.length>50){
        self.textView.text = [self.textView.text substringWithRange:NSMakeRange(0, 50)];
    }
}
-(NSString *)text
{
    return self.textView.text?:@"";
}
-(void)refreshState:(ActionType)type
{
    self.textView.userInteractionEnabled = type==Edit_ActionType;
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
