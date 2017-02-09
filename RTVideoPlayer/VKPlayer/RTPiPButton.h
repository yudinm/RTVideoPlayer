//
//  RTPiPButton.h
//  RTVideoPlayer
//
//  Created by Michael Yudin on 25.01.17.
//  Copyright © 2017. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RTPiPButton : UIButton

@property (nonatomic, getter=isPiPEnabled) BOOL piPEnabled;

- (void)update:(BOOL)animated;

@end
