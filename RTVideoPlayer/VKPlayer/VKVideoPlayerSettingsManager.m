//
//  Created by Viki.
//  Copyright (c) 2014 Viki Inc. All rights reserved.
//

#import "VKVideoPlayerSettingsManager.h"
#import "VKVideoPlayerConfig.h"

@implementation VKVideoPlayerSettingsManager

+ (VKVideoPlayerSettingsManager*)sharedInstance {
  static id sharedInstance = nil;
  
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [[self alloc] init];
  });
  
  return sharedInstance;
}

- (NSArray*)subtitleSizes {
  return @[
           NSLocalizedString(@"subtitleSize.tiny", nil),
           NSLocalizedString(@"subtitleSize.medium", nil),
           NSLocalizedString(@"subtitleSize.large", nil),
           NSLocalizedString(@"subtitleSize.huge", nil),
           ];
}

@end
