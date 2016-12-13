//
//  Created by Viki.
//  Copyright (c) 2014 Viki Inc. All rights reserved.
//

#import "VKVideoPlayerViewController.h"
#import "VKVideoPlayerConfig.h"
#import "VKFoundationLib.h"
#import "VKVideoPlayerCaptionSRT.h"
#import "VKVideoPlayerAirPlay.h"
#import "VKVideoPlayerSettingsManager.h"


@interface VKVideoPlayerViewController () {
}

@property (assign) BOOL applicationIdleTimerDisabled;
@end

@implementation VKVideoPlayerViewController

- (id)init {
    self = [super initWithNibName:NSStringFromClass([self class]) bundle:nil];
    if (self) {
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self initialize];
    }
    return self;
}

- (id)initWithPlayer:(VKVideoPlayer *)player {
    self = [super initWithNibName:NSStringFromClass([self class]) bundle:nil];
    if (self) {
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self initialize];
        _player = player;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self initialize];
    }
    return self;
}

- (void)initialize {
    [VKSharedAirplay setup];
}
- (void)dealloc {
    [VKSharedAirplay deactivate];
}

- (VKVideoPlayer *)player;
{
    if (!_player) {
        _player = [[VKVideoPlayer alloc] init];
        _player.avPlayer.allowsExternalPlayback = YES;
        _player.avPlayer.usesExternalPlaybackWhileExternalScreenIsActive = YES;
    }
    return _player;
}

- (void)updatePlayerView;
{
    self.player.view.frame = self.view.bounds;
    if (![self.view.subviews containsObject:self.player.view]) {
        [self.view addSubview:self.player.view];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.player.delegate = self;
    
    if (VKSharedAirplay.isConnected) {
        [VKSharedAirplay activate:self.player];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.applicationIdleTimerDisabled = [UIApplication sharedApplication].isIdleTimerDisabled;
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveRemoteControlEventWithNotification:)
                                                 name:@"RemoteControlEventReceived" object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.player.view.frame = self.view.bounds;
    if ([self.view.subviews containsObject:self.player.view]) {
        return;
    }
    [self.view addSubview:self.player.view];
}

- (void)viewWillDisappear:(BOOL)animated {
    [UIApplication sharedApplication].idleTimerDisabled = self.applicationIdleTimerDisabled;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewWillDisappear:animated];
}

- (void)playVideoWithStreamURL:(NSURL*)streamURL {
    [self.player loadVideoWithTrack:[[VKVideoPlayerTrack alloc] initWithStreamURL:streamURL]];
}

#pragma mark - App States

- (void)applicationWillResignActive {
    self.player.view.controlHideCountdown = -1;
    if (self.player.state == VKVideoPlayerStateContentPlaying) [self.player pauseContent:NO completionHandler:nil];
}

- (void)applicationDidBecomeActive {
    self.player.view.controlHideCountdown = kPlayerControlsDisableAutoHide;
}

#pragma mark - VKVideoPlayerControllerDelegate
- (void)videoPlayer:(VKVideoPlayer*)videoPlayer didControlByEvent:(VKVideoPlayerControlEvent)event {
    if (event == VKVideoPlayerControlEventTapDone) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - Remote Control

- (void)didReceiveRemoteControlEventWithNotification:(NSNotification *)notification
{
    UIEvent *event = notification.object;
    
    switch (event.subtype) {
            
        case UIEventSubtypeNone:break;
        case UIEventSubtypeMotionShake:break;
        case UIEventSubtypeRemoteControlPlay:
            [self.player playContent];
            break;
        case UIEventSubtypeRemoteControlPause:
            [self.player pauseContent];
            break;
        case UIEventSubtypeRemoteControlStop:break;
        case UIEventSubtypeRemoteControlTogglePlayPause:break;
        case UIEventSubtypeRemoteControlNextTrack:break;
        case UIEventSubtypeRemoteControlPreviousTrack:break;
        case UIEventSubtypeRemoteControlBeginSeekingBackward:break;
        case UIEventSubtypeRemoteControlEndSeekingBackward:break;
        case UIEventSubtypeRemoteControlBeginSeekingForward:break;
        case UIEventSubtypeRemoteControlEndSeekingForward:break;
    }
}


@end
