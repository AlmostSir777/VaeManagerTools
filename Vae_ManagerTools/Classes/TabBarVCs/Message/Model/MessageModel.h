//
//  MessageModel.h
//  Vae_ManagerTools
//
//  Created by 闵玉辉 on 2018/4/9.
//  Copyright © 2018年 闵玉辉. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSUInteger, MessageCellType) {
    Photo_MessageCellType = 0,//图文
    Video_MessageCellType = 1,//视频
    Voice_MessageCellType = 2,//音乐
};
@interface MessageModel : NSObject
@property (nonatomic,copy) NSString * title;
@property (nonatomic,assign) NSInteger seeNum;
@property (nonatomic,copy) NSString * imgUrl;
@property (nonatomic,assign) BOOL isSee;
@property (nonatomic,assign) MessageCellType cellType;
@end
