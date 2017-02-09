//
//  MainDemoViewController.m
//  RTVideoPlayer
//
//  Created by Michael Yudin on 08.11.16.
//  Copyright © 2016. All rights reserved.
//

#import "MainDemoViewController.h"
#import "VKVideoPlayerViewController.h"
#import "RTFullScreenTransition.h"

static DDLogLevel ddLogLevel = DDLogLevelWarning;

static NSString *stringURL = @"https://cdn.rt.com/files/2017.01/5879d7d2c4618866678b45e3.mp4";

@interface MainDemoViewController () <VKVideoPlayerDelegate, UIViewControllerTransitioningDelegate>

@property (weak, nonatomic) IBOutlet UIView *vPlayerContainer;
@property (nonatomic, strong) VKVideoPlayerViewController *vkPlayerViewController;
@property (nonatomic, strong) RTFullScreenTransition *transition;
@property (nonatomic, strong) VKVideoPlayerViewController *vkPlayerViewController_fullScreen;

@end

@implementation MainDemoViewController

#pragma mark - Lazy

- (VKVideoPlayerViewController *)vkPlayerViewController;
{
    if (!_vkPlayerViewController) {
        _vkPlayerViewController = [[VKVideoPlayerViewController alloc] init];
        _vkPlayerViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
        _vkPlayerViewController.player.delegate = self;
        _vkPlayerViewController.player.view.playerControlsAutoHideTime = @10;
        _vkPlayerViewController.player.view.airplayButtonEnabled = YES;
    }
    return _vkPlayerViewController;
}

- (RTFullScreenTransition *)transition;
{
    if (!_transition) {
        _transition = [[RTFullScreenTransition alloc] init];
    }
    return _transition;
}

- (VKVideoPlayerViewController *)vkPlayerViewController_fullScreen;
{
    if (!_vkPlayerViewController_fullScreen) {
        _vkPlayerViewController_fullScreen = [[VKVideoPlayerViewController alloc] initWithPlayer:self.vkPlayerViewController.player];
        _vkPlayerViewController_fullScreen.transitioningDelegate = self;
        _vkPlayerViewController_fullScreen.view.tintColor = self.view.tintColor;
        _vkPlayerViewController_fullScreen.modalPresentationStyle = UIModalPresentationOverFullScreen;
        _vkPlayerViewController_fullScreen.player.view.airplayButtonEnabled = YES;
    }
    return _vkPlayerViewController_fullScreen;
}

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive: YES error: nil];
    
    [self addChildViewController:self.vkPlayerViewController];
    
    UIView *subview = self.vkPlayerViewController.view;
    
    [self.vPlayerContainer addSubview:subview];
    [self.vPlayerContainer addConstraints:[NSLayoutConstraint
                                           constraintsWithVisualFormat:@"H:|-0@999-[subview]-0@999-|"
                                           options:NSLayoutFormatDirectionLeadingToTrailing
                                           metrics:nil
                                           views:NSDictionaryOfVariableBindings(subview)]];
    [self.vPlayerContainer addConstraints:[NSLayoutConstraint
                                           constraintsWithVisualFormat:@"V:|-0@999-[subview]-0@999-|"
                                           options:NSLayoutFormatDirectionLeadingToTrailing
                                           metrics:nil
                                           views:NSDictionaryOfVariableBindings(subview)]];
    
    [self.vkPlayerViewController didMoveToParentViewController:self];
    
    NSURL *url = [NSURL URLWithString:stringURL];
    [self.vkPlayerViewController playVideoWithStreamURL:url];
}

- (void)viewWillAppear:(BOOL)animated;
{
    [super viewWillAppear:animated];
    [self.view layoutIfNeeded];
}

- (void)viewDidDisappear:(BOOL)animated;
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - VKVideoPlayerControllerDelegate

- (void)videoPlayer:(VKVideoPlayer*)videoPlayer didControlByEvent:(VKVideoPlayerControlEvent)event;
{
    DDLogDebug(@"%s event:%d", __FUNCTION__, event);
    
    if (event == VKVideoPlayerControlEventTapDone) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    if (event == VKVideoPlayerControlEventTapFullScreen) {
        
        if ([self.presentedViewController isKindOfClass:[VKVideoPlayerViewController class]]) {
            [self toNormalScreenVideo];
            return;
        }
        [self toFullScreenVideo];
    }
    
    if (event == VKVideoPlayerControlEventDownload) {
        DDLogInfo(@"VKVideoPlayerControlEventDownload");
    }
    
}

- (void)toNormalScreenVideo;
{
    if (!self.vkPlayerViewController.player.fullScreen || ![self.presentedViewController isKindOfClass:[VKVideoPlayerViewController class]]) {
        return;
    }
    __weak __typeof(self) weakSelf = self;
    VKVideoPlayerViewController *videoController = (VKVideoPlayerViewController *)self.presentedViewController;
    [videoController dismissViewControllerAnimated:YES completion:^{
        weakSelf.vkPlayerViewController.player.fullScreen = NO;
        [weakSelf.vkPlayerViewController_fullScreen removeFromParentViewController];
        _vkPlayerViewController_fullScreen = nil;
        [UIView performWithoutAnimation:^{
            
            [weakSelf.vPlayerContainer addSubview:weakSelf.vkPlayerViewController.player.view];
            
        }];
    }];
}

- (void)toFullScreenVideo;
{
    if (self.vkPlayerViewController_fullScreen.player.fullScreen || self.presentedViewController == self.vkPlayerViewController_fullScreen) {
        return;
    }
    __weak __typeof(self) weakSelf = self;
    UIView *snapShot = [self.vPlayerContainer snapshotViewAfterScreenUpdates:YES];
    [self.vPlayerContainer insertSubview:snapShot atIndex:self.vPlayerContainer.subviews.count - 1];
    [self.vkPlayerViewController_fullScreen updatePlayerView];
    [self.vkPlayerViewController presentViewController:self.vkPlayerViewController_fullScreen animated:YES completion:^{
        weakSelf.vkPlayerViewController_fullScreen.player.fullScreen = YES;
        weakSelf.vkPlayerViewController_fullScreen.player.delegate = weakSelf;
        [snapShot removeFromSuperview];
    }];
    
}

- (void)handlePinchIn:(VKVideoPlayer *)videoPlayer;
{
    [self toFullScreenVideo];
}

- (void)handlePinchOut:(VKVideoPlayer *)videoPlayer;
{
    [self toNormalScreenVideo];
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                   presentingController:(UIViewController *)presenting
                                                                       sourceController:(UIViewController *)source {
    self.transition.action = RTTransitionStepPresent;
    self.transition.sourceView = self.vPlayerContainer;
    [(VKVideoPlayerViewController *)presented updatePlayerView];
    
    return self.transition;
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    self.transition.action = RTTransitionStepDismiss;
    self.transition.sourceView = self.vPlayerContainer;
    return self.transition;
}


@end
