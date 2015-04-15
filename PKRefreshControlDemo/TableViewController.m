//
//  TableViewController.m
//  PKRefreshControlDemo
//
//  Created by shimokawa on 12/24/14.
//  Copyright (c) 2014 Goodpatch. All rights reserved.
//

#import "TableViewController.h"
#import "PKRefreshControl.h"
#import "MyRefreshControl.h"

@interface TableViewController ()
@property (nonatomic) MyRefreshControl *pkRefreshControl;
@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pkRefreshControl = [[MyRefreshControl alloc] initInScrollView:self.tableView];
    [self.pkRefreshControl addTarget:self action:@selector(onRefresh:) forControlEvents:UIControlEventValueChanged];
    
    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);

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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCellReuseIdentifier" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = [NSString stringWithFormat:@"%@",@(arc4random())];
    
    return cell;
}

@end
