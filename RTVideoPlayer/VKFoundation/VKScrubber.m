//
//  Created by Viki.
//  Copyright (c) 2014 Viki Inc. All rights reserved.
//

#import "VKScrubber.h"
#import <CocoaLumberjack/CocoaLumberjack.h>

#ifdef DEBUG
  static const int ddLogLevel = DDLogLevelWarning;
#else
  static const int ddLogLevel = DDLogLevelWarning;
#endif

@interface VKScrubber ()
@property (nonatomic, strong) UIImageView *scrubberGlow;
@end

@implementation VKScrubber

@synthesize delegate = _delegate;

- (void) initialize {

  [self setMaximumTrackImage:[[[UIImage imageNamed:@"VKScrubber_max"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
      resizableImageWithCapInsets:UIEdgeInsetsMake(0, 4, 0, 4)]
      forState:UIControlStateNormal];
    self.maximumTrackTintColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.2];
  [self setMinimumTrackImage:[[[UIImage imageNamed:@"VKScrubber_min"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
      resizableImageWithCapInsets:UIEdgeInsetsMake(0, 4, 0, 4)]
      forState:UIControlStateNormal];
//    self.minimumTrackTintColor = [self.superview.tintColor colorWithAlphaComponent:0.7];
    if (self.userInteractionEnabled) {
        [self setThumbImage:[[UIImage imageNamed:@"VKScrubber_thumb"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
                   forState:UIControlStateNormal];        
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
}

@end
