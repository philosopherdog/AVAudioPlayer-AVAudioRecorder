//
//  ViewController.m
//  Audio
//
//  Created by steve on 2016-03-23.
//  Copyright © 2016 steve. All rights reserved.
//

#import "ViewController.h"
@import MediaPlayer;
@import AVFoundation;


@interface ViewController ()<AVAudioPlayerDelegate, AVAudioRecorderDelegate>
// Player
@property (nonatomic)AVAudioPlayer *player;
// Recorder
@property (nonatomic) AVAudioRecorder *recorder;

@property (nonatomic) NSURL *soundFileURL;

@property (nonatomic) AVAudioSession *session;
@property (weak, nonatomic) IBOutlet UIButton *recordButton;
@property (weak, nonatomic) IBOutlet UIButton *playButton;

@end

@implementation ViewController

#pragma mark - Setup

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSoundFileURL];
    [self setupSession];
    [self setupRecorder];
}

- (void)setupSoundFileURL {
    NSArray *pathComponents = @[ [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject], @"sound.m4a"];
    self.soundFileURL = [NSURL fileURLWithPathComponents:pathComponents];
}

- (void)setupSession {
    self.session = [AVAudioSession sharedInstance];
    NSError *error = nil;
    [self.session setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
    NSAssert(error == nil, @"%@", error.localizedDescription);
}

- (void)setupRecorder {
    NSMutableDictionary *settings = [NSMutableDictionary dictionary];
    settings[AVFormatIDKey] = @(kAudioFormatMPEG4AAC);
    settings[AVSampleRateKey] = @(44100.0);
    settings[AVNumberOfChannelsKey] = @(2);
    // prepare for recording
    NSError *error = nil;
    self.recorder = [[AVAudioRecorder alloc] initWithURL:self.soundFileURL settings:settings error:&error];
    self.recorder.delegate = self;
    self.recorder.meteringEnabled = YES;
    [self.recorder prepareToRecord];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    
}

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    
}

- (IBAction)playTapped:(UIButton *)sender {
    // code for playing the recorded sound
    if (!self.recorder.recording){
        self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:self.recorder.url error:nil];
        self.player.delegate = self;
        [self.player play];
    }
    
    // code for playing the dubstep wav file
    
    //    NSError *error = nil;
    //    NSBundle *bundle = [NSBundle mainBundle];
    //    NSURL *path = [bundle URLForResource:@"sound" withExtension:@"m4a"];
    //    NSData *data = [NSData dataWithContentsOfURL:path];
    //    self.player = [[AVAudioPlayer alloc] initWithData:data error:&error];
    //    self.player.delegate = self;
    //    if (error) {
    //        NSLog(@"%@", error.localizedDescription);
    //        return;
    //    }
    //    if ([self.player prepareToPlay] && [self.player play]) {
    //        NSLog(@"played");
    //    } else {
    //        NSLog(@"something went wrong");
    //    }
    
    
}

- (IBAction)recordTapped:(UIButton *)sender {
    if (self.player.playing) {
        [self.player stop];
    }
    if (!self.recorder.recording) {
        //        AVAudioSession *session = [AVAudioSession sharedInstance];
        NSError *error = nil;
        [self.session setActive:YES error:&error];
        
        NSAssert(error == nil, @"%@", error.localizedDescription);
        
        // Start recording
        [self.recorder record];
        //        self.recordButton.enabled = NO;
        // [recordPauseButton setTitle:@"Pause" forState:UIControlStateNormal];
        
    } else {
        
        [self.recorder stop];
    }
}

@end
