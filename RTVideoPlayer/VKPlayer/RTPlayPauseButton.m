//
//  RTPlayPauseButton.m
//  RTVideoPlayer
//
//  Created by Michael Yudin on 07.12.16.
//  Copyright © 2016 RT News. All rights reserved.
//

#import "RTPlayPauseButton.h"

@interface RTPlayPauseButton ()

@property (nonatomic, strong) CAShapeLayer *pathImageLayer;

@end

@implementation RTPlayPauseButton

- (void)drawRect:(CGRect)rect {
    
    if (![_pathImageLayer superlayer]) {
        _pathImageLayer = [CAShapeLayer layer];
        _pathImageLayer.frame = rect;
        [self.layer addSublayer: _pathImageLayer];
        
        [self update:NO];
    }
    
    self.alpha = self.enabled ? 1.0 : 0.7;
}

- (void)setPlaying:(BOOL)playing;
{
    _playing = playing;
    
    [self update:YES];
}

- (void)update:(BOOL)animated;
{
    if (!animated) {
        self.pathImageLayer.fillColor = self.tintColor.CGColor;
        if (self.isPlaying) {
            self.pathImageLayer.path = [self drawControllerPauseCanvasWithFrame:self.bounds].CGPath;
            return;
        }
        self.pathImageLayer.path = [self drawControllerPlayCanvasWithFrame:self.bounds].CGPath;
        return;
    }
    if (self.isPlaying) {
        [self animateNewPath:[self drawControllerPauseCanvasWithFrame:self.bounds] inLayer:self.pathImageLayer];
        return;
    }
    [self animateNewPath:[self drawControllerPlayCanvasWithFrame:self.bounds] inLayer:self.pathImageLayer];
}

- (UIBezierPath *)drawControllerPauseCanvasWithFrame: (CGRect)frame
{
    frame = CGRectInset(frame, self.contentEdgeInsets.left, self.contentEdgeInsets.top);
    
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.15915 * frame.size.width, CGRectGetMinY(frame) + 0.09095 * frame.size.height)];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.43182 * frame.size.width, CGRectGetMinY(frame) + 0.09091 * frame.size.height) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.15909 * frame.size.width, CGRectGetMinY(frame) + 0.09091 * frame.size.height) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.43182 * frame.size.width, CGRectGetMinY(frame) + 0.09091 * frame.size.height)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.43182 * frame.size.width, CGRectGetMinY(frame) + 0.90909 * frame.size.height)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.15909 * frame.size.width, CGRectGetMinY(frame) + 0.90909 * frame.size.height)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.15909 * frame.size.width, CGRectGetMinY(frame) + 0.09091 * frame.size.height)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.15915 * frame.size.width, CGRectGetMinY(frame) + 0.09095 * frame.size.height)];
    [bezierPath closePath];
    
    [bezierPath moveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.56835 * frame.size.width, CGRectGetMinY(frame) + 0.09114 * frame.size.height)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.84091 * frame.size.width, CGRectGetMinY(frame) + 0.09091 * frame.size.height)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.84091 * frame.size.width, CGRectGetMinY(frame) + 0.90909 * frame.size.height)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.56818 * frame.size.width, CGRectGetMinY(frame) + 0.90909 * frame.size.height)];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.56818 * frame.size.width, CGRectGetMinY(frame) + 0.09091 * frame.size.height) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.56818 * frame.size.width, CGRectGetMinY(frame) + 0.90909 * frame.size.height) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.56818 * frame.size.width, CGRectGetMinY(frame) + 0.21487 * frame.size.height)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.56835 * frame.size.width, CGRectGetMinY(frame) + 0.09114 * frame.size.height)];
    [bezierPath closePath];
    
    return bezierPath;
}

- (UIBezierPath *)drawControllerPlayCanvasWithFrame: (CGRect)frame
{
    frame = CGRectInset(frame, self.contentEdgeInsets.left, self.contentEdgeInsets.top);
    
    UIBezierPath* bezier2Path = [UIBezierPath bezierPath];
    [bezier2Path moveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.09098 * frame.size.width, CGRectGetMinY(frame) + 0.04549 * frame.size.height)];
    [bezier2Path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.49991 * frame.size.width, CGRectGetMinY(frame) + 0.26685 * frame.size.height) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.09091 * frame.size.width, CGRectGetMinY(frame) + 0.04545 * frame.size.height) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.49991 * frame.size.width, CGRectGetMinY(frame) + 0.26685 * frame.size.height)];
    [bezier2Path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.50000 * frame.size.width, CGRectGetMinY(frame) + 0.72145 * frame.size.height) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.50000 * frame.size.width, CGRectGetMinY(frame) + 0.40732 * frame.size.height) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.50000 * frame.size.width, CGRectGetMinY(frame) + 0.57934 * frame.size.height)];
    [bezier2Path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.09091 * frame.size.width, CGRectGetMinY(frame) + 0.95455 * frame.size.height) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.29545 * frame.size.width, CGRectGetMinY(frame) + 0.83800 * frame.size.height) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.09091 * frame.size.width, CGRectGetMinY(frame) + 0.95455 * frame.size.height)];
    [bezier2Path addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.09091 * frame.size.width, CGRectGetMinY(frame) + 0.04545 * frame.size.height)];
    [bezier2Path addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.09098 * frame.size.width, CGRectGetMinY(frame) + 0.04549 * frame.size.height)];
    [bezier2Path closePath];
    
    [bezier2Path moveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.50023 * frame.size.width, CGRectGetMinY(frame) + 0.26703 * frame.size.height)];
    [bezier2Path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.90909 * frame.size.width, CGRectGetMinY(frame) + 0.48834 * frame.size.height) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.50688 * frame.size.width, CGRectGetMinY(frame) + 0.27063 * frame.size.height) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.90909 * frame.size.width, CGRectGetMinY(frame) + 0.48834 * frame.size.height)];
    [bezier2Path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.50000 * frame.size.width, CGRectGetMinY(frame) + 0.72145 * frame.size.height) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.90909 * frame.size.width, CGRectGetMinY(frame) + 0.48834 * frame.size.height) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.70455 * frame.size.width, CGRectGetMinY(frame) + 0.60490 * frame.size.height)];
    [bezier2Path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.50000 * frame.size.width, CGRectGetMinY(frame) + 0.48864 * frame.size.height) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.50000 * frame.size.width, CGRectGetMinY(frame) + 0.64903 * frame.size.height) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.50000 * frame.size.width, CGRectGetMinY(frame) + 0.48864 * frame.size.height)];
    [bezier2Path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.50000 * frame.size.width, CGRectGetMinY(frame) + 0.26690 * frame.size.height) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.50000 * frame.size.width, CGRectGetMinY(frame) + 0.48864 * frame.size.height) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.50000 * frame.size.width, CGRectGetMinY(frame) + 0.33577 * frame.size.height)];
    [bezier2Path addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.50023 * frame.size.width, CGRectGetMinY(frame) + 0.26703 * frame.size.height)];
    [bezier2Path closePath];
    
    return bezier2Path;
}

- (void)animateNewPath:(UIBezierPath *)newPath
               inLayer:(CAShapeLayer *)layer;
{
    [layer removeAllAnimations];
    
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
