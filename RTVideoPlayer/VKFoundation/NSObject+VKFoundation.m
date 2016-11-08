//
//  Created by Viki.
//  Copyright (c) 2014 Viki Inc. All rights reserved.
//

#import "NSObject+VKFoundation.h"
#import "VKFoundationLib.h"

@implementation NSObject (VKFoundation)

- (id)preferredValueForKey:(NSString*)key languageCode:(NSString*)languageCode {
  id defaultValue = [self valueForKeyPathWithNilCheck:[NSString stringWithFormat:@"%@.%@", key, @"en"]];
  id preferredValue = nil;
  if ([languageCode isEqualToString:@"en"]) {
    preferredValue = defaultValue;
  } else {
    preferredValue = [self valueForKeyPathWithNilCheck:[NSString stringWithFormat:@"%@.%@", key, languageCode]];
    if (preferredValue) {
      if ([preferredValue isKindOfClass:[NSString class]]) {
        NSString* preferredString = (NSString*)preferredValue;
        if ([preferredString length] == 0) {
          preferredValue = defaultValue;
        }
      }
    } else {
      preferredValue = defaultValue;
    }
  }
  return preferredValue;
}


- (id)valueForKeyPathWithNilCheck:(NSString *)keyPath {
  if ([self respondsToSelector:@selector(valueForKeyPath:)]) {
    return NILIFNULL([self valueForKeyPath:keyPath]);
  } else return nil;
}

+ (NSString *)floatToIntString:(float)num {
    return [NSString stringWithFormat:@"%ld", (long)[[NSNumber numberWithFloat:num] integerValue]];
}

+ (NSString *)doubleToIntString:(double)num {
    return [NSString stringWithFormat:@"%ld", (long)[[NSNumber numberWithDouble:num] integerValue]];
}

+ (NSString *)readableValueWithBytes:(id)bytes{
    NSString *readable = @"";
    //round bytes to one kilobyte, if less than 1024 bytes
    if (([bytes longLongValue] < 1024)){
        readable = [NSString stringWithFormat:@"1 KB"];
    }
    //kilobytes
    if (([bytes longLongValue]/1024)>=1){
        readable = [NSString stringWithFormat:@"%lld KB", ([bytes longLongValue]/1024)];
    }
    //megabytes
    if (([bytes longLongValue]/1024/1024)>=1){
        readable = [NSString stringWithFormat:@"%lld MB", ([bytes longLongValue]/1024/1024)];
    }
    //gigabytes
    if (([bytes longLongValue]/1024/1024/1024)>=1){
        readable = [NSString stringWithFormat:@"%lld GB", ([bytes longLongValue]/1024/1024/1024)];
    }
    //terabytes
    if (([bytes longLongValue]/1024/1024/1024/1024)>=1){
        readable = [NSString stringWithFormat:@"%lld TB", ([bytes longLongValue]/1024/1024/1024/1024)];
    }
    //petabytes
    if (([bytes longLongValue]/1024/1024/1024/1024/1024)>=1){
        readable = [NSString stringWithFormat:@"%lld PB", ([bytes longLongValue]/1024/1024/1024/1024/1024)];
    }
    return readable;
}

+ (NSString *)timeStringFromSecondsValue:(int)seconds;
{
    NSString *retVal;
    int hours = seconds / 3600;
    int minutes = (seconds / 60) % 60;
    int secs = seconds % 60;
    if (hours > 0) {
        retVal = [NSString stringWithFormat:@"%01d:%02d:%02d", hours, minutes, secs];
    } else {
        retVal = [NSString stringWithFormat:@"%02d:%02d", minutes, secs];
    }
    return retVal;
}

@end

void RUN_ON_UI_THREAD(dispatch_block_t block) {
  if ([NSThread isMainThread]) {
    block();
  } else {
    dispatch_sync(dispatch_get_main_queue(), block);
  }
}
