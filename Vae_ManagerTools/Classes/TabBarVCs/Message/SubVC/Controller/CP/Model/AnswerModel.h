//
//  AnswerModel.h
//  Vae_ManagerTools
//
//  Created by mac on 2019/3/7.
//  Copyright © 2019年 闵玉辉. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class AnswerSubModel;
@interface AnswerModel : NSObject
@property (nonatomic,copy) NSString * question;
@property (nonatomic,strong) NSMutableArray<AnswerSubModel*>*answerArr;
@end
@interface AnswerSubModel : NSObject
@property (nonatomic,assign) BOOL isSelect;
@property (nonatomic,copy) NSString * answer;
@end
NS_ASSUME_NONNULL_END
