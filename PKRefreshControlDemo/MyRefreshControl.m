//
//  MyRefreshControl.m
//  PKRefreshControlDemo
//
//  Created by shimokawa on 1/25/15.
//  Copyright (c) 2015 Goodpatch. All rights reserved.
//

#import "MyRefreshControl.h"
#import "PKActivityIndicator.h"

@interface MyRefreshControl ()
@property (nonatomic) CGFloat threshold;
@property (nonatomic) PKActivityIndicator *indicator;
@end

@implementation MyRefreshControl

- (void)initialize {
    self.indicator = [[PKActivityIndicator alloc] initWithFrame:CGRectMake(0, 0, self.threshold, self.threshold)];
    self.indicator.center = CGPointMake(self.center.x, self.threshold/2);
    [self addSubview:self.indicator];
}

- (void)pullAnimationWithPercentage:(CGFloat)percentage {
    self.indicator.alpha = 1;
    [self.indicator setSpinnerReplicatorInstanceCountWithPercentage:percentage];
}

- (void)startRefreshingAnimation {
    [self.indicator startAnimating];
    
    [UIView animateWithDuration:2.0 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.indicator.transform = CGAffineTransformRotate(self.indicator.transform, M_PI);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)endRefreshingAnimation {
    [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGAffineTransform transform = CGAffineTransformRotate(self.indicator.transform, M_PI);
        self.indicator.transform = CGAffineTransformScale(transform, 0.1, 0.1);
        self.indicator.alpha = 0;
    } completion:^(BOOL finished) {
        [self.indicator stopAnimating];
        [self.indicator setSpinnerReplicatorInstanceCountWithPercentage:0];
        self.indicator.transform = CGAffineTransformIdentity;
    }];
}

@end
