//
//  RTFullScreenTransition.m
//  RTVideoPlayer
//
//  Created by Michael Yudin on 28.11.16.
//  Copyright © 2016 RT News. All rights reserved.
//

#import "RTFullScreenTransition.h"

@interface RTFullScreenTransition ()

@end

@implementation RTFullScreenTransition

#pragma mark UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext;
{
    return self.duration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext;
{

    UIViewController *fromVC = [[[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey] childViewControllers] firstObject];
    UIViewController *fromParentVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    CGRect fromRect = [transitionContext initialFrameForViewController:fromVC];
    UIView *containerView = [transitionContext containerView];

    if (self.action == RTTransitionStepDismiss) {
        fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        fromRect = [transitionContext initialFrameForViewController:fromVC];
        
        fromVC.view.clipsToBounds = YES;
        [containerView addSubview:fromVC.view];
        containerView.backgroundColor = [UIColor clearColor];
        fromParentVC.view.superview.backgroundColor = [UIColor clearColor];
        
        UIView *subview = fromVC.view;
        
        [containerView addConstraints:[NSLayoutConstraint
                                   constraintsWithVisualFormat:@"H:|-0@999-[subview]-0@999-|"
                                   options:NSLayoutFormatDirectionLeadingToTrailing
                                   metrics:nil
                                   views:NSDictionaryOfVariableBindings(subview)]];
        [containerView addConstraints:[NSLayoutConstraint
                                   constraintsWithVisualFormat:@"V:|-0@999-[subview]-0@999-|"
                                   options:NSLayoutFormatDirectionLeadingToTrailing
                                   metrics:nil
                                   views:NSDictionaryOfVariableBindings(subview)]];
        CGRect fr = fromVC.view.frame;
        fr.size = containerView.bounds.size;
        fromVC.view.frame = fr;
        
        [UIView animateKeyframesWithDuration:.5f delay:0.f options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
            CGRect fr = fromVC.view.frame;
            fr.size = self.sourceView.bounds.size;
            fromVC.view.frame = fr;
            fromVC.view.center = self.sourceView.center;
            [fromVC.view layoutIfNeeded];
        } completion:^(__unused BOOL finished) {
            [transitionContext completeTransition:YES];
            [fromVC.view layoutIfNeeded];
        }];

        return;
    }
    
//    [(VKVideoPlayerViewController *)presented updatePlayerView];
//    [toVC performSelector:@selector(updatePlayerView) withObject:nil afterDelay:0.0];

    [containerView addSubview:toVC.view];
    
    UIView *subview = toVC.view;
    [containerView addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"H:|-0@999-[subview]-0@999-|"
                               options:NSLayoutFormatDirectionLeadingToTrailing
                               metrics:nil
                               views:NSDictionaryOfVariableBindings(subview)]];
    [containerView addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"V:|-0@999-[subview]-0@999-|"
                               options:NSLayoutFormatDirectionLeadingToTrailing
                               metrics:nil
                               views:NSDictionaryOfVariableBindings(subview)]];
    
    
    CGPoint center = self.sourceView.center;
    CGRect fr = toVC.view.frame;
    fr.size = self.sourceView.bounds.size;
    toVC.view.frame = fr;
    toVC.view.clipsToBounds = YES;
    toVC.view.center = center;

    [UIView animateKeyframesWithDuration:.5f delay:0.f options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        
        CGRect fr = toVC.view.frame;
        fr.size = containerView.bounds.size;
        toVC.view.frame = fr;

        toVC.view.center = containerView.center;
        [toVC.view layoutIfNeeded];
    } completion:^(__unused BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
}


@end
