//
//  Person.m
//  Vae_ManagerTools
//
//  Created by mac on 2018/12/25.
//  Copyright © 2018年 闵玉辉. All rights reserved.
//

#import "Person.h"
@interface Person()
@property (nonatomic,copy) NSString *playName;
@property (nonatomic,copy) void(^playBlock)(NSString*name);
@end
@implementation Person
+(Person*)toDoSomeThing:(void (^)(Person *))block
{
    if(block){
        Person * p = [[Person alloc]init];
        block(p);
        return p;
    }
    return nil;
}
-(Person*(^)(NSString*))eat{
    return ^(NSString * foodName){
        //do some thing
        SSLog(@"eat:%@",foodName);
        return self;
    };
}
-(Person *(^)(NSInteger))sleep
{
    return ^(NSInteger index){
        SSLog(@"sleep:%zd秒",index);
        return self;
    };
}
-(Person *(^)(NSString *, void (^)(NSString *)))play
{
    return ^(NSString*play,void(^playBlock)(NSString*playName)){
//        if(playBlock){
//            playBlock(play);
//        }
        self.playName = play;
        self.playBlock = playBlock;
        return self;
    };
}
-(void)toPlay
{
  
    if(self.playBlock){
        self.playBlock(self.playName);
    }
}
@end
