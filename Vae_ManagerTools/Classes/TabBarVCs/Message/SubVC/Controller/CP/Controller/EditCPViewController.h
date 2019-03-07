//
//  EditCPViewController.h
//  Vae_ManagerTools
//
//  Created by mac on 2019/3/5.
//  Copyright © 2019年 闵玉辉. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger,ActionType){
   Edit_ActionType = 0,//编辑模式
   Select_ActionType = 1//选择模式
};
@interface EditCPViewController : UIViewController
-(instancetype)initWithVCType:(ActionType)type;
@end

NS_ASSUME_NONNULL_END
