//
//  PKActivityIndicator.h
//  PKRefreshControlDemo
//
//  Created by shimokawa on 1/12/15.
//  Copyright (c) 2015 Goodpatch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PKActivityIndicator : UIView
@property (nonatomic) UIColor *barColor;
@property (nonatomic) CGFloat barWidth;
@property (nonatomic) CGFloat barHeight;
@property (nonatomic) CGFloat aperture;

- (void)setSpinnerReplicatorInstanceCountWithPercentage:(CGFloat)percentage;
- (void)startAnimating;
- (void)stopAnimating;
- (BOOL)isAnimating;
@end
