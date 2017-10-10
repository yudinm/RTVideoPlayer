//
//  Created by Viki.
//  Copyright (c) 2014 Viki Inc. All rights reserved.
//

#import "VKScrubber.h"
#import <CocoaLumberjack/CocoaLumberjack.h>

#ifdef DEBUG
  static DDLogLevel ddLogLevel = DDLogLevelWarning;
#else
  static DDLogLevel ddLogLevel = DDLogLevelWarning;
#endif

@interface VKScrubber ()
@property (nonatomic, strong) UIImageView *scrubberGlow;
@end

@implementation VKScrubber

@synthesize delegate = _delegate;

- (void) initialize {

    NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"Resources" ofType:@"bundle"]];
    UIImage *image  = [UIImage imageNamed:@"VKScrubber_max" inBundle:bundle compatibleWithTraitCollection:nil];
    
    [self setMaximumTrackImage:[[image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
      resizableImageWithCapInsets:UIEdgeInsetsMake(0, 4, 0, 4)]
      forState:UIControlStateNormal];
    self.maximumTrackTintColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.2];
    
    image  = [UIImage imageNamed:@"VKScrubber_min" inBundle:bundle compatibleWithTraitCollection:nil];
    [self setMinimumTrackImage:[[image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
      resizableImageWithCapInsets:UIEdgeInsetsMake(0, 4, 0, 4)]
      forState:UIControlStateNormal];
//    self.minimumTrackTintColor = [self.superview.tintColor colorWithAlphaComponent:0.7];
    if (self.userInteractionEnabled) {
        image  = [UIImage imageNamed:@"VKScrubber_thumb" inBundle:bundle compatibleWithTraitCollection:nil];
        [self setThumbImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
                   forState:UIControlStateNormal];        
        [self setThumbImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
                   forState:UIControlStateHighlighted];
    }
  
  [self addTarget:self action:@selector(scrubbingBegin) forControlEvents:UIControlEventTouchDown];
  [self addTarget:self action:@selector(scrubbingEnd) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside|UIControlEventTouchCancel];
  [self addTarget:self action:@selector(scrubberValueChanged) forControlEvents:UIControlEventValueChanged];
  
  self.exclusiveTouch = YES;
}

- (void)scrubbingBegin {
  DDLogVerbose(@"SCRUBBER: Begin %f", self.value);
  [self.delegate scrubbingBegin];
}

- (void)scrubbingEnd {
  DDLogVerbose(@"SCRUBBER: End %f", self.value);
  [self.delegate scrubbingEnd];
}

- (void)scrubberValueChanged {
  DDLogVerbose(@"SCRUBBER: Change %f", self.value);
  [self.delegate scrubberValueChanged];
}

@end
