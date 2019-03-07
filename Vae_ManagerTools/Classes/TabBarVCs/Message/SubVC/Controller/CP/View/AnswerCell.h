//
//  AnswerCell.h
//  Vae_ManagerTools
//
//  Created by mac on 2019/3/7.
//  Copyright © 2019年 闵玉辉. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class AnswerSubCell,AnswerModel,AnswerSubModel,AnswerCell;
@protocol AnswerDelegate <NSObject>
@optional;
-(void)answerChange:(AnswerCell*)cell model:(AnswerModel*)model;
@end
@interface AnswerCell : UICollectionViewCell
-(void)refreshModel:(AnswerModel*)model;
@property (nonatomic,assign) id <AnswerDelegate> delegate;
@end
@interface AnswerTopView : UIView
-(void)refreshIndex:(NSInteger)index;
@end
@interface AnswerSubCell : UITableViewCell
@property (nonatomic,strong) AnswerSubModel * model;
@property (nonatomic,copy) void(^ansBlock)(AnswerSubCell * cell);
@end
NS_ASSUME_NONNULL_END
