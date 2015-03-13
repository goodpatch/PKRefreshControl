//
//  PKRefreshControl.m
//  PKRefreshControlDemo
//
//  Created by shimokawa on 12/24/14.
//  Copyright (c) 2014 Goodpatch. All rights reserved.
//

#import "PKRefreshControl.h"
#import "PKActivityIndicator.h"

typedef NS_ENUM(NSUInteger, PKRefreshControlState) {
    PKRefreshControlStateNone,
    PKRefreshControlStateLoading,
    PKRefreshControlStateEnd,
};

@interface PKRefreshControl ()
@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic) UIEdgeInsets originalContentInset;
@property (nonatomic) BOOL ignoreInset;
@property (nonatomic) BOOL ignoreOffset;
@property (nonatomic) PKActivityIndicator *indicator;
@property (nonatomic) PKRefreshControlState pkState;
@property (nonatomic) CGFloat openedHeight;
@property (nonatomic) CGFloat viewHeight;

- (void)pullAnimationWithPercentage:(CGFloat)percentage;
- (void)startRefreshingAnimation;
- (void)endRefreshingAnimation;
@end

@implementation PKRefreshControl

- (id)initInScrollView:(UIScrollView *)scrollView openedHeight:(CGFloat)openedHeight {
    self = [super init];
    if (self) {
        self.scrollView = scrollView;
        self.originalContentInset = self.scrollView.contentInset;
        
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
        [scrollView addObserver:self forKeyPath:@"contentInset" options:NSKeyValueObservingOptionNew context:nil];
        
        if ([scrollView isKindOfClass:[UICollectionView class]]) {
            UICollectionView *collectionView = (UICollectionView *)scrollView;
            collectionView.backgroundView = self;
        }
        else {
            [scrollView insertSubview:self atIndex:0];
        }
        
        self.ignoreInset = NO;
        self.ignoreOffset = NO;
        self.pkState = PKRefreshControlStateNone;
        
        self.openedHeight = openedHeight;
        self.viewHeight = (self.openedHeight/2)*3;
    }
    return self;
}

- (id)initInScrollView:(UIScrollView *)scrollView {
    return [self initInScrollView:scrollView openedHeight:60];
}

- (void)dealloc
{
    [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
    [self.scrollView removeObserver:self forKeyPath:@"contentInset"];
    self.scrollView = nil;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    if (!newSuperview) {
        [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
        [self.scrollView removeObserver:self forKeyPath:@"contentInset"];
        self.scrollView = nil;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentInset"]) {
        if (!self.ignoreInset) {
            self.originalContentInset = [[change objectForKey:@"new"] UIEdgeInsetsValue];
            self.frame = CGRectMake(0, -(self.scrollView.contentInset.top), self.scrollView.frame.size.width, self.viewHeight);
        }
        if (self.pkState == PKRefreshControlStateEnd && CGRectGetMinY(self.frame) > -1) {
            self.pkState = PKRefreshControlStateNone;
        }
        return;
    }

    if (!self.enabled || self.ignoreOffset) {
        return;
    }
    
    CGFloat offset = [[change objectForKey:@"new"] CGPointValue].y + self.originalContentInset.top;
    self.frame = CGRectMake(0, self.scrollView.contentOffset.y, self.scrollView.frame.size.width, self.viewHeight);

    if (self.pkState == PKRefreshControlStateLoading) {
        if (offset != 0) {
            // Keep thing pinned at the top
            self.ignoreInset = YES;
            self.ignoreOffset = YES;
            
            if (offset < 0) {
                // Set the inset depending on the situation
                if (offset >= -self.openedHeight) {
                    if (!self.scrollView.dragging) {
                        [self.scrollView setContentInset:UIEdgeInsetsMake(self.openedHeight + self.originalContentInset.top, self.originalContentInset.left, self.originalContentInset.bottom, self.originalContentInset.right)];
                    } else {
                        [self.scrollView setContentInset:UIEdgeInsetsMake(-offset + self.originalContentInset.top, self.originalContentInset.left, self.originalContentInset.bottom, self.originalContentInset.right)];
                    }
                }
            }
            else {
                [self.scrollView setContentInset:self.originalContentInset];
            }
            
            self.ignoreInset = NO;
            self.ignoreOffset = NO;
        }
        return;
    }

    if (self.pkState == PKRefreshControlStateNone) {
        CGFloat verticalShift = MAX(0, -offset);
        CGFloat distance = MIN(self.viewHeight, fabs(verticalShift));
        CGFloat percentage = (distance / self.viewHeight);
        if (distance != 0 && percentage == 1) {
            [self sendActionsForControlEvents:UIControlEventValueChanged];
            [self startRefreshingAnimation];
            self.pkState = PKRefreshControlStateLoading;
        }
        else {
            [self pullAnimationWithPercentage:percentage];
        }
    }
    else if (self.pkState == PKRefreshControlStateEnd && offset > -1) {
        self.pkState = PKRefreshControlStateNone;
    }
}

- (void)beginRefreshing
{
    if (self.pkState == PKRefreshControlStateNone) {
        CGPoint offset = self.scrollView.contentOffset;
        self.ignoreInset = YES;
        [self.scrollView setContentInset:UIEdgeInsetsMake(self.openedHeight + self.originalContentInset.top, self.originalContentInset.left, self.originalContentInset.bottom, self.originalContentInset.right)];
        self.ignoreInset = NO;
        [self.scrollView setContentOffset:CGPointMake(offset.x, offset.y-self.openedHeight) animated:YES];
        
        [self sendActionsForControlEvents:UIControlEventValueChanged];
        [self startRefreshingAnimation];
        self.pkState = PKRefreshControlStateLoading;
    }
}

- (void)endRefreshing
{
    if (self.pkState == PKRefreshControlStateLoading) {
        [self endRefreshingAnimation];
        __block UIScrollView *blockScrollView = self.scrollView;
        [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.ignoreInset = YES;
            [blockScrollView setContentInset:self.originalContentInset];
            self.ignoreInset = NO;
        } completion:^(BOOL finished) {
            self.pkState = PKRefreshControlStateEnd;
            self.ignoreInset = YES;
            [blockScrollView setContentInset:self.originalContentInset];
            self.ignoreInset = NO;
        }];
    }
}

#pragma mark -

- (void)pullAnimationWithPercentage:(CGFloat)percentage
{
    if (!self.indicator) {
        self.indicator = [[PKActivityIndicator alloc] initWithFrame:CGRectMake(0, 0, self.openedHeight, self.openedHeight)];
        self.indicator.center = CGPointMake(self.center.x, self.openedHeight/2);
        [self addSubview:self.indicator];
    }
    
    self.indicator.alpha = 1;
    [self.indicator setSpinnerReplicatorInstanceCountWithPercentage:percentage];
}

- (void)startRefreshingAnimation
{
    [self.indicator startAnimating];
    
    [UIView animateWithDuration:2.0 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.indicator.transform = CGAffineTransformRotate(self.indicator.transform, M_PI);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)endRefreshingAnimation
{
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
