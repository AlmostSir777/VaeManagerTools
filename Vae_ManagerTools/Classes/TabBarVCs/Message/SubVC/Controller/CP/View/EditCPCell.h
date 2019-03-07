//
//  EditCPCell.h
//  Vae_ManagerTools
//
//  Created by mac on 2019/3/5.
//  Copyright © 2019年 闵玉辉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditCPViewController.h"
NS_ASSUME_NONNULL_BEGIN
@class EditCPCell,EditCPModel;
@interface EditCPCell : UITableViewCell
@property (nonatomic,copy) void(^textChangeBlock)(NSString*text,EditCPCell * cell);
@property (nonatomic,copy) void(^textFieldBeginBlock)(UITextField*textField,EditCPCell * cell);
-(void)refreshModel:(EditCPModel*)model;
-(void)refreshState:(ActionType)type;
@end
@interface EditHeaderView : UIView
-(NSString*)text;
-(void)refreshState:(ActionType)type;
@end
NS_ASSUME_NONNULL_END
