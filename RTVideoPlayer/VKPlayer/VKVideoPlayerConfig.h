//
//  Created by Viki.
//  Copyright (c) 2014 Viki Inc. All rights reserved.
//

//#ifndef VKVideoPlayer_VKVideoPlayerConfig_h
//#define VKVideoPlayer_VKVideoPlayerConfig_h

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>
#import <DDLog.h>

#import "VKFoundationLib.h"
#import "NSObject+VKFoundation.h"
#import "Reachability.h"

#define kVKVideoPlayerDurationDidLoadNotification @"VKVideoPlayerDurationDidLoadNotification"
#define kVKVideoPlayerItemReadyToPlay @"VKVideoPlayerItemReadyToPlay"
#define kVKVideoPlayerScrubberValueUpdatedNotification @"VKVideoPlayerScrubberValueUpdatedNotification"
#define kVKVideoPlayerShowVideoInfoNotification @"VKVideoPlayerShowVideoInfoNotification"
#define kVKVideoPlayerOrientationDidChange @"VKVideoPlayerOrientationDidChange"
#define kVKVideoPlayerUpdateVideoTrack @"VKVideoPlayerUpdateVideoTrack"

#define kVKVideoPlayerPlaybackBufferEmpty @"VKVideoPlayerPlaybackBufferEmpty"
#define kVKVideoPlayerPlaybackLikelyToKeepUp @"VKVideoPlayerPlaybackLikelyToKeepUp"

#define kVKVideoPlayerStateChanged @"VKVideoPlayerStateChanged"
#define kVKVideoPlayerDismiss @"VKVideoPlayerDismiss"
#define kVKVideoPlayerShare @"VKVideoPlayerShare"
