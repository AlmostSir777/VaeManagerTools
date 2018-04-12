//
//  MessageCell.h
//  Vae_ManagerTools
//
//  Created by 闵玉辉 on 2018/4/9.
//  Copyright © 2018年 闵玉辉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageModel.h"
@interface MessageCell : UITableViewCell
+(instancetype)cellForTableView:(UITableView*)tableView;
+(void)registCellForTableView:(UITableView*)tableView;
-(void)refreshData:(MessageModel*)model;
@end
