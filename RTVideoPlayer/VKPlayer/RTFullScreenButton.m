//
//  RTFullScreenButton.m
//  RTVideoPlayer
//
//  Created by Michael Yudin on 08.12.16.
//  Copyright © 2016 RT News. All rights reserved.
//

#import "RTFullScreenButton.h"

@interface RTFullScreenButton ()

@property (nonatomic, strong) CAShapeLayer *pathImageLayer;

@end

@implementation RTFullScreenButton

- (void)drawRect:(CGRect)rect {
    
    if (![_pathImageLayer superlayer]) {
        _pathImageLayer = [CAShapeLayer layer];
        _pathImageLayer.frame = rect;
        [self.layer addSublayer: _pathImageLayer];
        
        [self update:NO];
    }
    
    self.alpha = self.enabled ? 1.0 : 0.7;
}

- (void)setFullScreen:(BOOL)fullScreen;
{
    _fullScreen = fullScreen;
    
    [self update:YES];
}

- (void)update:(BOOL)animated;
{
    if (!animated) {
        self.pathImageLayer.fillColor = self.tintColor.CGColor;
        if (self.isFullScreen) {
            self.pathImageLayer.path = [self drawControllerNormalScreenCanvasWithFrame:self.bounds].CGPath;
            return;
        }
        self.pathImageLayer.path = [self drawControllerFullScreenCanvasWithFrame:self.bounds].CGPath;
        return;
    }
    if (self.isFullScreen) {
        [self animateNewPath:[self drawControllerNormalScreenCanvasWithFrame:self.bounds] inLayer:self.pathImageLayer];
        return;
    }
    [self animateNewPath:[self drawControllerFullScreenCanvasWithFrame:self.bounds] inLayer:self.pathImageLayer];
}

- (UIBezierPath *)drawControllerFullScreenCanvasWithFrame: (CGRect)frame
{
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    
    [bezierPath moveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.84091 * frame.size.width, CGRectGetMinY(frame) + 0.15914 * frame.size.height)];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.84091 * frame.size.width, CGRectGetMinY(frame) + 0.43229 * frame.size.height) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.84091 * frame.size.width, CGRectGetMinY(frame) + 0.15909 * frame.size.height) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.84091 * frame.size.width, CGRectGetMinY(frame) + 0.43229 * frame.size.height)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.75330 * frame.size.width, CGRectGetMinY(frame) + 0.32878 * frame.size.height)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.62839 * frame.size.width, CGRectGetMinY(frame) + 0.45794 * frame.size.height)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.54317 * frame.size.width, CGRectGetMinY(frame) + 0.37271 * frame.size.height)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.67229 * frame.size.width, CGRectGetMinY(frame) + 0.24777 * frame.size.height)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.56874 * frame.size.width, CGRectGetMinY(frame) + 0.15909 * frame.size.height)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.84091 * frame.size.width, CGRectGetMinY(frame) + 0.15909 * frame.size.height)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.84091 * frame.size.width, CGRectGetMinY(frame) + 0.15914 * frame.size.height)];
    [bezierPath closePath];

    [bezierPath moveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.37167 * frame.size.width, CGRectGetMinY(frame) + 0.54212 * frame.size.height)];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.45683 * frame.size.width, CGRectGetMinY(frame) + 0.62729 * frame.size.height) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.37161 * frame.size.width, CGRectGetMinY(frame) + 0.54206 * frame.size.height) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.45683 * frame.size.width, CGRectGetMinY(frame) + 0.62729 * frame.size.height)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.32771 * frame.size.width, CGRectGetMinY(frame) + 0.75223 * frame.size.height)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.43126 * frame.size.width, CGRectGetMinY(frame) + 0.84091 * frame.size.height)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.15909 * frame.size.width, CGRectGetMinY(frame) + 0.84091 * frame.size.height)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.15909 * frame.size.width, CGRectGetMinY(frame) + 0.56771 * frame.size.height)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.24670 * frame.size.width, CGRectGetMinY(frame) + 0.67122 * frame.size.height)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.37161 * frame.size.width, CGRectGetMinY(frame) + 0.54206 * frame.size.height)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.37167 * frame.size.width, CGRectGetMinY(frame) + 0.54212 * frame.size.height)];
    [bezierPath closePath];
    
    return bezierPath;
}

- (UIBezierPath *)drawControllerNormalScreenCanvasWithFrame: (CGRect)frame
{
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    
    [bezierPath moveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.54317 * frame.size.width, CGRectGetMinY(frame) + 0.45789 * frame.size.height)];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.54317 * frame.size.width, CGRectGetMinY(frame) + 0.18474 * frame.size.height) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.54317 * frame.size.width, CGRectGetMinY(frame) + 0.45794 * frame.size.height) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.54317 * frame.size.width, CGRectGetMinY(frame) + 0.18474 * frame.size.height)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.63078 * frame.size.width, CGRectGetMinY(frame) + 0.28825 * frame.size.height)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.75568 * frame.size.width, CGRectGetMinY(frame) + 0.15909 * frame.size.height)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.84091 * frame.size.width, CGRectGetMinY(frame) + 0.24432 * frame.size.height)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.71179 * frame.size.width, CGRectGetMinY(frame) + 0.36926 * frame.size.height)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.81534 * frame.size.width, CGRectGetMinY(frame) + 0.45794 * frame.size.height)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.54317 * frame.size.width, CGRectGetMinY(frame) + 0.45794 * frame.size.height)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.54317 * frame.size.width, CGRectGetMinY(frame) + 0.45789 * frame.size.height)];
    [bezierPath closePath];
    [bezierPath moveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.24426 * frame.size.width, CGRectGetMinY(frame) + 0.84085 * frame.size.height)];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.15909 * frame.size.width, CGRectGetMinY(frame) + 0.75568 * frame.size.height) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.24432 * frame.size.width, CGRectGetMinY(frame) + 0.84091 * frame.size.height) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.15909 * frame.size.width, CGRectGetMinY(frame) + 0.75568 * frame.size.height)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.28821 * frame.size.width, CGRectGetMinY(frame) + 0.63074 * frame.size.height)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.18466 * frame.size.width, CGRectGetMinY(frame) + 0.54206 * frame.size.height)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.45683 * frame.size.width, CGRectGetMinY(frame) + 0.54206 * frame.size.height)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.45683 * frame.size.width, CGRectGetMinY(frame) + 0.81526 * frame.size.height)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.36922 * frame.size.width, CGRectGetMinY(frame) + 0.71175 * frame.size.height)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.24432 * frame.size.width, CGRectGetMinY(frame) + 0.84091 * frame.size.height)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.24426 * frame.size.width, CGRectGetMinY(frame) + 0.84085 * frame.size.height)];
    [bezierPath closePath];
    
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
        pathAnimation.duration = 0.45;
        
        //        if (layer == self.layer)
        //            pathAnimation.delegate = self.layer;
        
        [layer addAnimation:pathAnimation
                     forKey:@"pathAnimation"];
    }
}

@end
