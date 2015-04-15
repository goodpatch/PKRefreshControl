//
//  PKActivityIndicator.m
//  PKRefreshControlDemo
//
//  Created by shimokawa on 1/12/15.
//  Copyright (c) 2015 Goodpatch. All rights reserved.
//

#import "PKActivityIndicator.h"

static const NSUInteger PKActivityIndicatorInstanceMaxCount = 12;
static const CGFloat PKActivityIndicatorDefaultSpeed = 1.0;
static NSString * const PKActivityIndicatorAnimationKey = @"PKActivityIndicatorAnimationKey";

@interface PKActivityIndicator ()
@property (nonatomic) CALayer *marker;
@property (nonatomic) CAReplicatorLayer *spinnerReplicator;
@property (nonatomic) CGFloat hudSize;
@property (nonatomic) NSInteger numberOfBars;
@property (nonatomic) CABasicAnimation *fadeAnimation;

- (void)commonInit;
@end

@implementation PKActivityIndicator

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    [self setBackgroundColor:[UIColor clearColor]];

    self.marker.opacity = 1.0;
    self.spinnerReplicator.transform = CATransform3DRotate(self.spinnerReplicator.transform, M_PI, 0.0f, 0.0f, 1.0f);
    self.aperture = 10.0;
    self.barWidth = 2.0;
    self.barHeight = 8.0;
    self.barColor = [UIColor colorWithWhite:0 alpha:.8];
    self.numberOfBars = 12.0;
    
    [self createLayers];
    [self updateLayers];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.hudSize = CGRectGetWidth(self.bounds);
    [self updateLayers];
}

- (void)updateLayers
{
    // Update marker
    [self.marker setBounds:CGRectMake(0.0f, 0.0f, _barWidth, _barHeight)]; // size of the rectangle marker
    [self.marker setCornerRadius:_barWidth/2];
    [self.marker setBackgroundColor:[_barColor CGColor]];
    [self.marker setPosition:CGPointMake(self.hudSize * 0.5f, self.hudSize * 0.5f + _aperture)];
    
    // Update replicaitons
    [self.spinnerReplicator setBounds:CGRectMake(0.0f, 0.0f, self.hudSize, self.hudSize)];
    [self.spinnerReplicator setCornerRadius:10.0f];
    [self.spinnerReplicator setPosition:CGPointMake(CGRectGetMidX(self.bounds),
                                                    CGRectGetMidY(self.bounds))];
    
    CGFloat angle = (2.0f * M_PI) / (self.numberOfBars);
    CATransform3D instanceRotation = CATransform3DMakeRotation(angle, 0.0f, 0.0f, 1.0f);
    [self.spinnerReplicator setInstanceCount:self.numberOfBars];
    [self.spinnerReplicator setInstanceTransform:instanceRotation];
}

- (void)createLayers {
    [self.spinnerReplicator addSublayer:self.marker];
    [self.layer addSublayer:self.spinnerReplicator];
    
    [self.marker setOpacity:0.0f]; // will be visible thanks to the animation
}

#pragma mark - public methods

- (void)startAnimating {
    self.marker.opacity = 1.0;
    [self.fadeAnimation setDuration:PKActivityIndicatorDefaultSpeed];
    CGFloat markerAnimationDuration = PKActivityIndicatorDefaultSpeed / self.numberOfBars;
    [self.spinnerReplicator setInstanceDelay:markerAnimationDuration];
    [self.marker addAnimation:self.fadeAnimation forKey:PKActivityIndicatorAnimationKey];
    self.spinnerReplicator.instanceCount = PKActivityIndicatorInstanceMaxCount;
}

- (void)stopAnimating
{
    [self.marker removeAnimationForKey:PKActivityIndicatorAnimationKey];
}

- (BOOL)isAnimating
{
    return [self.marker animationForKey:PKActivityIndicatorAnimationKey] != nil;
}

- (void)setSpinnerReplicatorInstanceCountWithPercentage:(CGFloat)percentage {
    CGFloat l = 0.4;
    self.marker.opacity = MIN(1,percentage/l);
    NSInteger count = MAX(0,percentage) * PKActivityIndicatorInstanceMaxCount;
    self.spinnerReplicator.instanceCount = count;
}

#pragma mark - Accessor

- (CALayer *)marker {
    if (!_marker) {
        _marker = [CALayer layer];
    }
    return _marker;
}

- (CAReplicatorLayer *)spinnerReplicator {
    if (!_spinnerReplicator) {
        _spinnerReplicator = [CAReplicatorLayer layer];
    }
    return _spinnerReplicator;
}

- (CABasicAnimation *)fadeAnimation {
    if (!_fadeAnimation) {
        _fadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    }
    
    [_fadeAnimation setFromValue:[NSNumber numberWithFloat:1.0f]];
    [_fadeAnimation setToValue:[NSNumber numberWithFloat:0.0f]];
    [_fadeAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    [_fadeAnimation setRepeatCount:HUGE_VALF];
    
    return _fadeAnimation;
}

- (void)setBarColor:(UIColor *)barColor {
    _barColor = barColor;
    [self updateLayers];
}

- (void)setBarWidth:(CGFloat)barWidth {
    _barWidth = barWidth;
    [self updateLayers];
}

- (void)setBarHeight:(CGFloat)barHeight {
    _barHeight = barHeight;
    [self updateLayers];
}

- (void)setAperture:(CGFloat)aperture {
    _aperture = aperture;
    [self updateLayers];
}

@end
