//
//  RTPlayPauseButton.h
//  RTVideoPlayer
//
//  Created by Michael Yudin on 07.12.16.
//  Copyright © 2016 RT News. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RTPlayPauseButton : UIButton

@property (nonatomic, getter=isPlaying) BOOL playing;

- (void)update:(BOOL)animated;

@end
