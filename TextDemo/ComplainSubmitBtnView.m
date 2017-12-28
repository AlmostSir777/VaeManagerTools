//
//  ComplainSubmitBtnView.m
//  CatEntertainment
//
//  Created by Hy on 2017/11/4.
//  Copyright © 2017年 闵玉辉. All rights reserved.
//

#import "ComplainSubmitBtnView.h"
#import "UIButton+Category.h"
#import "Masonry.h"
#import "Config.h"
#import "NSObject+BaseObject.h"
@interface ComplainSubmitBtnView()
@property (nonatomic,weak) UIButton *submitBtn;
@end

@implementation ComplainSubmitBtnView
-(instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]) {
        UIButton * nextBtn = [[UIButton alloc]init];
        [nextBtn setBackgroundColor:KCOLOR(@"#6E3BFF") forState:UIControlStateNormal];
//        nextBtn.enabled = NO;
        [nextBtn setTitle:@"提交" forState:UIControlStateNormal];
        [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [nextBtn setTitle:@"提交" forState:UIControlStateDisabled];
        [nextBtn setTitleColor:KCOLOR(@"#FFFFFF") forState:UIControlStateDisabled];
        
        nextBtn.titleLabel.font = KFONT(18);
        nextBtn.layer.cornerRadius = self.sizeW(5.f);
        nextBtn.layer.masksToBounds = YES;
        [nextBtn addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:nextBtn];
        self.submitBtn = nextBtn;

        [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.height.mas_equalTo(self.sizeH(42.f));
            make.left.equalTo(self).offset(self.sizeW(16.f));
            make.right.equalTo(self).offset(-self.sizeW(16.f));
        }];
    }
    return self;
}

-(void)submitAction{
    if(self.tapBlock) {
        self.tapBlock();
    }
}

@end

