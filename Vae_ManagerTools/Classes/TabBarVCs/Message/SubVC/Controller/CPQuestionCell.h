//
//  CPQuestionCell.h
//  Vae_ManagerTools
//
//  Created by mac on 2019/3/4.
//  Copyright © 2019年 闵玉辉. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@class CPQuestionCell,CPQuestionModel;
@interface CPQuestionCell : UITableViewCell
@property (nonatomic,copy) void(^selectBlock)(CPQuestionCell*cell);
-(void)refreshModel:(CPQuestionModel*)model;
@end
@interface CPQuestionHeaderView : UITableViewHeaderFooterView

@end
@interface CPQuestionFooterView : UITableViewHeaderFooterView
@property (nonatomic,copy) void(^addBlock)(void);
@end
NS_ASSUME_NONNULL_END
