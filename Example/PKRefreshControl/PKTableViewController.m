//
//  PKTableViewController.m
//  PKRefreshControl
//
//  Created by shimokawa on 7/10/15.
//  Copyright (c) 2015 Seiya Shimokawa. All rights reserved.
//

#import "PKTableViewController.h"
#import "MyRefreshControl.h"

@interface PKTableViewController ()
@property (nonatomic) MyRefreshControl *myRefreshControl;
@end

@implementation PKTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.myRefreshControl = [[MyRefreshControl alloc] initInScrollView:self.tableView];
    [self.myRefreshControl addTarget:self action:@selector(onRefresh:) forControlEvents:UIControlEventValueChanged];
    
    if (self.navigationController.tabBarItem.tag == 1) {
        PKActivityIndicator *indicator = self.myRefreshControl.indicator;
        indicator.aperture = 10;
        indicator.barWidth = 2;
        indicator.barHeight = 7;
        indicator.numberOfBars = 12;
        indicator.anmDuration = 1;
    }
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = [NSString stringWithFormat:@"%@",@(arc4random())];
    
    return cell;
}

@end
