//
//  Created by Viki.
//  Copyright (c) 2014 Viki Inc. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MPMoviePlayerController.h>
#import <MediaPlayer/MediaPlayer.h>

#import "VKScrubber.h"
#import "VKPickerButton.h"
#import "VKView.h"
#import "VKVideoPlayerConfig.h"
#import "RTPlayPauseButton.h"
#import "RTFullScreenButton.h"

#define kPlayerControlsDisableAutoHide -1

@class VKVideoPlayerTrack;
@class VKVideoPlayerLayerView;

@protocol VKVideoPlayerViewDelegate <VKScrubberDelegate>
@property (nonatomic, readonly) VKVideoPlayerTrack* videoTrack;
- (void)fullScreenButtonTapped;
- (void)playButtonPressed;
- (void)pauseButtonPressed;
- (void)replayButtonPressed;

- (void)nextTrackButtonPressed;
- (void)previousTrackButtonPressed;
- (void)rewindButtonPressed;

- (void)nextTrackBySwipe;
- (void)previousTrackBySwipe;

- (void)captionButtonTapped;
- (void)videoQualityButtonTapped;

- (void)doneButtonTapped;

- (void)playerViewSingleTapped;
- (void)downloadButtonPressed;//:(VKVideoPlayerTrack *)videoTrack;

- (void)scrubbingBegin;
- (void)scrubbingEnd;

- (void)pinchIn;
- (void)pinchOut;

@end

@interface VKVideoPlayerView : UIView
@property (nonatomic, strong) IBOutlet UIView* view;
@property (nonatomic, strong) IBOutlet VKVideoPlayerLayerView* playerLayerView;
@property (nonatomic, strong) IBOutlet UIView* controls;
@property (nonatomic, strong) IBOutlet UIView* bottomControlOverlay;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView* activityIndicator;

@property (nonatomic, strong) IBOutlet RTPlayPauseButton* playButton;
@property (nonatomic, strong) IBOutlet UIButton* replayButton;
@property (nonatomic, strong) IBOutlet UILabel* currentTimeLabel;
@property (nonatomic, strong) IBOutlet VKScrubber* scrubber;
@property (nonatomic, strong) IBOutlet VKScrubber* progressBar;
@property (nonatomic, strong) IBOutlet UILabel* totalTimeLabel;
@property (nonatomic, strong) IBOutlet RTFullScreenButton* fullscreenButton;
@property (weak, nonatomic) IBOutlet UIButton *downloadButton;

@property (nonatomic, readonly) BOOL isControlsEnabled;
@property (nonatomic, readonly) BOOL isControlsHidden;

@property (nonatomic, weak) id<VKVideoPlayerViewDelegate> delegate;

@property (nonatomic, assign) NSInteger controlHideCountdown;

@property (nonatomic, strong) NSNumber* playerControlsAutoHideTime;
@property (weak, nonatomic) IBOutlet MPVolumeView *btAirPlay;
@property (nonatomic, getter=isAirplayButtonEnabled) BOOL airplayButtonEnabled;

- (IBAction)fullscreenButtonTapped:(id)sender;
- (IBAction)playButtonTapped:(id)sender;
- (IBAction)replayButtonTapped:(id)sender;
- (IBAction)downloadButtonTapped:(id)sender;

- (IBAction)handleSingleTap:(id)sender;
- (IBAction)handleSwipeLeft:(id)sender;
- (IBAction)handleSwipeRight:(id)sender;
- (IBAction)handlePinch:(id)sender;

- (void)resetTimeLabelsInit; // add by vince
- (void)updateTimeLabels;
- (void)setControlsHidden:(BOOL)hidden;
- (void)setControlsEnabled:(BOOL)enabled;
- (void)hideControlsIfNecessary;

- (void)setPlayButtonsSelected:(BOOL)selected;
- (void)setPlayButtonsEnabled:(BOOL)enabled;

- (void)addSubviewForControl:(UIView *)view;
- (void)addSubviewForControl:(UIView *)view toView:(UIView*)parentView;
- (void)addSubviewForControl:(UIView *)view toView:(UIView*)parentView forOrientation:(UIInterfaceOrientationMask)orientation;
- (void)removeControlView:(UIView*)view;

@end
