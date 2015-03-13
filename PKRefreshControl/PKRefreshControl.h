//
//  PKRefreshControl.h
//  PKRefreshControlDemo
//
//  Created by shimokawa on 12/24/14.
//  Copyright (c) 2014 Goodpatch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PKRefreshControl : UIControl
- (id)initInScrollView:(UIScrollView *)scrollView openedHeight:(CGFloat)openedHeight;
- (id)initInScrollView:(UIScrollView *)scrollView;
- (void)beginRefreshing;
- (void)endRefreshing;
@end
