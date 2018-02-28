//
//  XHSoundRecorder.m
//  XHSoundRecorder
//
//  Created by Apple on 16/6/7.
//  Copyright © 2016年 张轩赫. All rights reserved.
//

#import "XHSoundRecorder.h"
#import "lame.h"
#import "ALiProgressHUD.h"
@interface XHSoundRecorder () <AVAudioPlayerDelegate, AVAudioRecorderDelegate>


@property (nonatomic, copy) NSString *fileName;

@property (nonatomic, assign) SystemSoundID soundID;

/** 定时器 */
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, copy) NSString *wavPath;

@property (nonatomic, copy) NSString *mp3Path;

@property (nonatomic, copy) void (^FinishPlaying)();

@property (nonatomic, copy) void (^FinishRecording)(NSString *);

@end

static id _instance;

@implementation XHSoundRecorder
+ (instancetype)sharedSoundRecorder {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _instance = [[self alloc] init];
    });
    
    return _instance;
}

+ (instancetype)alloc {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _instance = [[super alloc] init];
    });
    
    return _instance;
}
-(NSString*)randomStringWithLength:(int)len

{
    
    NSString*letters =@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    
    NSMutableString*randomString = [NSMutableString stringWithCapacity: len];
    
    for(int i =0; i<len; i++){
        
        [randomString appendFormat:@"%C", [letters characterAtIndex:arc4random_uniform((int)[letters length])]] ;
        
    }
    
    return randomString;
    
}

- (AVAudioRecorder *)recorder {
    
    if (!_recorder) {
        
        NSDate *date = [NSDate date];
        
        NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
        
        [formatter setDateFormat:@"YYYYMMddHHmmss"];
        
        NSString * currentTimeString = [NSString stringWithFormat:@"%@%@",[formatter stringFromDate:date],[self randomStringWithLength:8]];
        
        self.fileName = currentTimeString;
        
        NSString *wavPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
        
        wavPath = [wavPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.wav",currentTimeString]];
        
        self.wavPath = wavPath;
        
        NSURL *url = [NSURL URLWithString:wavPath];
        
        AVAudioSession *session = [AVAudioSession sharedInstance];
        
        NSError *error = nil;
        
        [session setCategory:AVAudioSessionCategoryRecord error:&error];
        
        if(error){
            
            NSLog(@"录音错误说明%@", [error description]);
        }
        
        
        NSDictionary *setting = [NSDictionary dictionary];
        
        _recorder = [[AVAudioRecorder alloc] initWithURL:url settings:setting error:nil];
        
        _recorder.meteringEnabled = YES;
        
        _recorder.delegate = self;
        
    }
    
    return _recorder;
}

//开始、继续 录音
- (void)startRecorder:(void (^)(NSString *filePath))FinishRecording {
    
   
      [self destructionRecordingFile];
    if (![self.recorder isRecording]) {
        
        [self.recorder prepareToRecord];
        
        [self.recorder record];
        
    }
    if(self.timer)
    {
        [self.timer invalidate];
        self.timer = nil;
    }
    NSTimer *timer = [NSTimer timerWithTimeInterval:0.5f target:self selector:@selector(updateImage) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    [timer fire];
    self.timer = timer;
    self.FinishRecording = FinishRecording;
//    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error: nil];
//    [[AVAudioSession sharedInstance] setActive: YES error: nil];
//    UInt32 doChangeDefault = 1;
//    AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryDefaultToSpeaker, sizeof(doChangeDefault), &doChangeDefault);

}
//删除曾经录音的文件
- (void)destructionRecordingFile {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (self.wavPath) {
        [fileManager removeItemAtURL:[NSURL fileURLWithPath:self.wavPath] error:NULL];
    }
    if (self.mp3Path) {
        [fileManager removeItemAtURL:[NSURL fileURLWithPath:self.mp3Path] error:NULL];
    }
}
- (void)updateImage {
    
    if(self.timeBlock)
    {
        self.timeBlock([XHSoundRecorder sharedSoundRecorder].recorder.currentTime);
    }
    
    [self.recorder updateMeters];

    double lowPassResults = pow(10, (0.05 * [self.recorder peakPowerForChannel:0]));
    float result  = 10 * (float)lowPassResults;
    NSLog(@"多大的声音:%f", result);
    int no = 0;
    if (result > 0 && result <= 1.3) {
        no = 1;
    } else if (result > 1.3 && result <= 2) {
        no = 2;
    } else if (result > 2 && result <= 3.0) {
        no = 3;
    } else if (result > 3.0 && result <= 3.0) {
        no = 4;
    } else if (result > 5.0 && result <= 10) {
        no = 5;
    } else if (result > 10 && result <= 40) {
        no = 6;
    } else if (result > 40) {
        no = 7;
    }
//    self.sounderView.imgIndex = no;
    if(self.decibelsBackBlock)
    {
        self.decibelsBackBlock(no);
    }
    if([XHSoundRecorder sharedSoundRecorder].recorder.currentTime >60.f)
    {
        [ALiProgressHUD showImage:K_IMG(@"GTH" ) status:@"录制时间过长,已断开"];
        [[XHSoundRecorder sharedSoundRecorder]stopRecorder];
        
    }
}

//暂停录音
- (void)pauseRecorder {
//    self.sounderView.hidden  = YES;
    if ([self.recorder isRecording]) {
        [self.recorder pause];
    }
    
}

//停止录音
- (void)stopRecorder {
 
    [self.recorder stop];
    self.recorder = nil;
    [self.timer invalidate];
    self.timer = nil;
}

//播放
- (void)playsound:(NSString *)filePath withFinishPlaying:(void (^)(void))FinishPlaying {
    
    if (!self.player) {
        
        AVAudioSession *session = [AVAudioSession sharedInstance];
        
        NSError *error = nil;
        
        [session setCategory:AVAudioSessionCategoryPlayback error:&error];
        
        if(error){
            
            NSLog(@"播放错误说明%@", [error description]);
        }
        
        NSURL *url;
        
        if (filePath == nil) {
            
            if (self.wavPath) {
                
                url = [NSURL fileURLWithPath:self.wavPath];
            } else if (self.mp3Path) {
                
                url = [NSURL fileURLWithPath:self.mp3Path];
            } else {
                
                return;
            }
            
        } else {
            
            url = [NSURL fileURLWithPath:filePath];;
        }
        
        if (url == nil) {
            
            return;
        }
        
        self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        self.player.meteringEnabled = YES;
        self.player.delegate = self;
        
    }
    
    [self.player prepareToPlay];
    
    [self.player play];
    
    self.FinishPlaying = FinishPlaying;
    
}

//暂停播放
- (void)pausePlaysound {
    
    [self.player pause];
}

//停止播放
- (void)stopPlaysound {
    
    [self.player stop];
    self.player = nil;
}

//删除录音
- (void)removeSoundRecorder {
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    if (self.wavPath) {
        
        [manager removeItemAtPath:self.wavPath error:nil];
        
        self.wavPath = nil;
        
    } else {
        
        [manager removeItemAtPath:self.mp3Path error:nil];
        
        self.mp3Path = nil;
    }
    
    self.recorder = nil;
    
    self.player = nil;
    
}

//分贝数
- (CGFloat)decibels {
    
    [self.recorder updateMeters];
    
    CGFloat decibels = [self.recorder averagePowerForChannel:0];
    
    return decibels;
}
//播放结束的代理方法
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    
    if (self.FinishPlaying) {
        
        self.FinishPlaying();
    }
//   [self.timer invalidate];
//    self.timer = nil;
    self.player = nil;
}

//播放被打断时
- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player {
    
    [self stopPlaysound];
}


//播放被打断结束时
- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withOptions:(NSUInteger)flags {
    
    [self playsound:nil withFinishPlaying:nil];
}


//录音结束的代理
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    SSLog(@"录制结束");
    [self.timer invalidate];
       self.timer = nil;
    if (self.FinishRecording) {
        self.FinishRecording(self.wavPath);
    }
}

//录音被打断时
- (void)audioRecorderBeginInterruption:(AVAudioRecorder *)recorder {
    
    [self stopRecorder];
    
}

//录音被打断结束时
- (void)audioRecorderEndInterruption:(AVAudioRecorder *)recorder {
    
}


//转成mp3格式
- (void)recorderFileToMp3WithType:(CEPhoneType)type filePath:(NSString *)filePath FilePath:(void (^)(NSString *newfilePath))newFilePath {
    
    NSString *wavFilePath;
    
    if (filePath == nil) {
        
        if (self.wavPath == nil) {
            
            NSLog(@"没有要转的文件");
            
            return;
        }
        
        wavFilePath = self.wavPath;
        
    } else {
        
        wavFilePath = filePath;
    }
    
   
    
    NSString *mp3FilePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    
    mp3FilePath = [mp3FilePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp3",self.fileName]];

    @try {
        int read, write;
        
        FILE *pcm = fopen([wavFilePath cStringUsingEncoding:1], "rb");//被转换的文件
        fseek(pcm, 4*1024, SEEK_CUR);
        FILE *mp3 = fopen([mp3FilePath cStringUsingEncoding:1], "wb");//转换后文件的存放位置
        
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE*2];
        unsigned char mp3_buffer[MP3_SIZE];
        
        lame_t lame = lame_init();
        lame_set_in_samplerate(lame, type == TrueMachine ? 22050 : 44100);
        lame_set_VBR(lame, vbr_default);
        lame_init_params(lame);
        
        do {
            read = (int)fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
            if (read == 0)
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            else
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            
            fwrite(mp3_buffer, write, 1, mp3);
            
        } while (read != 0);
        
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception description]);
    }
    @finally {
        NSLog(@"转换完毕");
        self.mp3Path = mp3FilePath;
        
        newFilePath(mp3FilePath);
    }
    
}
-(void)removeFileFinshRecord{
    NSFileManager *manager = [NSFileManager defaultManager];
    [manager removeItemAtPath:self.wavPath error:nil];
    [manager removeItemAtPath:self.mp3Path error:nil];
    self.wavPath = nil;
    self.mp3Path = nil;
}
-(double)muchTime:(BOOL)isMP3
{
    NSURL * url = [NSURL fileURLWithPath:isMP3?self.mp3Path:self.wavPath];
        AVURLAsset * assset = [AVURLAsset assetWithURL:url];
    CMTime time = [assset duration];
    return  ceil(time.value/time.timescale)?ceil(time.value/time.timescale):0;
}
-(void)dealloc
{
  if(self.timer)
  {
      [self.timer invalidate];
      self.timer = nil;
  }
}
@end





