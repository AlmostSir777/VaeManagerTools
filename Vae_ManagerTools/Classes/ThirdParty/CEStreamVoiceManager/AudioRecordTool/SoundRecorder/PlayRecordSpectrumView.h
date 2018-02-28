//
//  PlayRecordSpectrumView.h
//  CatEntertainment
//
//  Created by 闵玉辉 on 2018/2/1.
//  Copyright © 2018年 闵玉辉. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayRecordSpectrumView : UIView

@property (nonatomic) NSUInteger numberOfItems;

@property (nonatomic) UIColor * itemColor;

@property (nonatomic) CGFloat level;
-(void)startTimeWithAllLeves:(NSArray*)leves;
-(void)startTimter;
-(void)endDisLink;
@end
