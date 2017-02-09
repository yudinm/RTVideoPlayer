//
//  RTPiPButton.m
//  RTVideoPlayer
//
//  Created by Michael Yudin on 25.01.17.
//  Copyright © 2017. All rights reserved.
//

#import "RTPiPButton.h"

@interface RTPiPButton ()

@property (nonatomic, strong) CAShapeLayer *pathImageLayer;

@end

@implementation RTPiPButton

- (void)drawRect:(CGRect)rect {
    
    if (![_pathImageLayer superlayer]) {
        _pathImageLayer = [CAShapeLayer layer];
        _pathImageLayer.frame = rect;
        [self.layer addSublayer: _pathImageLayer];
        
        [self update:NO];
    }
    
    self.alpha = self.enabled ? 1.0 : 0.7;
}

- (void)setPiPEnabled:(BOOL)piPEnabled
{
    _piPEnabled = piPEnabled;
    
    [self update:YES];
}

- (void)update:(BOOL)animated;
{
    if (!animated) {
        self.pathImageLayer.fillColor = self.tintColor.CGColor;
        if (self.isPiPEnabled) {
            self.pathImageLayer.path = [self drawFromPiPWithFrame:self.bounds].CGPath;
            return;
        }
        self.pathImageLayer.path = [self drawToPiPWithFrame:self.bounds].CGPath;
        return;
    }
    if (self.isPiPEnabled) {
        [self animateNewPath:[self drawFromPiPWithFrame:self.bounds] inLayer:self.pathImageLayer];
        return;
    }
    [self animateNewPath:[self drawToPiPWithFrame:self.bounds] inLayer:self.pathImageLayer];
}

- (UIBezierPath *)drawFromPiPWithFrame: (CGRect)frame
{
    //// Color Declarations
    UIColor* fillColor = self.tintColor;
    
    //// Subframes
    CGRect group2 = CGRectMake(CGRectGetMinX(frame) + floor(frame.size.width * 0.11364 + 0.5), CGRectGetMinY(frame) + floor(frame.size.height * 0.22727 + 0.5), floor(frame.size.width * 0.90909 + 0.5) - floor(frame.size.width * 0.11364 + 0.5), floor(frame.size.height * 0.77273 + 0.5) - floor(frame.size.height * 0.22727 + 0.5));
    
    //// Bezier Drawing
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint: CGPointMake(CGRectGetMinX(group2) + 0.24485 * group2.size.width, CGRectGetMinY(group2) + 0.41662 * group2.size.height)];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(group2) + 0.28571 * group2.size.width, CGRectGetMinY(group2) + 0.35725 * group2.size.height) controlPoint1: CGPointMake(CGRectGetMinX(group2) + 0.24482 * group2.size.width, CGRectGetMinY(group2) + 0.41667 * group2.size.height) controlPoint2: CGPointMake(CGRectGetMinX(group2) + 0.28571 * group2.size.width, CGRectGetMinY(group2) + 0.35725 * group2.size.height)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(group2) + 0.13805 * group2.size.width, CGRectGetMinY(group2) + 0.14515 * group2.size.height)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(group2) + 0.18773 * group2.size.width, CGRectGetMinY(group2) + 0.08333 * group2.size.height)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(group2) + 0.05714 * group2.size.width, CGRectGetMinY(group2) + 0.08333 * group2.size.height)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(group2) + 0.05714 * group2.size.width, CGRectGetMinY(group2) + 0.27378 * group2.size.height)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(group2) + 0.09918 * group2.size.width, CGRectGetMinY(group2) + 0.20163 * group2.size.height)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(group2) + 0.21625 * group2.size.width, CGRectGetMinY(group2) + 0.37500 * group2.size.height)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(group2) + 0.24485 * group2.size.width, CGRectGetMinY(group2) + 0.41662 * group2.size.height)];
    [bezierPath closePath];
    [bezierPath moveToPoint: CGPointMake(CGRectGetMinX(group2) + 0.97143 * group2.size.width, CGRectGetMinY(group2) + 0.47917 * group2.size.height)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(group2) + 0.32857 * group2.size.width, CGRectGetMinY(group2) + 0.47917 * group2.size.height)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(group2) + 0.32857 * group2.size.width, CGRectGetMinY(group2) + 0.95833 * group2.size.height)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(group2) + 0.97143 * group2.size.width, CGRectGetMinY(group2) + 0.95833 * group2.size.height)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(group2) + 0.97143 * group2.size.width, CGRectGetMinY(group2) + 0.47917 * group2.size.height)];
    [bezierPath closePath];
    [bezierPath moveToPoint: CGPointMake(CGRectGetMinX(group2) + 1.00000 * group2.size.width, CGRectGetMinY(group2) + 0.43753 * group2.size.height)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(group2) + 1.00000 * group2.size.width, CGRectGetMinY(group2) + 1.00000 * group2.size.height)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(group2) + 0.30000 * group2.size.width, CGRectGetMinY(group2) + 1.00000 * group2.size.height)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(group2) + 0.30000 * group2.size.width, CGRectGetMinY(group2) + 0.43750 * group2.size.height)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(group2) + 1.00000 * group2.size.width, CGRectGetMinY(group2) + 0.43750 * group2.size.height)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(group2) + 1.00000 * group2.size.width, CGRectGetMinY(group2) + 0.43753 * group2.size.height)];
    [bezierPath closePath];
    [bezierPath moveToPoint: CGPointMake(CGRectGetMinX(group2) + 1.00000 * group2.size.width, CGRectGetMinY(group2) + 0.00001 * group2.size.height)];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(group2) + 1.00000 * group2.size.width, CGRectGetMinY(group2) + 0.39583 * group2.size.height) controlPoint1: CGPointMake(CGRectGetMinX(group2) + 1.00000 * group2.size.width, CGRectGetMinY(group2) + 0.00001 * group2.size.height) controlPoint2: CGPointMake(CGRectGetMinX(group2) + 1.00000 * group2.size.width, CGRectGetMinY(group2) + 0.22868 * group2.size.height)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(group2) + 0.97143 * group2.size.width, CGRectGetMinY(group2) + 0.39583 * group2.size.height)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(group2) + 0.97143 * group2.size.width, CGRectGetMinY(group2) + 0.04167 * group2.size.height)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(group2) + 0.02857 * group2.size.width, CGRectGetMinY(group2) + 0.04167 * group2.size.height)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(group2) + 0.02857 * group2.size.width, CGRectGetMinY(group2) + 0.93750 * group2.size.height)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(group2) + 0.27143 * group2.size.width, CGRectGetMinY(group2) + 0.93750 * group2.size.height)];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(group2) + 0.27143 * group2.size.width, CGRectGetMinY(group2) + 0.97917 * group2.size.height) controlPoint1: CGPointMake(CGRectGetMinX(group2) + 0.27143 * group2.size.width, CGRectGetMinY(group2) + 0.94686 * group2.size.height) controlPoint2: CGPointMake(CGRectGetMinX(group2) + 0.27143 * group2.size.width, CGRectGetMinY(group2) + 0.96922 * group2.size.height)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(group2) + 0.00000 * group2.size.width, CGRectGetMinY(group2) + 0.97917 * group2.size.height)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(group2) + 0.00000 * group2.size.width, CGRectGetMinY(group2) + 0.00000 * group2.size.height)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(group2) + 1.00000 * group2.size.width, CGRectGetMinY(group2) + 0.00001 * group2.size.height)];
    [bezierPath closePath];
    [bezierPath moveToPoint: CGPointMake(CGRectGetMinX(group2) + 0.57145 * group2.size.width, CGRectGetMinY(group2) + 0.58335 * group2.size.height)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(group2) + 0.66427 * group2.size.width, CGRectGetMinY(group2) + 0.64929 * group2.size.height)];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(group2) + 0.66429 * group2.size.width, CGRectGetMinY(group2) + 0.78472 * group2.size.height) controlPoint1: CGPointMake(CGRectGetMinX(group2) + 0.66429 * group2.size.width, CGRectGetMinY(group2) + 0.69114 * group2.size.height) controlPoint2: CGPointMake(CGRectGetMinX(group2) + 0.66429 * group2.size.width, CGRectGetMinY(group2) + 0.74239 * group2.size.height)];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(group2) + 0.57143 * group2.size.width, CGRectGetMinY(group2) + 0.85417 * group2.size.height) controlPoint1: CGPointMake(CGRectGetMinX(group2) + 0.61786 * group2.size.width, CGRectGetMinY(group2) + 0.81944 * group2.size.height) controlPoint2: CGPointMake(CGRectGetMinX(group2) + 0.57143 * group2.size.width, CGRectGetMinY(group2) + 0.85417 * group2.size.height)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(group2) + 0.57143 * group2.size.width, CGRectGetMinY(group2) + 0.58333 * group2.size.height)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(group2) + 0.57145 * group2.size.width, CGRectGetMinY(group2) + 0.58335 * group2.size.height)];
    [bezierPath closePath];
    [bezierPath moveToPoint: CGPointMake(CGRectGetMinX(group2) + 0.66434 * group2.size.width, CGRectGetMinY(group2) + 0.64934 * group2.size.height)];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(group2) + 0.75714 * group2.size.width, CGRectGetMinY(group2) + 0.71528 * group2.size.height) controlPoint1: CGPointMake(CGRectGetMinX(group2) + 0.66585 * group2.size.width, CGRectGetMinY(group2) + 0.65042 * group2.size.height) controlPoint2: CGPointMake(CGRectGetMinX(group2) + 0.75714 * group2.size.width, CGRectGetMinY(group2) + 0.71528 * group2.size.height)];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(group2) + 0.66429 * group2.size.width, CGRectGetMinY(group2) + 0.78472 * group2.size.height) controlPoint1: CGPointMake(CGRectGetMinX(group2) + 0.75714 * group2.size.width, CGRectGetMinY(group2) + 0.71528 * group2.size.height) controlPoint2: CGPointMake(CGRectGetMinX(group2) + 0.71071 * group2.size.width, CGRectGetMinY(group2) + 0.75000 * group2.size.height)];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(group2) + 0.66429 * group2.size.width, CGRectGetMinY(group2) + 0.64931 * group2.size.height) controlPoint1: CGPointMake(CGRectGetMinX(group2) + 0.66429 * group2.size.width, CGRectGetMinY(group2) + 0.76315 * group2.size.height) controlPoint2: CGPointMake(CGRectGetMinX(group2) + 0.66429 * group2.size.width, CGRectGetMinY(group2) + 0.64931 * group2.size.height)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(group2) + 0.66434 * group2.size.width, CGRectGetMinY(group2) + 0.64934 * group2.size.height)];
    [bezierPath closePath];
//    [fillColor setFill];
//    [bezierPath fill];

    return bezierPath;
}

- (UIBezierPath *)drawToPiPWithFrame: (CGRect)frame
{
    //// Color Declarations
    UIColor* fillColor = self.tintColor;
    
    //// Subframes
    CGRect group2 = CGRectMake(CGRectGetMinX(frame) + floor(frame.size.width * 0.11364 + 0.5), CGRectGetMinY(frame) + floor(frame.size.height * 0.22727 + 0.5), floor(frame.size.width * 0.90909 + 0.5) - floor(frame.size.width * 0.11364 + 0.5), floor(frame.size.height * 0.77273 + 0.5) - floor(frame.size.height * 0.22727 + 0.5));
    
    //// Bezier Drawing
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint: CGPointMake(CGRectGetMinX(group2) + 0.09801 * group2.size.width, CGRectGetMinY(group2) + 0.08338 * group2.size.height)];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(group2) + 0.05714 * group2.size.width, CGRectGetMinY(group2) + 0.14275 * group2.size.height) controlPoint1: CGPointMake(CGRectGetMinX(group2) + 0.09804 * group2.size.width, CGRectGetMinY(group2) + 0.08333 * group2.size.height) controlPoint2: CGPointMake(CGRectGetMinX(group2) + 0.05714 * group2.size.width, CGRectGetMinY(group2) + 0.14275 * group2.size.height)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(group2) + 0.20481 * group2.size.width, CGRectGetMinY(group2) + 0.35485 * group2.size.height)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(group2) + 0.15512 * group2.size.width, CGRectGetMinY(group2) + 0.41667 * group2.size.height)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(group2) + 0.28571 * group2.size.width, CGRectGetMinY(group2) + 0.41667 * group2.size.height)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(group2) + 0.28571 * group2.size.width, CGRectGetMinY(group2) + 0.22622 * group2.size.height)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(group2) + 0.24368 * group2.size.width, CGRectGetMinY(group2) + 0.29837 * group2.size.height)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(group2) + 0.18375 * group2.size.width, CGRectGetMinY(group2) + 0.20833 * group2.size.height)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(group2) + 0.09801 * group2.size.width, CGRectGetMinY(group2) + 0.08338 * group2.size.height)];
    [bezierPath closePath];
    [bezierPath moveToPoint: CGPointMake(CGRectGetMinX(group2) + 0.97143 * group2.size.width, CGRectGetMinY(group2) + 0.47917 * group2.size.height)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(group2) + 0.32857 * group2.size.width, CGRectGetMinY(group2) + 0.47917 * group2.size.height)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(group2) + 0.32857 * group2.size.width, CGRectGetMinY(group2) + 0.95833 * group2.size.height)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(group2) + 0.97143 * group2.size.width, CGRectGetMinY(group2) + 0.95833 * group2.size.height)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(group2) + 0.97143 * group2.size.width, CGRectGetMinY(group2) + 0.47917 * group2.size.height)];
    [bezierPath closePath];
    [bezierPath moveToPoint: CGPointMake(CGRectGetMinX(group2) + 1.00000 * group2.size.width, CGRectGetMinY(group2) + 0.43753 * group2.size.height)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(group2) + 1.00000 * group2.size.width, CGRectGetMinY(group2) + 1.00000 * group2.size.height)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(group2) + 0.30000 * group2.size.width, CGRectGetMinY(group2) + 1.00000 * group2.size.height)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(group2) + 0.30000 * group2.size.width, CGRectGetMinY(group2) + 0.43750 * group2.size.height)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(group2) + 1.00000 * group2.size.width, CGRectGetMinY(group2) + 0.43750 * group2.size.height)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(group2) + 1.00000 * group2.size.width, CGRectGetMinY(group2) + 0.43753 * group2.size.height)];
    [bezierPath closePath];
    [bezierPath moveToPoint: CGPointMake(CGRectGetMinX(group2) + 1.00000 * group2.size.width, CGRectGetMinY(group2) + 0.00001 * group2.size.height)];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(group2) + 1.00000 * group2.size.width, CGRectGetMinY(group2) + 0.39583 * group2.size.height) controlPoint1: CGPointMake(CGRectGetMinX(group2) + 1.00000 * group2.size.width, CGRectGetMinY(group2) + 0.00001 * group2.size.height) controlPoint2: CGPointMake(CGRectGetMinX(group2) + 1.00000 * group2.size.width, CGRectGetMinY(group2) + 0.22868 * group2.size.height)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(group2) + 0.97143 * group2.size.width, CGRectGetMinY(group2) + 0.39583 * group2.size.height)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(group2) + 0.97143 * group2.size.width, CGRectGetMinY(group2) + 0.04167 * group2.size.height)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(group2) + 0.02857 * group2.size.width, CGRectGetMinY(group2) + 0.04167 * group2.size.height)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(group2) + 0.02857 * group2.size.width, CGRectGetMinY(group2) + 0.93750 * group2.size.height)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(group2) + 0.27143 * group2.size.width, CGRectGetMinY(group2) + 0.93750 * group2.size.height)];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(group2) + 0.27143 * group2.size.width, CGRectGetMinY(group2) + 0.97917 * group2.size.height) controlPoint1: CGPointMake(CGRectGetMinX(group2) + 0.27143 * group2.size.width, CGRectGetMinY(group2) + 0.94686 * group2.size.height) controlPoint2: CGPointMake(CGRectGetMinX(group2) + 0.27143 * group2.size.width, CGRectGetMinY(group2) + 0.96922 * group2.size.height)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(group2) + 0.00000 * group2.size.width, CGRectGetMinY(group2) + 0.97917 * group2.size.height)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(group2) + 0.00000 * group2.size.width, CGRectGetMinY(group2) + 0.00000 * group2.size.height)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(group2) + 1.00000 * group2.size.width, CGRectGetMinY(group2) + 0.00001 * group2.size.height)];
    [bezierPath closePath];
    [bezierPath moveToPoint: CGPointMake(CGRectGetMinX(group2) + 0.57145 * group2.size.width, CGRectGetMinY(group2) + 0.58335 * group2.size.height)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(group2) + 0.66427 * group2.size.width, CGRectGetMinY(group2) + 0.64929 * group2.size.height)];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(group2) + 0.66429 * group2.size.width, CGRectGetMinY(group2) + 0.78472 * group2.size.height) controlPoint1: CGPointMake(CGRectGetMinX(group2) + 0.66429 * group2.size.width, CGRectGetMinY(group2) + 0.69114 * group2.size.height) controlPoint2: CGPointMake(CGRectGetMinX(group2) + 0.66429 * group2.size.width, CGRectGetMinY(group2) + 0.74239 * group2.size.height)];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(group2) + 0.57143 * group2.size.width, CGRectGetMinY(group2) + 0.85417 * group2.size.height) controlPoint1: CGPointMake(CGRectGetMinX(group2) + 0.61786 * group2.size.width, CGRectGetMinY(group2) + 0.81944 * group2.size.height) controlPoint2: CGPointMake(CGRectGetMinX(group2) + 0.57143 * group2.size.width, CGRectGetMinY(group2) + 0.85417 * group2.size.height)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(group2) + 0.57143 * group2.size.width, CGRectGetMinY(group2) + 0.58333 * group2.size.height)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(group2) + 0.57145 * group2.size.width, CGRectGetMinY(group2) + 0.58335 * group2.size.height)];
    [bezierPath closePath];
    [bezierPath moveToPoint: CGPointMake(CGRectGetMinX(group2) + 0.66434 * group2.size.width, CGRectGetMinY(group2) + 0.64934 * group2.size.height)];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(group2) + 0.75714 * group2.size.width, CGRectGetMinY(group2) + 0.71528 * group2.size.height) controlPoint1: CGPointMake(CGRectGetMinX(group2) + 0.66585 * group2.size.width, CGRectGetMinY(group2) + 0.65042 * group2.size.height) controlPoint2: CGPointMake(CGRectGetMinX(group2) + 0.75714 * group2.size.width, CGRectGetMinY(group2) + 0.71528 * group2.size.height)];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(group2) + 0.66429 * group2.size.width, CGRectGetMinY(group2) + 0.78472 * group2.size.height) controlPoint1: CGPointMake(CGRectGetMinX(group2) + 0.75714 * group2.size.width, CGRectGetMinY(group2) + 0.71528 * group2.size.height) controlPoint2: CGPointMake(CGRectGetMinX(group2) + 0.71071 * group2.size.width, CGRectGetMinY(group2) + 0.75000 * group2.size.height)];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(group2) + 0.66429 * group2.size.width, CGRectGetMinY(group2) + 0.64931 * group2.size.height) controlPoint1: CGPointMake(CGRectGetMinX(group2) + 0.66429 * group2.size.width, CGRectGetMinY(group2) + 0.76315 * group2.size.height) controlPoint2: CGPointMake(CGRectGetMinX(group2) + 0.66429 * group2.size.width, CGRectGetMinY(group2) + 0.64931 * group2.size.height)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(group2) + 0.66434 * group2.size.width, CGRectGetMinY(group2) + 0.64934 * group2.size.height)];
    [bezierPath closePath];
//    [fillColor setFill];
//    [bezierPath fill];
    
    return bezierPath;
}

- (void)animateNewPath:(UIBezierPath *)newPath
               inLayer:(CAShapeLayer *)layer;
{
    CGPathRef oldPath = layer.path;
    layer.path = newPath.CGPath;
    layer.fillColor = self.tintColor.CGColor;
    
    BOOL animate = oldPath != nil;
    if (animate)
    {
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
        [pathAnimation setFromValue:(__bridge id) oldPath];
        [pathAnimation setToValue:(__bridge id)newPath.CGPath];
        pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        pathAnimation.duration = 0.25;
        //        pathAnimation.delegate = self;
        
        [layer addAnimation:pathAnimation
                     forKey:@"pathAnimation"];
    }
}

@end
