//
//  Created by Viki.
//  Copyright (c) 2014 Viki Inc. All rights reserved.
//

#import "VKSlider.h"

@protocol VKScrubberDelegate <NSObject>
- (void)scrubbingBegin;
- (void)scrubbingEnd;
@optional
- (void)scrubberValueChanged;
@end

@interface VKScrubber : VKSlider <VKScrubberDelegate>

@property (nonatomic, weak) id <VKScrubberDelegate> delegate;

@end
