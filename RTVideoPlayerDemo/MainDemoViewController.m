//
//  MainDemoViewController.m
//  RTVideoPlayer
//
//  Created by Michael Yudin on 08.11.16.
//  Copyright © 2016 RT News. All rights reserved.
//

#import "MainDemoViewController.h"

static DDLogLevel ddLogLevel = DDLogLevelAll;

@interface MainDemoViewController ()

@property (weak, nonatomic) IBOutlet UIView *vPlayerContainer;

//@property (nonatomic, strong) VKVideoPlayerViewController *vkPlayerViewController;
//@property (nonatomic, strong) KWTransition *transition;

@end

@implementation MainDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    DDLogInfo(@"OK. Start!");
}


@end
