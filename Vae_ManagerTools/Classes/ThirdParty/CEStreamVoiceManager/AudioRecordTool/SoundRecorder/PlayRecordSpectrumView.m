//
//  PlayRecordSpectrumView.m
//  CatEntertainment
//
//  Created by 闵玉辉 on 2018/2/1.
//  Copyright © 2018年 闵玉辉. All rights reserved.
//

#import "PlayRecordSpectrumView.h"
#import "XHSoundRecorder.h"
static CGFloat const levelWidth = 3.0;
static CGFloat const levelMargin = 2.0;

@interface PlayRecordSpectrumView()
@property (nonatomic,strong) NSMutableArray *currentLevels; // 当前振幅数组
@property (nonatomic,strong) NSMutableArray *allLevels;     // 所有收集到的振幅,
@property (nonatomic,weak) CAShapeLayer *levelLayer;        // 振幅layer
@property (nonatomic,strong) UIBezierPath *levelPath;       // 画振幅的path
@property (nonatomic,strong) CADisplayLink * timer;
@end
@implementation PlayRecordSpectrumView
- (NSMutableArray *)allLevels {
    if (_allLevels == nil) {
        _allLevels = [NSMutableArray array];
    }
    return _allLevels;
}

- (NSMutableArray *)currentLevels {
    if (_currentLevels == nil) {
        _currentLevels = [NSMutableArray arrayWithArray:@[@0.05,@0.05,@0.05,@0.05,@0.05,@0.05]];
    }
    return _currentLevels;
}
- (CAShapeLayer *)levelLayer {
    if (_levelLayer == nil) {
        CGFloat width = 6 * levelWidth + 5 * levelMargin;
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.frame = CGRectMake((self.mj_w)*0.5 - (width), (self.mj_h*0.5) - 20, width, 40);
        layer.strokeColor = [UIColor whiteColor].CGColor;
        layer.lineWidth = levelWidth;
        [self.layer addSublayer:layer];
        _levelLayer = layer;
    }
    return _levelLayer;
}
- (id)initWithFrame:(CGRect)frame
{
    NSLog(@"initWithFrame");
    if (self = [super initWithFrame:frame]) {
        [self levelLayer];
        [self setup];
    }
    return self;
}


- (void)setup
{
    self.numberOfItems = 8;//偶数
    //[UIColor colorWithRed:241/255.f green:60/255.f blue:57/255.f alpha:1.0];
    self.itemColor = [UIColor whiteColor];
    self.level = 0.05;
    [self refreshFrame];
}
-(void)startTimeWithAllLeves:(NSArray*)leves
{
    self.allLevels = leves.mutableCopy;
    [self.currentLevels removeAllObjects];
    
    for (NSInteger i = self.allLevels.count - 1 ; i >= self.allLevels.count - 10 ; i--) {
        CGFloat l = 0.05;
        if (i >= 0) {
            l = [self.allLevels[i] floatValue];
        }
        [self.currentLevels addObject:@(l)];
    }
         self.numberOfItems = self.allLevels.count;
        [self startTimter];
        
}
-(void)startTimter{
    
    self.timer = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateFrame)];
    if ([[UIDevice currentDevice].systemVersion floatValue] > 10.0) {
        if (@available(iOS 10.0, *)) {
            self.timer.preferredFramesPerSecond = 10;
        } else {
            // Fallback on earlier versions
        }
    }else {
        self.timer.frameInterval = 6;
    }
    [_timer addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}
-(void)updateFrame{
    
    CGFloat value = 1 - (CGFloat)self.allLevels.count / self.numberOfItems;
    
    if (value == 1) {
        [self.timer invalidate];
    }
    
    if (value == 1)  return;
    
    CGFloat level = [self.allLevels.firstObject floatValue];
    [self.currentLevels removeLastObject];
    [self.currentLevels insertObject:@(level) atIndex:0];
    [self.allLevels removeObjectAtIndex:0];
    [self updateItems];
}
-(void)endDisLink
{
    [self endTimer];
    self.level = 0.05;
    [self refreshFrame];
}
-(void)endTimer{
    if(_timer){
        //        _timer.paused = YES;
        [_timer invalidate];
        _timer = nil;
    }
}
-(void)dealloc
{
    if(_timer){
        [_timer invalidate];
        _timer = nil;
    }
    SSLog(@"9999---销毁%s",__func__);
}
-(void)refreshFrame
{
    self.levelPath = [UIBezierPath bezierPath];
    
    CGFloat height = CGRectGetHeight(self.levelLayer.frame);
    for (int i = 0; i < self.currentLevels.count; i++) {
        CGFloat x = i * (levelWidth + levelMargin) + 5;
        CGFloat pathH = [self.currentLevels[i] floatValue] * height;
        CGFloat startY = height / 2.0 - pathH / 2.0;
        CGFloat endY = height / 2.0 + pathH / 2.0;
        [_levelPath moveToPoint:CGPointMake(x, startY)];
        [_levelPath addLineToPoint:CGPointMake(x, endY)];
    }
    
    self.levelLayer.path = _levelPath.CGPath;

}
- (void)updateItems
{
    NSLog(@"updateMeters");
    self.levelPath = [UIBezierPath bezierPath];
    
    CGFloat height = CGRectGetHeight(self.levelLayer.frame);
    for (int i = 0; i < self.currentLevels.count; i++) {
        CGFloat x = i * (levelWidth + levelMargin) + 5;
        CGFloat pathH = [self.currentLevels[i] floatValue] * height;
        CGFloat startY = height / 2.0 - pathH / 2.0;
        CGFloat endY = height / 2.0 + pathH / 2.0;
        [_levelPath moveToPoint:CGPointMake(x, startY)];
        [_levelPath addLineToPoint:CGPointMake(x, endY)];
    }
    
    self.levelLayer.path = _levelPath.CGPath;

}

@end
