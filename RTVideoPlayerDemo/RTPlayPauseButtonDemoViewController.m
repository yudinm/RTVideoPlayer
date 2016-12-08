//
//  RTPlayPauseButtonDemoViewController.m
//  RTVideoPlayer
//
//  Created by Michael Yudin on 07.12.16.
//  Copyright © 2016 RT News. All rights reserved.
//

#import "RTPlayPauseButtonDemoViewController.h"
#import "RTPlayPauseButton.h"
#import "RTFullScreenButton.h"

@interface RTPlayPauseButtonDemoViewController ()

@property (weak, nonatomic) IBOutlet RTPlayPauseButton *btTest;
@property (weak, nonatomic) IBOutlet RTFullScreenButton *btTestFullScreen;

@end

@implementation RTPlayPauseButtonDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)btTestDidTapped:(id)sender {
    self.btTest.playing = !self.btTest.isPlaying;
}

- (IBAction)btFullScreenDidTapped:(id)sender {
    self.btTestFullScreen.fullScreen = !self.btTestFullScreen.isFullScreen;
}

@end
