//
//  MessageCell.m
//  Vae_ManagerTools
//
//  Created by 闵玉辉 on 2018/4/9.
//  Copyright © 2018年 闵玉辉. All rights reserved.
//

#import "MessageCell.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>
#import "HorizenButton.h"
#import "NSObject+BaseObject.h"
@interface MessageCell()
@property (nonatomic,strong) MessageModel * model;
@property (nonatomic,weak) UILabel * nameLable;
@property (nonatomic,weak) UIImageView * imgV;
@property (nonatomic,weak) UIImageView * playImg;
@property (nonatomic,weak) HorizenButton * seeBtn;
@end
static NSString * ID = @"message";
@implementation MessageCell
+(instancetype)cellForTableView:(UITableView *)tableView
{
    MessageCell * cell  = [tableView dequeueReusableCellWithIdentifier:ID];
    if(!cell)
    {
        cell = [[MessageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}
+(void)registCellForTableView:(UITableView *)tableView
{
    [tableView registerClass:[self class] forCellReuseIdentifier:ID];
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self configUI];
        [self makeMas];
    }
    return self;
}
-(void)configUI{
    
    UILabel * nameLable = [[UILabel alloc]init];
    nameLable.font = [UIFont systemFontOfSize:23];
    nameLable.textColor = [UIColor blackColor];
    nameLable.numberOfLines = 2;
    [self.contentView addSubview:nameLable];
    self.nameLable = nameLable;
    
    HorizenButton * seeBtn = [HorizenButton buttonWithType:UIButtonTypeCustom];
    seeBtn.margeWidth = 8.f;
    [seeBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [seeBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateSelected];
    [seeBtn setTitle:@"99" forState:UIControlStateNormal];
     [seeBtn setTitle:@"99" forState:UIControlStateSelected];
    [seeBtn setTitleColor:[self colorConvertFromString:@"#999999"] forState:UIControlStateNormal];
    [seeBtn setTitleColor:[self colorConvertFromString:@"#666666"] forState:UIControlStateSelected];
    [self.contentView addSubview:seeBtn];
    self.seeBtn = seeBtn;
    
    UIImageView * imgV = [[UIImageView alloc]init];
    imgV.layer.cornerRadius = 4.f;
    imgV.contentMode = UIViewContentModeScaleAspectFill;
    imgV.layer.masksToBounds = YES;
    [self.contentView addSubview:imgV];
    self.imgV = imgV;
    
    UIImageView * playImg = [[UIImageView alloc]init];
    [self.imgV addSubview:playImg];
    self.playImg= playImg;
}
-(void)makeMas{
    [self.nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(self.sizeW(15.f));
        make.top.equalTo(self.contentView).offset(self.sizeH(28.f));
        make.right.equalTo(self.contentView).offset(-self.sizeW(140.f));
    }];
    
    [self.seeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLable);
        make.top.equalTo(self.nameLable.mas_bottom).offset(self.sizeH(14.f));
    }];
    
    [self.imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLable);
        make.left.equalTo(self.nameLable.mas_right).offset(self.sizeW(9.f));
        make.right.equalTo(self.contentView).offset(-self.sizeW(15.f));
        make.height.mas_equalTo(self.sizeH(84.f));
    }];
    
    [self.playImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.imgV);
    }];
}
-(void)refreshData:(MessageModel *)model
{
    self.model = model;
    self.nameLable.text = model.title;
    self.seeBtn.selected = model.isSee;
    [self.seeBtn setTitle:[NSString stringWithFormat:@"%zd",model.seeNum] forState:UIControlStateNormal];
     [self.seeBtn setTitle:[NSString stringWithFormat:@"%zd",model.seeNum] forState:UIControlStateSelected];
    [self.imgV sd_setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:nil];
    self.playImg.hidden = NO;
    switch (model.cellType) {
        case Photo_MessageCellType:
            {
                //图文
                self.playImg.hidden = YES;
            }
            break;
        case Video_MessageCellType:
        {
            //视频
            self.playImg.image = [UIImage imageNamed:@"video"];
        }
            break;
        case Voice_MessageCellType:
        {
            //视频
            self.playImg.image = [UIImage imageNamed:@"voice"];
        }
            break;
        default:
            break;
    }
}
-(UIColor*)colorConvertFromString:(NSString*)value{
    if([value length]<7)return [UIColor whiteColor];
    
    SEL blackSel = NSSelectorFromString(value);
    if ([UIColor respondsToSelector: blackSel]){
        UIColor* color  = [UIColor performSelector:blackSel];
        if(color!=nil)
            return color;
    }
    
    NSRange range;
    range.location=1;
    range.length=2;
    NSString* r=[NSString stringWithFormat:@"0x%@",[value substringWithRange:range]];
    range.location=3;
    NSString* g=[NSString stringWithFormat:@"0x%@",[value substringWithRange:range]];
    range.location=5;
    NSString* b=[NSString stringWithFormat:@"0x%@",[value substringWithRange:range]];
    
    
    float rColor=0;
    float gColor=0;
    float bColor=0;
    float alpha=1;
    
    [[NSScanner scannerWithString:r] scanHexFloat:&rColor];
    [[NSScanner scannerWithString:g] scanHexFloat:&gColor];
    [[NSScanner scannerWithString:b] scanHexFloat:&bColor];
    
    
    rColor=rColor / 255;
    gColor=gColor / 255;
    bColor=bColor / 255;
    
    
    if([value length]==9){
        range.location=7;
        NSString* a=[NSString stringWithFormat:@"0x%@",[value substringWithRange:range]];
        
        [[NSScanner scannerWithString:a] scanHexFloat:&alpha];
        
        alpha=alpha / 255;
    }
    
    return [UIColor colorWithRed:rColor green:gColor blue:bColor alpha:alpha];
}
@end
