//
//  AnswerModel.m
//  Vae_ManagerTools
//
//  Created by mac on 2019/3/7.
//  Copyright © 2019年 闵玉辉. All rights reserved.
//

#import "AnswerModel.h"

@implementation AnswerModel
-(NSMutableArray<AnswerModel *> *)answerArr
{
    if(!_answerArr){
     _answerArr = @[].mutableCopy;
    }
    return _answerArr;
}
@end
@implementation AnswerSubModel



@end
