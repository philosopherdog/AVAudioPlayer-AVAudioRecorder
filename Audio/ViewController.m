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

@property (nonatomic)AVAudioPlayer *player;

@property (nonatomic) AVAudioRecorder *recorder;

@property (nonatomic) NSURL *soundFileURL;
@property (nonatomic) AVAudioSession *session;
@property (weak, nonatomic) IBOutlet UIButton *recordButton;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;
@property (weak, nonatomic) IBOutlet UIView *gradientView;
@end

@implementation ViewController

#pragma mark - Setup

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
    self.session = [AVAudioSession sharedInstance];
    [self setupSoundFileURL];
    [self setupRecorder];
}

- (void)setupSoundFileURL {
    NSArray *pathComponents = @[ [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject], @"sound.m4a"];
    self.soundFileURL = [NSURL fileURLWithPathComponents:pathComponents];
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

#pragma mark - Button Actions

- (IBAction)playTapped:(UIButton *)sender {
    // code for playing the recorded sound
    if (self.recorder.isRecording) {
        return;
    }
    if (self.player.isPlaying) {
        [self.player stop];
        return;
    }
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:self.recorder.url error:nil];
    [self.session setCategory:AVAudioSessionCategoryPlayback error:nil];
    self.player.delegate = self;
    [self.player play];
    self.recordButton.enabled = NO;
}

- (IBAction)recordTapped:(UIButton *)sender {
    if (self.player.playing) {
        [self.player stop];
    }
    if (!self.recorder.recording) {
        NSError *error = nil;
        [self.session setActive:YES error:&error];
        [self.session setCategory:AVAudioSessionCategoryRecord error:nil];
        NSAssert(error == nil, @"%@", error.localizedDescription);
        [self.recorder record];
        self.playButton.enabled = NO;
        
        // swap buttons
        [UIView animateWithDuration:10.0 animations:^{
            self.stopButton.hidden = NO;
            self.recordButton.hidden = YES;
        }];
        
    } else {
        
        [self.recorder stop];
        // swap buttons
        [UIView animateWithDuration:10.0 animations:^{
            self.stopButton.hidden = YES;
            self.recordButton.hidden = NO;
        }];
        self.playButton.enabled = YES;
    }
}

#pragma mark - Delegate Methods

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    self.recordButton.enabled = YES;
}

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    self.recordButton.hidden = NO;
    self.stopButton.hidden = YES;
}

@end
