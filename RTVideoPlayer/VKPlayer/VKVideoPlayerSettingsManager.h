//
//  Created by Viki.
//  Copyright (c) 2014 Viki Inc. All rights reserved.
//

#define VKSharedVideoPlayerSettingsManager [VKVideoPlayerSettingsManager sharedInstance]

#define kVKSettingsSubtitleLanguageCodeKey              @"VKSettingsSubtitleLanguageCode"
#define kVKSettingsSubtitleSizeKey                      @"VKSettingsSubtitleSizeCode"
#define kVKSettingsSubtitlesEnabledKey                  @"VKSettingsSubtitlesEnabled"
#define kVKSettingsTopSubtitlesEnabledKey               @"VKSettingsTopSubtitlesEnabled"


#define kVKVideoQualityKey  @"VKVideoQualityKey"
#define kVKVideoQualityAuto @"settings.videoSection.videoQuality.auto"
#define kVKVideoQuality240p @"settings.videoSection.videoQuality.240p"
#define kVKVideoQuality360p @"settings.videoSection.videoQuality.360p"
#define kVKVideoQuality480p @"settings.videoSection.videoQuality.480p"
#define kVKVideoQuality720p @"settings.videoSection.videoQuality.720p"

#import <Foundation/Foundation.h>

@interface VKVideoPlayerSettingsManager : NSObject

+ (VKVideoPlayerSettingsManager*)sharedInstance;
@property (nonatomic, strong) NSString* videoQuality;
@property (nonatomic, strong) NSArray* videoQualityOptions;
@property (nonatomic, readonly) BOOL isSubtitlesEnabled;
@property (nonatomic, readonly) BOOL isTopSubtitlesEnabled;
@property (nonatomic, readonly) NSString* subtitleLanguageCode;
@property (nonatomic, readonly) NSString* subtitleSizeDescription;


@end
