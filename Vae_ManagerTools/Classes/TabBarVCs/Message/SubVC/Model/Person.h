//
//  Person.h
//  Vae_ManagerTools
//
//  Created by mac on 2018/12/25.
//  Copyright © 2018年 闵玉辉. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject
-(Person*(^)(NSString*))eat;
-(Person*(^)(NSInteger))sleep;
-(Person*(^)(NSString*play,void(^)(NSString*gameName)))play;
-(void)toPlay;
+(Person*)toDoSomeThing:(void(^)(Person * p))block;
@end
