//
//  AudioToolManager.h
//  NewTarget
//
//  Created by 闵玉辉 on 16/11/10.
//  Copyright © 2016年  rw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Track.h"
#import "DOUAudioStreamer.h"
#import "DOUAudioVisualizer.h"
typedef NS_ENUM(NSUInteger, CEAudioPlayStyle) {
    singlePlayStyle = 0,//单个
    quantityPlayStyle =1,//多个
};
typedef void (^AudioStateBlock)(AudioState type);
typedef void (^AudioStateWithIndexBlock)(AudioState type,NSInteger index,NSString* audioUrl);
@interface AudioToolManager : NSObject
+(instancetype)shareManager;
//单个音频处理方式
@property (nonatomic,strong) Track * track;
- (void)_resetStreamer:(Track*)track WithStateBlock:(AudioStateBlock)stateBlock;
- (void)_cancelStreamer;
//多个音频处理逻辑
@property (nonatomic,strong) NSMutableArray <Track*>* tracks;
//加强版
-(void)playStreamer:(NSArray<Track *> *)tracks audioState:(AudioState)state stateBlock:(AudioStateWithIndexBlock)IndexStateBlock;
- (void)setStreamer:(NSArray <Track*>*)tracks WithStateBlock:(AudioStateWithIndexBlock)IndexStateBlock;
@end

