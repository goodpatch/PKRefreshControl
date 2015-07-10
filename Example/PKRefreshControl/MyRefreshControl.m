 //
//  MyRefreshControl.m
//  PKRefreshControl
//
//  Created by shimokawa on 7/10/15.
//  Copyright (c) 2015 Seiya Shimokawa. All rights reserved.
//

#import "MyRefreshControl.h"

@implementation MyRefreshControl
- (void)initialize {
    self.indicator = [[PKActivityIndicator alloc] init];
    self.indicator.center = CGPointMake(self.center.x, super.threshold/2);
    self.indicator.aperture = 10;
    self.indicator.barHeight = 4;
    self.indicator.barWidth = 4;
    [self addSubview:self.indicator];
}

- (void)pullAnimationWithPercentage:(CGFloat)percentage {
    self.indicator.alpha = 1;
    CGFloat scale = 2.0 - percentage;
    self.indicator.transform = CGAffineTransformScale(CGAffineTransformIdentity, scale, scale);
    [self.indicator setSpinnerReplicatorInstanceCountWithPercentage:percentage];
}

- (void)startRefreshingAnimation {
    [self pullAnimationWithPercentage:1];
    [self.indicator startAnimating];
    
    [UIView animateWithDuration:2.0 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.indicator.transform = CGAffineTransformRotate(self.indicator.transform, M_PI);
    } completion:nil];
}

- (void)endRefreshingAnimation {
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGAffineTransform transform = CGAffineTransformRotate(self.indicator.transform, M_PI);
        self.indicator.transform = CGAffineTransformScale(transform, 0.1, 0.1);
        self.indicator.alpha = 0;
    } completion:^(BOOL finished) {
        [self.indicator stopAnimating];
    }];
}
@end
