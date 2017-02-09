//
//  RTFullScreenTransition.h
//  RTVideoPlayer
//
//  Created by Michael Yudin on 28.11.16.
//  Copyright © 2016. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, RTTransitionStep){
    RTTransitionStepDismiss = 0,	/* Moving back to the inital step */
    RTTransitionStepPresent		/* Moving to the modal */
};

@interface RTFullScreenTransition : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic) NSTimeInterval duration;
@property (nonatomic) RTTransitionStep action;
@property (nonatomic, weak) UIView *sourceView;

@end
