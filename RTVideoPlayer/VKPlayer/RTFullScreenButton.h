//
//  RTFullScreenButton.h
//  RTVideoPlayer
//
//  Created by Michael Yudin on 08.12.16.
//  Copyright © 2016 RT News. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RTFullScreenButton : UIButton

@property (nonatomic, getter=isFullScreen) BOOL fullScreen;

- (void)update:(BOOL)animated;

@end
