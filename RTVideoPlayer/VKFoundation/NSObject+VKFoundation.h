//
//  Created by Viki.
//  Copyright (c) 2014 Viki Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (VKFoundation)

- (id)preferredValueForKey:(NSString*)key languageCode:(NSString*)languageCode;
- (id)valueForKeyPathWithNilCheck:(NSString *)keyPath;

+ (NSString *)floatToIntString:(float)num;
+ (NSString *)doubleToIntString:(double)num;
+ (NSString *)readableValueWithBytes:(id)bytes;
+ (NSString *)timeStringFromSecondsValue:(int)seconds;

@end

void RUN_ON_UI_THREAD(dispatch_block_t block);
