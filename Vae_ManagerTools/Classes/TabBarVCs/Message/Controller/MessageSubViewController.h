//
//  MessageSubViewController.h
//  Vae_ManagerTools
//
//  Created by 闵玉辉 on 2018/4/9.
//  Copyright © 2018年 闵玉辉. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, Message_Type) {
    Recommend_Type = 0,//推荐
    WY_Type = 1,//文娱
    Life_Type = 2,//生活
    Video_Type = 3,//视频
    Voice_Type = 5,//声音
};
@interface MessageSubViewController : UIViewController
@property (nonatomic,assign) Message_Type type;
@end
