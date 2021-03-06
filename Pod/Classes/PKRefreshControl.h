//
//  PKRefreshControl.h
//  PKRefreshControlDemo
//
//  Created by shimokawa on 12/24/14.
//  Copyright (c) 2014 Goodpatch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PKRefreshControl : UIControl
@property (nonatomic,readonly) CGFloat threshold;
- (id)initInScrollView:(UIScrollView *)scrollView threshold:(CGFloat)threshold;
- (id)initInScrollView:(UIScrollView *)scrollView;
- (void)beginRefreshing;
- (void)endRefreshing;
@end
