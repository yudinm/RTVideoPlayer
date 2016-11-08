//
//  MainDemoViewController.m
//  RTVideoPlayer
//
//  Created by Michael Yudin on 08.11.16.
//  Copyright © 2016 RT News. All rights reserved.
//

#import "MainDemoViewController.h"
#import "VKVideoPlayerViewController.h"

static DDLogLevel ddLogLevel = DDLogLevelAll;

@interface MainDemoViewController () <VKVideoPlayerDelegate>

@property (weak, nonatomic) IBOutlet UIView *vPlayerContainer;

@property (nonatomic, strong) VKVideoPlayerViewController *vkPlayerViewController;
//@property (nonatomic, strong) KWTransition *transition;

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
    }
    return _vkPlayerViewController;
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
    
    [self.vkPlayerViewController playVideoWithStreamURL:[NSURL URLWithString:@"https://cdn.rt.com/files/2016.10/580c5d3fc46188da708b45fd.mp4"]];
    
    DDLogInfo(@"OK. Start!");
}

#pragma mark - VKVideoPlayerControllerDelegate

- (void)videoPlayer:(VKVideoPlayer*)videoPlayer didControlByEvent:(VKVideoPlayerControlEvent)event {
    DDLogDebug(@"%s event:%d", __FUNCTION__, event);
    __weak __typeof(self) weakSelf = self;
    
    if (event == VKVideoPlayerControlEventTapDone) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    if (event == VKVideoPlayerControlEventTapFullScreen) {
        
        if ([self.presentedViewController isKindOfClass:[VKVideoPlayerViewController class]]) {
            VKVideoPlayerViewController *videoController = (VKVideoPlayerViewController *)self.presentedViewController;
            [videoController dismissViewControllerAnimated:YES completion:^{
                weakSelf.vkPlayerViewController.player.fullScreen = NO;
            }];
            return;
        }
        VKVideoPlayerViewController *videoController = [[VKVideoPlayerViewController alloc] initWithPlayer:self.vkPlayerViewController.player];
//        videoController.transitioningDelegate = self;
        videoController.view.tintColor = self.view.tintColor;
        [self presentViewController:videoController animated:YES completion:^{
            videoController.player.fullScreen = YES;
            videoController.player.delegate = weakSelf;
        }];
    }
    
}


@end
