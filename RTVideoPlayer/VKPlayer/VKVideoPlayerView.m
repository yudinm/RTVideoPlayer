//
//  Created by Viki.
//  Copyright (c) 2014 Viki Inc. All rights reserved.
//

#import "VKVideoPlayerView.h"
#import "VKScrubber.h"
#import <QuartzCore/QuartzCore.h>
#import "DDLog.h"
#import "VKVideoPlayerConfig.h"
#import "VKFoundationLib.h"
#import "VKScrubber.h"
#import "VKVideoPlayerTrack.h"
#import "VKVideoPlayerSettingsManager.h"

#define PADDING 8

#ifdef DEBUG
static const int ddLogLevel = DDLogLevelWarning;
#else
static const int ddLogLevel = DDLogLevelWarning;
#endif

@interface VKVideoPlayerView()

@property (nonatomic, strong) NSMutableArray* customControls;
@property (nonatomic, strong) NSMutableArray* portraitControls;
@property (nonatomic, strong) NSMutableArray* landscapeControls;

@property (nonatomic, assign) BOOL isControlsEnabled;
@property (nonatomic, assign) BOOL isControlsHidden;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btAirPlayWidthHidder;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btAirPlaySpacerHidder;
@property (strong, nonatomic) IBOutlet UIPinchGestureRecognizer *pinchGesture;

@end

@implementation VKVideoPlayerView

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.scrubber removeObserver:self forKeyPath:@"maximumValue"];
}

- (void)initialize {
    
    self.customControls = [NSMutableArray array];
    self.portraitControls = [NSMutableArray array];
    self.landscapeControls = [NSMutableArray array];
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    self.view.frame = self.frame;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self addSubview:self.view];

    [self.scrubber addObserver:self forKeyPath:@"maximumValue" options:0 context:nil];
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(durationDidLoad:) name:kVKVideoPlayerDurationDidLoadNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(scrubberValueUpdated:) name:kVKVideoPlayerScrubberValueUpdatedNotification object:nil];
    
    [self.scrubber addTarget:self action:@selector(updateTimeLabels) forControlEvents:UIControlEventValueChanged];
    
    [self.controls setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.5]];
    self.fullscreenButton.hidden = NO;
    self.playerControlsAutoHideTime = @2.5;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void) awakeFromNib {
    [super awakeFromNib];
    [self initialize];
}

#pragma - VKVideoPlayerViewDelegates

- (IBAction)playButtonTapped:(id)sender {
    
    UIButton* playButton;
    if ([sender isKindOfClass:[UIButton class]]) {
        playButton = (UIButton*)sender;
    }
    
    if (!self.playButton.playing) {
        [self.delegate playButtonPressed];
    } else {
        [self.delegate pauseButtonPressed];
    }
}

- (IBAction)replayButtonTapped:(id)sender {
    
    _replayButton.hidden = YES;
    _playButton.hidden = NO;
    
    [self.delegate replayButtonPressed];
    //    [self setPlayButtonsSelected:NO];
    self.playButton.playing = YES;
    
}

- (IBAction)nextTrackButtonPressed:(id)sender {
    [self.delegate nextTrackButtonPressed];
}

- (IBAction)previousTrackButtonPressed:(id)sender {
    [self.delegate previousTrackButtonPressed];
}

- (IBAction)rewindButtonPressed:(id)sender {
    [self.delegate rewindButtonPressed];
}

- (IBAction)fullscreenButtonTapped:(id)sender {
    self.fullscreenButton.fullScreen = !self.fullscreenButton.fullScreen;
    [self.delegate fullScreenButtonTapped];
}

- (IBAction)captionButtonTapped:(id)sender {
    [self.delegate captionButtonTapped];
}

- (IBAction)videoQualityButtonTapped:(id)sender {
    [self.delegate videoQualityButtonTapped];
}

- (IBAction)doneButtonTapped:(id)sender {
    [self.delegate doneButtonTapped];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.scrubber) {
        if ([keyPath isEqualToString:@"maximumValue"]) {
            DDLogVerbose(@"scrubber Value change: %f", self.scrubber.value);
            RUN_ON_UI_THREAD(^{
                [self updateTimeLabels];
            });
        }
    }
}

- (void)setDelegate:(id<VKVideoPlayerViewDelegate>)delegate {
    _delegate = delegate;
    self.scrubber.delegate = delegate;
}

- (void)durationDidLoad:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    NSNumber* duration = [info objectForKey:@"duration"];
    [self.delegate videoTrack].totalVideoDuration = duration;
    RUN_ON_UI_THREAD(^{
        self.scrubber.maximumValue = [duration floatValue];
        self.progressBar.maximumValue = [duration floatValue];
        self.scrubber.hidden = NO;
    });
}

- (void)scrubberValueUpdated:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    RUN_ON_UI_THREAD(^{
        DDLogVerbose(@"scrubberValueUpdated: %@", [info objectForKey:@"scrubberValue"]);
        [self.scrubber setValue:[[info objectForKey:@"scrubberValue"] floatValue] animated:YES];
        [self updateTimeLabels];
    });
}

-(void)resetTimeLabelsInit{
    [self.currentTimeLabel setText:@"00:00"];
    [self.totalTimeLabel setText:@"00:00"];
    [self.progressBar setValue:0.0];
    [self.scrubber setValue:0.0];
    [self updateTimeLabels];
}

- (void)updateTimeLabels {
    DDLogVerbose(@"Updating TimeLabels: %f", self.scrubber.value);
    
    self.currentTimeLabel.text = [NSObject timeStringFromSecondsValue:(int)self.scrubber.value];
    self.totalTimeLabel.text = [NSObject timeStringFromSecondsValue:(int)self.scrubber.maximumValue];
    
    [self layoutSlider];
}

- (void)layoutSliderForOrientation;
{
    [self.progressBar setFrame:self.scrubber.frame];
}

- (void)layoutSlider {
    [self layoutSliderForOrientation];
}

- (void)setPlayButtonsSelected:(BOOL)selected {
    self.playButton.selected = selected;
}

- (void)setPlayButtonsEnabled:(BOOL)enabled {
    self.playButton.enabled = enabled;
}

- (void)setControlsEnabled:(BOOL)enabled {
    
    [self setPlayButtonsEnabled:enabled];
    
    self.scrubber.enabled = enabled;
    self.fullscreenButton.enabled = enabled;
    self.isControlsEnabled = enabled;
    
    NSMutableArray *controlList = self.customControls.mutableCopy;
    [controlList addObjectsFromArray:self.portraitControls];
    [controlList addObjectsFromArray:self.landscapeControls];
    for (UIView *control in controlList) {
        if ([control isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton*)control;
            button.enabled = enabled;
        }
    }
}

- (IBAction)handleSingleTap:(id)sender {
    [self setControlsHidden:!self.isControlsHidden];
    if (!self.isControlsHidden) {
        self.controlHideCountdown = [self.playerControlsAutoHideTime integerValue];
    }
    [self.delegate playerViewSingleTapped];
}

- (IBAction)handleSwipeLeft:(id)sender {
    [self.delegate nextTrackBySwipe];
}

- (IBAction)handleSwipeRight:(id)sender {
    [self.delegate previousTrackBySwipe];
}

- (IBAction)handlePinch:(id)sender;
{
    UIPinchGestureRecognizer *gesture = (UIPinchGestureRecognizer *)sender;
    gesture.scale > 2.0 || gesture.velocity > 5.0 ? [self.delegate pinchIn] : [self.delegate pinchOut];
}

- (void)setControlHideCountdown:(NSInteger)controlHideCountdown {
    if (controlHideCountdown == 0) {
        [self setControlsHidden:YES];
    } else {
        [self setControlsHidden:NO];
    }
    _controlHideCountdown = controlHideCountdown;
}

- (void)hideControlsIfNecessary {
    if (self.isControlsHidden) return;
    if (self.controlHideCountdown == -1) {
        [self setControlsHidden:NO];
    } else if (self.controlHideCountdown == 0) {
        [self setControlsHidden:YES];
    } else {
        self.controlHideCountdown--;
    }
}

- (void)setControlsHidden:(BOOL)hidden {
    DDLogVerbose(@"Controls: %@", hidden ? @"hidden" : @"visible");
    
    if (self.isControlsHidden != hidden) {
        self.isControlsHidden = hidden;
        
        if (hidden) {
            [UIView animateWithDuration:0.35 delay:0.0 options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction animations:^{
                [self.controls setAlpha:0];
                [self.bottomControlOverlay setTransform:CGAffineTransformMakeTranslation(0, 60)];
            } completion:^(BOOL finished) {
                
            }];
        }else{
            [UIView animateWithDuration:0.35 delay:0.0 options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction animations:^{
                [self.controls setAlpha:1];
                [self.bottomControlOverlay setTransform:CGAffineTransformMakeTranslation(0, 0)];
            } completion:^(BOOL finished) {
                
            }];
        }
        
        
    }
}

- (void)setAirplayButtonEnabled:(BOOL)airplayButtonEnabled;
{
    _airplayButtonEnabled = airplayButtonEnabled;
    self.btAirPlay.hidden = !airplayButtonEnabled;
    if (airplayButtonEnabled) {
        self.btAirPlayWidthHidder.priority = 1;
        self.btAirPlaySpacerHidder.priority = 1;
        [UIView animateWithDuration:0.3 animations:^{
            [self layoutIfNeeded];
        }];
        return;
    }
    self.btAirPlayWidthHidder.priority = 999;
    self.btAirPlaySpacerHidder.priority = 999;
    [UIView animateWithDuration:0.3 animations:^{
        [self layoutIfNeeded];
    }];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[VKScrubber class]] ||
        [touch.view isKindOfClass:[UIButton class]]) {
        // prevent recognizing touches on the slider
        return NO;
    }
    return YES;
}

- (void)addSubviewForControl:(UIView *)view {
    [self addSubviewForControl:view toView:self];
}
- (void)addSubviewForControl:(UIView *)view toView:(UIView*)parentView {
    [self addSubviewForControl:view toView:parentView forOrientation:UIInterfaceOrientationMaskAll];
}
- (void)addSubviewForControl:(UIView *)view toView:(UIView*)parentView forOrientation:(UIInterfaceOrientationMask)orientation {
    view.hidden = self.isControlsHidden;
    if (orientation == UIInterfaceOrientationMaskAll) {
        [self.customControls addObject:view];
    } else if (orientation == UIInterfaceOrientationMaskPortrait) {
        [self.portraitControls addObject:view];
    } else if (orientation == UIInterfaceOrientationMaskLandscape) {
        [self.landscapeControls addObject:view];
    }
    [parentView addSubview:view];
}
- (void)removeControlView:(UIView*)view {
    [view removeFromSuperview];
    [self.customControls removeObject:view];
    [self.landscapeControls removeObject:view];
    [self.portraitControls removeObject:view];
}

@end
