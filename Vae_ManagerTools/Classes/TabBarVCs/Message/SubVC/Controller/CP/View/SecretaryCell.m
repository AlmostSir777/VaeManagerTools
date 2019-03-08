//
//  ecretaryCell.m
//  Vae_ManagerTools
//
//  Created by zxp on 2019/3/8.
//  Copyright © 2019年 闵玉辉. All rights reserved.
//

#import "SecretaryCell.h"
#import <YYLabel.h>
@interface SecretaryCell()
@property (nonatomic,weak) UIView * backView;
@property (nonatomic,weak) YYLabel * contentLable;
@property (nonatomic,weak) UIImageView * userImg;
@end
@implementation SecretaryCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self configUI];
    }
    return self;
}
-(void)configUI{
    UIView * backView = [UIView new];
    [self.contentView addSubview:backView];
    self.backView = backView;

    YYLabel * contentLable = [YYLabel new];
    contentLable.numberOfLines = 0;
    contentLable.font = [UIFont systemFontOfSize:13];
    contentLable.textColor = [UIColor whiteColor];
    [self.backView addSubview:contentLable];
    self.contentLable = contentLable;
    
}
-(void)refresh{
    CGFloat radius = 20; // 圆角大小
    /*
     UIRectCornerTopLeft     = 1 << 0,
     UIRectCornerTopRight    = 1 << 1,
     UIRectCornerBottomLeft  = 1 << 2,
     UIRectCornerBottomRight = 1 << 3,
     */
    UIRectCorner corner = UIRectCornerAllCorners; // 圆角位置，全部位置
    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:self.backView.bounds byRoundingCorners:corner cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.backView.bounds;
    maskLayer.path = path.CGPath;
    self.backView.layer.mask = maskLayer;
}
@end
