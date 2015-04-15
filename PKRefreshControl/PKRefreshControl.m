//
//  PKRefreshControl.m
//  PKRefreshControlDemo
//
//  Created by shimokawa on 12/24/14.
//  Copyright (c) 2014 Goodpatch. All rights reserved.
//

#import "PKRefreshControl.h"

typedef NS_ENUM(NSUInteger, PKRefreshControlState) {
    PKRefreshControlStateNone,
    PKRefreshControlStateLoading,
    PKRefreshControlStateReadyToEnd,
    PKRefreshControlStateEnd,
};

@interface PKRefreshControl ()
@property (nonatomic) CGFloat threshold;
@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic) UIEdgeInsets originalContentInset;
@property (nonatomic) PKRefreshControlState pkState;

- (void)pullAnimationWithPercentage:(CGFloat)percentage;
- (void)startRefreshingAnimation;
- (void)endRefreshingAnimation;
@end

@implementation PKRefreshControl

- (id)initInScrollView:(UIScrollView *)scrollView threshold:(CGFloat)threshold {
    self = [super initWithFrame:CGRectMake(0, scrollView.contentInset.top, CGRectGetWidth(scrollView.bounds), threshold)];
    if (self) {
        self.scrollView = scrollView;
        
        [scrollView addObserver:self forKeyPath:@"contentInset" options:NSKeyValueObservingOptionNew context:nil];
        [scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
        [scrollView addObserver:self forKeyPath:@"pan.state" options:NSKeyValueObservingOptionNew context:nil];
        [scrollView addSubview:self];
        
        self.pkState = PKRefreshControlStateNone;
        self.threshold = threshold;
        self.userInteractionEnabled = NO;
        self.originalContentInset = scrollView.contentInset;
        
        [self initialize];
    }
    return self;
}

- (id)initInScrollView:(UIScrollView *)scrollView {
    return [self initInScrollView:scrollView threshold:64];
}

- (void)dealloc {
    [self.scrollView removeObserver:self forKeyPath:@"contentInset"];
    [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
    [self.scrollView removeObserver:self forKeyPath:@"pan.state"];
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    if (!newSuperview) {
        [self.scrollView removeObserver:self forKeyPath:@"contentInset"];
        [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
        [self.scrollView removeObserver:self forKeyPath:@"pan.state"];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentInset"]) {
        [self observeValueForContentInset:[[change objectForKey:@"new"] UIEdgeInsetsValue]];
    }
    else if ([keyPath isEqualToString:@"contentOffset"]) {
        [self observeValueForContentOffset:[[change objectForKey:@"new"] CGPointValue]];
    }
    else if ([keyPath isEqualToString:@"pan.state"]) {
        switch (self.pkState) {
            case PKRefreshControlStateReadyToEnd: {
                UIGestureRecognizerState state = [[change objectForKey:@"new"] integerValue];
                if (state == UIGestureRecognizerStateEnded)
                    [self endBehavior];
                break;
            }
            case PKRefreshControlStateEnd: {
                self.pkState = PKRefreshControlStateNone;
                break;
            }
            default:
                break;
        }
    }
    
    [self.scrollView insertSubview:self atIndex:0];
}

- (void)observeValueForContentInset:(UIEdgeInsets)insets {
    if (self.pkState == PKRefreshControlStateNone) {
        self.originalContentInset = insets;
        CGRect frame = self.frame;
        frame.origin.y = insets.top;
        self.frame = frame;
    }
}

- (void)observeValueForContentOffset:(CGPoint)point {
    CGRect frame = self.frame;
    frame.origin.y = point.y + self.originalContentInset.top;
    self.frame = frame;
    
    CGFloat offset = point.y + self.scrollView.contentInset.top;
    
    switch (self.pkState) {
        case PKRefreshControlStateNone: {
            if (!self.scrollView.isDragging) break;
            if (offset > 0) offset = 0;
            CGFloat distance = MIN(self.threshold, fabs(offset));
            CGFloat percentage = (distance / self.threshold);
            if (percentage >= 1) {
                [self beginRefreshing];
            }
            else {
                [self pullAnimationWithPercentage:percentage];
            }
            break;
        }
        case PKRefreshControlStateLoading:
            if (!self.scrollView.isDragging && self.scrollView.contentInset.top == self.originalContentInset.top) {
                [UIView animateWithDuration:.5 delay:0 usingSpringWithDamping:1.0 initialSpringVelocity:.6 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    CGPoint offset = self.scrollView.contentOffset;
                    CGFloat threshold = self.threshold + self.originalContentInset.top;
                    self.scrollView.contentInset = UIEdgeInsetsMake(threshold, 0, 0, 0);
                    self.scrollView.contentOffset = CGPointMake(offset.x, -threshold);
                } completion:nil];
            }
            break;
        case PKRefreshControlStateReadyToEnd:
            break;
        case PKRefreshControlStateEnd:
            break;
        default:
            break;
    }
}

- (void)beginRefreshing {
    if (self.pkState == PKRefreshControlStateNone) {
        [self startRefreshingAnimation];
        self.pkState = PKRefreshControlStateLoading;
        self.originalContentInset = self.scrollView.contentInset;
        
        if (!self.scrollView.isDragging) {
            [UIView animateWithDuration:.5 delay:0 usingSpringWithDamping:1.0 initialSpringVelocity:.6 options:UIViewAnimationOptionCurveEaseOut animations:^{
                CGPoint offset = self.scrollView.contentOffset;
                CGFloat threshold = self.threshold + self.originalContentInset.top;
                self.scrollView.contentInset = UIEdgeInsetsMake(threshold, 0, 0, 0);
                self.scrollView.contentOffset = CGPointMake(offset.x, -threshold);
            } completion:nil];
        }
        
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

- (void)endRefreshing {
    if (self.pkState == PKRefreshControlStateLoading) {
        if (self.scrollView.isDragging) {
            self.pkState = PKRefreshControlStateReadyToEnd;
        }
        else {
            [self endBehavior];
        }
    }
}

- (void)endBehavior {
    self.pkState = PKRefreshControlStateEnd;
    
    [UIView animateWithDuration:.5 delay:0 usingSpringWithDamping:1.0 initialSpringVelocity:.6 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.scrollView.contentInset = self.originalContentInset;
    } completion:nil];
    
    [self endRefreshingAnimation];
}

#pragma mark - override

- (void)initialize {
}

- (void)pullAnimationWithPercentage:(CGFloat)percentage {
}

- (void)startRefreshingAnimation {
}

- (void)endRefreshingAnimation {
}

@end
