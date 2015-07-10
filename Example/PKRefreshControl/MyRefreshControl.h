//
//  MyRefreshControl.h
//  PKRefreshControl
//
//  Created by shimokawa on 7/10/15.
//  Copyright (c) 2015 Seiya Shimokawa. All rights reserved.
//

#import <PKRefreshControl/PKRefreshControl.h>
#import "PKActivityIndicator.h"

@interface MyRefreshControl : PKRefreshControl
@property (nonatomic) PKActivityIndicator *indicator;
@end
