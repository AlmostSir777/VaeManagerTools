//
//  AudioToolManager.m
//  NewTarget
//
//  Created by 闵玉辉 on 16/11/10.
//  Copyright © 2016年  rw. All rights reserved.
//

#import "AudioToolManager.h"
#import <AVFoundation/AVFoundation.h>
static void *kStatusKVOKey = &kStatusKVOKey;
static void *kDurationKVOKey = &kDurationKVOKey;
static void *kBufferingRatioKVOKey = &kBufferingRatioKVOKey;
@interface AudioToolManager()
/** 播放器 */
@property (nonatomic,strong) DOUAudioStreamer * streamer;
/** 计时器 */
@property (nonatomic,strong) NSTimer *progressUpdateTimer;
/** 是否在播放 */
@property (nonatomic,assign) BOOL isPlay;
/** index状态Block */
@property (nonatomic,copy) AudioStateWithIndexBlock IndexStateBlock;
/** 状态Block */
@property (nonatomic,copy) AudioStateBlock audioBlock;
/**  标记index  */
@property (nonatomic,assign) NSInteger currentTrackIndex;
/** 播放模式 */
@property (nonatomic,assign) CEAudioPlayStyle playStyle;
@end
@implementation AudioToolManager
static id instance;
#pragma mark - 单例
+ (instancetype)shareManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[self alloc] init];
        }
    });
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [super allocWithZone:zone];
        }
    });
    return instance;
}
-(NSMutableArray<Track *> *)tracks
{
    if(_tracks == nil)
    {
        _tracks = @[].mutableCopy;
    }
    return _tracks;
}
#pragma mark -- 移除音频播放器
- (void)_cancelStreamer
{
    if(self.playStyle == singlePlayStyle){
        if (_streamer != nil) {
            self.isPlay = NO;
            _track = nil;
            [_streamer pause];
            if(self.audioBlock)
            {
                self.audioBlock(normal_state);
            }
            _audioBlock = nil;
            @try {
                [self removeObserver];
            } @catch(id anException){
            }
            
            SSLog(@"销毁了");
        }
    }else if (self.playStyle == quantityPlayStyle)
    {
        //多个音频
        if (_streamer != nil) {
            self.isPlay = NO;
            [_streamer pause];
            if(self.IndexStateBlock)
            {
                self.IndexStateBlock(normal_state, _currentTrackIndex, _tracks[_currentTrackIndex].audioFileURL.absoluteString);
            }
            _IndexStateBlock = nil;
            _currentTrackIndex = 0;
            if(self.tracks.count>0)
            {
                [_tracks removeAllObjects];
            }
            _tracks = nil;
            @try {
                [self removeObserver];
            } @catch(id anException){
            }
            
        }
    }
}
/*
 _progressUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(_timerAction:) userInfo:nil repeats:YES];
 [[NSRunLoop mainRunLoop] addTimer:_progressUpdateTimer forMode:NSDefaultRunLoopMode];
 [_progressUpdateTimer fire];
 */
-(void)removeObserver{
    [_streamer removeObserver:self forKeyPath:@"status"];
    [_streamer removeObserver:self forKeyPath:@"duration"];
    [_streamer removeObserver:self forKeyPath:@"bufferingRatio"];
    _streamer = nil;
    [_progressUpdateTimer invalidate];
    _progressUpdateTimer = nil;
    [[NSNotificationCenter defaultCenter]removeObserver:self name:Audio_Pause object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
}
#pragma mark--重置音频播放器
- (void)_resetStreamer:(Track *)track WithStateBlock:(AudioStateBlock)stateBlock
{
    self.playStyle = singlePlayStyle;
    if(_track)
    {
        if([_track.audioFileURL.absoluteString isEqualToString:track.audioFileURL.absoluteString])
        {
            SSLog(@"一样的URL销毁了");
            [self _cancelStreamer];
            return;
        }else
        {
            [self _cancelStreamer];
            dispatch_async(dispatch_get_main_queue(), ^{
                AVAudioSession *audioSession = [AVAudioSession sharedInstance];
                NSError *err = nil;
                [audioSession setCategory :AVAudioSessionCategoryPlayback error:&err];
                self.track = track;
                self.audioBlock = [stateBlock copy];
                _streamer = [DOUAudioStreamer streamerWithAudioFile:_track];
                [_streamer addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:kStatusKVOKey];
                [_streamer addObserver:self forKeyPath:@"duration" options:NSKeyValueObservingOptionNew context:kDurationKVOKey];
                [_streamer addObserver:self forKeyPath:@"bufferingRatio" options:NSKeyValueObservingOptionNew context:kBufferingRatioKVOKey];
                [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(_cancelStreamer) name:Audio_Pause object:nil];
                // app退到后台
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground) name:UIApplicationWillResignActiveNotification object:nil];
                [_streamer play];
                self.isPlay = YES;
                [DOUAudioStreamer setHintWithAudioFile:_track];
            });
            return;
        }
    }else
    {
        
        if(_streamer){
            [self _cancelStreamer];
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                AVAudioSession *audioSession = [AVAudioSession sharedInstance];
                NSError *err = nil;
                [audioSession setCategory :AVAudioSessionCategoryPlayback error:&err];
                self.track = track;
                self.audioBlock = stateBlock;
                _streamer = [DOUAudioStreamer streamerWithAudioFile:_track];
                [_streamer addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:kStatusKVOKey];
                [_streamer addObserver:self forKeyPath:@"duration" options:NSKeyValueObservingOptionNew context:kDurationKVOKey];
                [_streamer addObserver:self forKeyPath:@"bufferingRatio" options:NSKeyValueObservingOptionNew context:kBufferingRatioKVOKey];
                [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(_cancelStreamer) name:Audio_Pause object:nil];
                // app退到后台
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground) name:UIApplicationWillResignActiveNotification object:nil];
                [_streamer play];
                self.isPlay = YES;
                [DOUAudioStreamer setHintWithAudioFile:_track];
            });
        }
        
    }
}

#pragma mark--后台前台
-(void)appDidEnterBackground
{
    [self _cancelStreamer];
}
#pragma mark--KVO观察状态
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == kStatusKVOKey) {
        [self performSelector:@selector(_updateStatus)
                     onThread:[NSThread mainThread]
                   withObject:nil
                waitUntilDone:NO];
    }
    else if (context == kDurationKVOKey) {
        [self performSelector:@selector(_timerAction:)
                     onThread:[NSThread mainThread]
                   withObject:nil
                waitUntilDone:NO];
    }
    else if (context == kBufferingRatioKVOKey) {
        
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
- (void)_timerAction:(id)timer
{
    SSLog(@"1");
    
}
- (void)_updateStatus
{
    
    if(self.playStyle == singlePlayStyle){
        switch ([_streamer status]) {
            case DOUAudioStreamerPlaying:
            {
                if(self.audioBlock)
                {
                    self.audioBlock(animation_state);
                }
            }
                break;
                
            case DOUAudioStreamerPaused:
            {
                if(self.audioBlock)
                {
                    self.audioBlock(normal_state);
                }
            }
                break;
                
            case DOUAudioStreamerIdle:
            {
                if(self.audioBlock)
                {
                    self.audioBlock(normal_state);
                }
            }
                break;
                
            case DOUAudioStreamerFinished:
            {
                if(self.audioBlock)
                {
                    self.audioBlock(normal_state);
                }
                [self _cancelStreamer];
            }
                break;
                
            case DOUAudioStreamerBuffering:
            {
                if(self.audioBlock)
                {
                    self.audioBlock(buffer_state);
                }
            }
                break;
                
            case DOUAudioStreamerError:
            {
                {
                    if(self.audioBlock)
                    {
                        self.audioBlock(normal_state);
                    }
                }
                SSMBToast(@"语音播放出错", MainWindow);
            }
                break;
        }
    }else if (self.playStyle == quantityPlayStyle)
    {
        //多个音频
        switch ([_streamer status]) {
            case DOUAudioStreamerPlaying:
            {
                if(self.IndexStateBlock)
                {
                    self.IndexStateBlock(animation_state, _currentTrackIndex, _tracks[_currentTrackIndex].audioFileURL.absoluteString);
                }
            }
                break;
                
            case DOUAudioStreamerPaused:
            {
                if(self.IndexStateBlock)
                {
                    self.IndexStateBlock(normal_state, _currentTrackIndex, _tracks[_currentTrackIndex].audioFileURL.absoluteString);
                }
            }
                break;
                
            case DOUAudioStreamerIdle:
            {
                if(self.IndexStateBlock)
                {
                    self.IndexStateBlock(normal_state, _currentTrackIndex, _tracks[_currentTrackIndex].audioFileURL.absoluteString);
                }
            }
                break;
                
            case DOUAudioStreamerFinished:
            {
                if(self.IndexStateBlock)
                {
                    self.IndexStateBlock(normal_state, _currentTrackIndex, _tracks[_currentTrackIndex].audioFileURL.absoluteString);
                }
                [self _setupHintForStreamer];
            }
                break;
                
            case DOUAudioStreamerBuffering:
            {
                if(self.IndexStateBlock)
                {
                    self.IndexStateBlock(buffer_state, _currentTrackIndex, _tracks[_currentTrackIndex].audioFileURL.absoluteString);
                }
            }
                break;
                
            case DOUAudioStreamerError:
            {
                SSMBToast(@"语音播放出错", MainWindow);
                if(self.IndexStateBlock)
                {
                    self.IndexStateBlock(normal_state, _currentTrackIndex, _tracks[_currentTrackIndex].audioFileURL.absoluteString);
                }
                [self _setupHintForStreamer];
            }
                break;
        }
        
        
        
    }
}
-(void)playStreamer:(NSArray<Track *> *)tracks audioState:(AudioState)state stateBlock:(AudioStateWithIndexBlock)IndexStateBlock
{
    self.playStyle = quantityPlayStyle;
    if(_tracks!=nil)
    {
        //_tracks音频列表存在，代表存在列表在播放
        //比较当前播放的URL是否与传进来的第一个数组的URL相同
        if(state != normal_state)
        {
            [self _cancelStreamer];
        }else
        {
            [self _cancelStreamer];
            dispatch_async(dispatch_get_main_queue(), ^{
                AVAudioSession *audioSession = [AVAudioSession sharedInstance];
                NSError *err = nil;
                [audioSession setCategory :AVAudioSessionCategoryPlayback error:&err];
                self.tracks = tracks.mutableCopy;
                self.currentTrackIndex = 0;
                self.IndexStateBlock = IndexStateBlock;
                _streamer = [DOUAudioStreamer streamerWithAudioFile:_tracks.firstObject];
                [_streamer addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:kStatusKVOKey];
                [_streamer addObserver:self forKeyPath:@"duration" options:NSKeyValueObservingOptionNew context:kDurationKVOKey];
                [_streamer addObserver:self forKeyPath:@"bufferingRatio" options:NSKeyValueObservingOptionNew context:kBufferingRatioKVOKey];
                [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(_cancelStreamer) name:Audio_Pause object:nil];
                // app退到后台
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground) name:UIApplicationWillResignActiveNotification object:nil];
                [_streamer play];
            });
        }
    }else
    {
        //_tracks音频列表不存在
        [self _cancelStreamer];
        dispatch_async(dispatch_get_main_queue(), ^{
            AVAudioSession *audioSession = [AVAudioSession sharedInstance];
            NSError *err = nil;
            [audioSession setCategory :AVAudioSessionCategoryPlayback error:&err];
            self.tracks = tracks.mutableCopy;
            self.currentTrackIndex = 0;
            self.IndexStateBlock = IndexStateBlock;
            _streamer = [DOUAudioStreamer streamerWithAudioFile:_tracks.firstObject];
            [_streamer addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:kStatusKVOKey];
            [_streamer addObserver:self forKeyPath:@"duration" options:NSKeyValueObservingOptionNew context:kDurationKVOKey];
            [_streamer addObserver:self forKeyPath:@"bufferingRatio" options:NSKeyValueObservingOptionNew context:kBufferingRatioKVOKey];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(_cancelStreamer) name:Audio_Pause object:nil];
            // app退到后台
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground) name:UIApplicationWillResignActiveNotification object:nil];
            [_streamer play];
        });
    }
}
-(void)setStreamer:(NSArray<Track *> *)tracks WithStateBlock:(AudioStateWithIndexBlock)IndexStateBlock
{
    self.playStyle = quantityPlayStyle;
    if(_tracks!=nil)
    {
        //_tracks音频列表存在，代表存在列表在播放
        //比较当前播放的URL是否与传进来的第一个数组的URL相同
        if([_tracks[_currentTrackIndex].audioFileURL.absoluteString isEqualToString: tracks.firstObject.audioFileURL.absoluteString])
        {
            [self _cancelStreamer];
        }else
        {
            [self _cancelStreamer];
            dispatch_async(dispatch_get_main_queue(), ^{
                AVAudioSession *audioSession = [AVAudioSession sharedInstance];
                NSError *err = nil;
                [audioSession setCategory :AVAudioSessionCategoryPlayback error:&err];
                self.tracks = tracks.mutableCopy;
                self.currentTrackIndex = 0;
                self.IndexStateBlock = IndexStateBlock;
                _streamer = [DOUAudioStreamer streamerWithAudioFile:_tracks.firstObject];
                [_streamer addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:kStatusKVOKey];
                [_streamer addObserver:self forKeyPath:@"duration" options:NSKeyValueObservingOptionNew context:kDurationKVOKey];
                [_streamer addObserver:self forKeyPath:@"bufferingRatio" options:NSKeyValueObservingOptionNew context:kBufferingRatioKVOKey];
                [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(_cancelStreamer) name:Audio_Pause object:nil];
                // app退到后台
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground) name:UIApplicationWillResignActiveNotification object:nil];
                [_streamer play];
            });
        }
    }else
    {
        //_tracks音频列表不存在
        [self _cancelStreamer];
        dispatch_async(dispatch_get_main_queue(), ^{
            AVAudioSession *audioSession = [AVAudioSession sharedInstance];
            NSError *err = nil;
            [audioSession setCategory :AVAudioSessionCategoryPlayback error:&err];
            self.tracks = tracks.mutableCopy;
            self.currentTrackIndex = 0;
            self.IndexStateBlock = IndexStateBlock;
            _streamer = [DOUAudioStreamer streamerWithAudioFile:_tracks.firstObject];
            [_streamer addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:kStatusKVOKey];
            [_streamer addObserver:self forKeyPath:@"duration" options:NSKeyValueObservingOptionNew context:kDurationKVOKey];
            [_streamer addObserver:self forKeyPath:@"bufferingRatio" options:NSKeyValueObservingOptionNew context:kBufferingRatioKVOKey];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(_cancelStreamer) name:Audio_Pause object:nil];
            // app退到后台
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground) name:UIApplicationWillResignActiveNotification object:nil];
            [_streamer play];
        });
    }
    
}
-(void)finishPause{
    if (_streamer != nil) {
        self.isPlay = NO;
        [_streamer pause];
        @try {
            [self removeObserver];
        } @catch(id anException){
        }
        
    }
}
- (void)_setupHintForStreamer
{
    _currentTrackIndex++;
    if(_currentTrackIndex<_tracks.count)
    {
        //_tracks音频列表不存在
        [self finishPause];
        dispatch_async(dispatch_get_main_queue(), ^{
            _streamer = [DOUAudioStreamer streamerWithAudioFile:_tracks[_currentTrackIndex]];
            [_streamer addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:kStatusKVOKey];
            [_streamer addObserver:self forKeyPath:@"duration" options:NSKeyValueObservingOptionNew context:kDurationKVOKey];
            [_streamer addObserver:self forKeyPath:@"bufferingRatio" options:NSKeyValueObservingOptionNew context:kBufferingRatioKVOKey];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(_cancelStreamer) name:Audio_Pause object:nil];
            // app退到后台
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground) name:UIApplicationWillResignActiveNotification object:nil];
            [_streamer play];
        });
        
    }else
    {
        _currentTrackIndex = _tracks.count-1;
        [self _cancelStreamer];
    }
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    if(self.progressUpdateTimer)
    {
        [self.progressUpdateTimer invalidate];
        self.progressUpdateTimer = nil;
    }
    
}
-(void)setTrack:(Track *)track
{
    _track = track;
    //
    SSLog(@"赋值语音");
}
@end

