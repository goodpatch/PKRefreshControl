//
//  CollectionCollectionViewController.m
//  PKRefreshControlDemo
//
//  Created by shimokawa on 1/30/15.
//  Copyright (c) 2015 Goodpatch. All rights reserved.
//

#import "CollectionCollectionViewController.h"
#import "PKRefreshControl.h"
#import "MyRefreshControl.h"

@interface CollectionCollectionViewController ()
@property (nonatomic) MyRefreshControl *pkRefreshControl;
@end

@implementation CollectionCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.pkRefreshControl = [[MyRefreshControl alloc] initInScrollView:self.collectionView threshold:64];
    [self.pkRefreshControl addTarget:self action:@selector(onRefresh:) forControlEvents:UIControlEventValueChanged];
    
    self.collectionView.contentInset = UIEdgeInsetsMake(128, 0, 0, 0);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.pkRefreshControl beginRefreshing];
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
