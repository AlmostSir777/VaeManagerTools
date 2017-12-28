//
//  AddPhotoCell.h
//  CatEntertainment
//
//  Created by Hy on 2017/11/4.
//  Copyright © 2017年 闵玉辉. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddPhotoCell;
typedef void(^DeleteImgBlock)(AddPhotoCell* cell);

@interface AddPhotoCell : UICollectionViewCell

@property (nonatomic,copy) DeleteImgBlock deleteBlock;
@property (nonatomic,strong) UIImage * image;
@property (nonatomic,assign) BOOL isShow;

@property (nonatomic,copy) NSString * imgUrl;


@property (nonatomic,weak) UIImageView * imgView;

@end
