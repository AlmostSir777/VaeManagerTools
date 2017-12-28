//
//  AddPhotoCell.m
//  CatEntertainment
//
//  Created by Hy on 2017/11/4.
//  Copyright © 2017年 闵玉辉. All rights reserved.
//

#import "AddPhotoCell.h"
#import "Masonry.h"
#import "Config.h"
@interface AddPhotoCell()

@property (nonatomic,weak) UIImageView * deleteImg;

@end

@implementation AddPhotoCell
-(instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self createUI];
        [self makeMas];
    }
    return self;
}
-(void)createUI{
    
    UIImageView * img = [[UIImageView alloc]init];
    img.contentMode = UIViewContentModeScaleAspectFill;
    img.clipsToBounds = YES;
    [self.contentView addSubview:img];
    self.imgView = img;
    
    UIImageView * deleteImg = [[UIImageView alloc]init];
    deleteImg.userInteractionEnabled = YES;
    deleteImg.image = K_IMG(@"delete");
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
    [deleteImg addGestureRecognizer:tap];
    [self.contentView addSubview:deleteImg];
    self.deleteImg = deleteImg;
    [self.contentView bringSubviewToFront:self.deleteImg];
    
}
-(void)makeMas{
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    [self.deleteImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.equalTo(self.contentView);
    }];
}
-(void)tap{
    if(self.deleteBlock)
    {
        self.deleteBlock(self);
    }
}
-(void)setImage:(UIImage *)image
{
    _image = image;
    self.imgView.image = image;
}
-(void)setIsShow:(BOOL)isShow
{
    _isShow = isShow;
    self.deleteImg.hidden = !isShow;
}


@end
