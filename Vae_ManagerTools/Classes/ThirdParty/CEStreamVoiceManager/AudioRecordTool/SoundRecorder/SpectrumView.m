//
//  SpectrumView.m
//  GYSpectrum
//
//  Created by 黄国裕 on 16/8/19.
//  Copyright © 2016年 黄国裕. All rights reserved.
//

#import "SpectrumView.h"
#import "XHSoundRecorder.h"
@interface SpectrumView ()

@property (nonatomic, strong) NSMutableArray * levelArray;
@property (nonatomic) NSMutableArray <CAShapeLayer*>* itemArray;
@property (nonatomic) CGFloat itemHeight;
@property (nonatomic) CGFloat itemWidth;
@property (nonatomic,strong) CADisplayLink * timer;
@end

@implementation SpectrumView

-(NSMutableArray *)allLeves
{
    if(!_allLeves)
    {
        _allLeves = @[].mutableCopy;
    }
    return _allLeves;
}
- (id)init
{
    NSLog(@"init");
    if(self = [super init]) {
        [self setup];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    NSLog(@"initWithFrame");
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    
    return self;
}

//- (void)awakeFromNib
//{
//    NSLog(@"awakeFromNib");
//    [self setup];
//}

- (void)setup
{
    
    NSLog(@"setup");
    
    self.itemArray = [NSMutableArray new];
    
    self.numberOfItems = 16;//偶数
   //[UIColor colorWithRed:241/255.f green:60/255.f blue:57/255.f alpha:1.0];
    self.itemColor = MENU_COLOR;

    self.itemHeight = CGRectGetHeight(self.bounds);
    self.itemWidth  = CGRectGetWidth(self.bounds);
    
    self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.itemWidth*0.4, 0, self.itemWidth*0.2, self.itemHeight)];
    self.timeLabel.text = @"";
    self.timeLabel.font = KFONT(12);
    [self.timeLabel setTextColor:[Utils colorConvertFromString:@"#666666"]];
    [self.timeLabel setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:self.timeLabel];
    
    self.levelArray = [[NSMutableArray alloc]init];
    for(int i = 0 ; i < self.numberOfItems/2 ; i++){
        [self.levelArray addObject:@(1)];
    }
    for(int i=0; i < self.numberOfItems; i++)
    {
        CAShapeLayer *itemline = [CAShapeLayer layer];
        itemline.lineCap       = kCALineCapButt;
        itemline.lineJoin      = kCALineJoinRound;
        itemline.strokeColor   = [[UIColor clearColor] CGColor];
        itemline.fillColor     = [[UIColor clearColor] CGColor];
        [itemline setLineWidth:self.itemWidth*0.4/self.numberOfItems];
        itemline.strokeColor   = [self.itemColor CGColor];
        
        [self.layer addSublayer:itemline];
        [self.itemArray addObject:itemline];
    }
    self.level = -160;
}

-(void)setItemLevelCallback:(void (^)(void))itemLevelCallback
{
    NSLog(@"setItemLevelCallback");
    
    _itemLevelCallback = itemLevelCallback;
    
}
-(void)startTimter{
    if(self.allLeves.count>0){
        [self.allLeves removeAllObjects];
    }
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
#define ALPHA 0.02f                 // 音频振幅调解相对值 (越小振幅就越高)
-(void)updateFrame{
    
    if([[XHSoundRecorder sharedSoundRecorder].recorder isRecording]){
        [[XHSoundRecorder sharedSoundRecorder].recorder updateMeters];
        //取得第一个通道的音频，音频强度范围时-160到0
        float power= [[XHSoundRecorder sharedSoundRecorder].recorder averagePowerForChannel:0];
        
        double aveChannel = pow(10, (ALPHA * power));
        if (aveChannel <= 0.05f) aveChannel = 0.05f;
        
        if (aveChannel >= 1.0f) aveChannel = 1.0f;
        [self.allLeves addObject:@(aveChannel)];
        self.level = power;
    }else
    {
        self.level = -160;
    }

}
-(void)endDisLink
{
    self.timeLabel.text = @"00:00";
    [self endTimer];
    self.level = -160;
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
- (void)setLevel:(CGFloat)level
{
    _level = level;
    NSLog(@"setLevel:%f",level);
    level = (level+37.5)*3.2;
    if( level < 0 ) level = 0;

    [self.levelArray removeObjectAtIndex:self.numberOfItems/2-1];
    [self.levelArray insertObject:@((level / 6) < 1 ? 1 : level / 6) atIndex:0];
    
    [self updateItems];
    
}


- (void)setText:(NSString *)text{
    self.timeLabel.text = text;
}

-(void)refreshFrame
{
     UIGraphicsBeginImageContext(self.frame.size);
    int x = self.itemWidth*0.8/self.numberOfItems;
    int z = self.itemWidth*0.4/self.numberOfItems;
    int y = self.itemWidth*0.6 - z;
    for(int i=0;i<self.itemArray.count;i++)
    {
        UIBezierPath *itemLinePath = [UIBezierPath bezierPath];
        
        y += x;
        
        [itemLinePath moveToPoint:CGPointMake(y, self.itemHeight/2+z/2)];
        
        [itemLinePath addLineToPoint:CGPointMake(y, self.itemHeight/2-z/2)];
        
        CAShapeLayer *itemLine = [self.itemArray objectAtIndex:i];
        itemLine.path = [itemLinePath CGPath];
    }
    
    y = self.itemWidth*0.4 + z;
    
    for(int i = (int)self.numberOfItems / 2; i < self.numberOfItems; i++) {
        
        UIBezierPath *itemLinePath = [UIBezierPath bezierPath];
        
        y -= x;
        
        [itemLinePath moveToPoint:CGPointMake(y, self.itemHeight/2+z/2)];
        
        [itemLinePath addLineToPoint:CGPointMake(y, self.itemHeight/2-z/2)];
        
        CAShapeLayer *itemLine = [self.itemArray objectAtIndex:i];
        itemLine.path = [itemLinePath CGPath];
        
    }
 UIGraphicsEndImageContext();
}
- (void)updateItems
{
    //NSLog(@"updateMeters");
    
    UIGraphicsBeginImageContext(self.frame.size);
    
    int x = self.itemWidth*0.8/self.numberOfItems;
    int z = self.itemWidth*0.2/self.numberOfItems;
    int y = self.itemWidth*0.6 - z;
    
    for(int i=0; i < (self.numberOfItems / 2); i++) {
        
        UIBezierPath *itemLinePath = [UIBezierPath bezierPath];
        
        y += x;
        
        [itemLinePath moveToPoint:CGPointMake(y, self.itemHeight/2+([[self.levelArray objectAtIndex:i]intValue]+1)*z/2)];
        
        [itemLinePath addLineToPoint:CGPointMake(y, self.itemHeight/2-([[self.levelArray objectAtIndex:i]intValue]+1)*z/2)];
        
        CAShapeLayer *itemLine = [self.itemArray objectAtIndex:i];
        itemLine.path = [itemLinePath CGPath];
        
    }
    
    
    y = self.itemWidth*0.4 + z;
    
    for(int i = (int)self.numberOfItems / 2; i < self.numberOfItems; i++) {
        
        UIBezierPath *itemLinePath = [UIBezierPath bezierPath];
        
        y -= x;
        
        [itemLinePath moveToPoint:CGPointMake(y, self.itemHeight/2+([[self.levelArray objectAtIndex:i-self.numberOfItems/2]intValue]+1)*z/2)];
        
        [itemLinePath addLineToPoint:CGPointMake(y, self.itemHeight/2-([[self.levelArray objectAtIndex:i-self.numberOfItems/2]intValue]+1)*z/2)];
        
        CAShapeLayer *itemLine = [self.itemArray objectAtIndex:i];
        itemLine.path = [itemLinePath CGPath];
        
    }
    
    UIGraphicsEndImageContext();
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
