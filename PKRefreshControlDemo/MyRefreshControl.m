//
//  MyRefreshControl.m
//  PKRefreshControlDemo
//
//  Created by shimokawa on 1/25/15.
//  Copyright (c) 2015 Goodpatch. All rights reserved.
//

#import "MyRefreshControl.h"

@interface MyRefreshControl ()
@property (nonatomic) CGFloat openedHeight;

@property (nonatomic) CAShapeLayer *shapeLayer;
@end

@implementation MyRefreshControl

- (void)pullAnimationWithPercentage:(CGFloat)percentage
{
    if (!self.shapeLayer) {
        self.shapeLayer = [CAShapeLayer layer];
        UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 40, 40)];
        self.shapeLayer.path = circlePath.CGPath;
        
        self.shapeLayer.strokeColor = [UIColor clearColor].CGColor;
        self.shapeLayer.fillColor = [UIColor blueColor].CGColor;
        
        [self.layer addSublayer:self.shapeLayer];
    }
    
    self.shapeLayer.opacity = 1;
    self.shapeLayer.transform = CATransform3DScale(CATransform3DIdentity, percentage, percentage, 1.0f);
}

- (void)startRefreshingAnimation
{
    [self.shapeLayer removeAllAnimations];
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    animation.duration = 1.5;
    animation.repeatCount = HUGE_VALF;
    NSMutableArray *values = @[@1, @1.2, @1].mutableCopy;
    animation.values = values;
    [self.shapeLayer addAnimation:animation forKey:@"popAnimation"];
}

- (void)endRefreshingAnimation
{
    [self.shapeLayer removeAllAnimations];
    [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.shapeLayer.transform = CATransform3DScale(CATransform3DIdentity, .1, .1, 1.0f);
        self.shapeLayer.opacity = 0;
    } completion:nil];
}

@end
