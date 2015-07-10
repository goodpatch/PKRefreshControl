//
//  PKCollectionViewController.m
//  PKRefreshControl
//
//  Created by shimokawa on 7/10/15.
//  Copyright (c) 2015 Seiya Shimokawa. All rights reserved.
//

#import "PKCollectionViewController.h"
#import "MyRefreshControl.h"

@interface PKCollectionViewController ()
@property (nonatomic) MyRefreshControl *myRefreshControl;
@end

@implementation PKCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.myRefreshControl = [[MyRefreshControl alloc] initInScrollView:self.collectionView threshold:64];
    [self.myRefreshControl addTarget:self action:@selector(onRefresh:) forControlEvents:UIControlEventValueChanged];
    self.myRefreshControl.indicator.barColor = [UIColor whiteColor];
    self.myRefreshControl.indicator.numberOfBars = 5;
    self.myRefreshControl.indicator.barWidth = 10;
    self.myRefreshControl.indicator.barHeight = 10;
    self.myRefreshControl.indicator.aperture = 10;
    self.myRefreshControl.indicator.anmDuration = 0.5;
    
    self.collectionView.contentInset = UIEdgeInsetsMake(128, 0, 0, 0);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.myRefreshControl beginRefreshing];
}

- (void)onRefresh:(id)refreshControl {
    double delayInSeconds = 3.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [refreshControl endRefreshing];
    });
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 100;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class]) forIndexPath:indexPath];
    
    // Configure the cell
    return cell;
}


@end
