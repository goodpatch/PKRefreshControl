PKRefreshContol is a custmizable refresh control.

## Installation
```ruby
pod 'PKRefreshControl', :podspec => 'https://raw.githubusercontent.com/goodpatch/PKRefreshControl/master/PKRefreshControl.podspec'
```

## Usage
see demo  
### import

```objective-c
#import "PKRefreshControl.h"
```
### create

```objective-c
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    PKRefreshControl *refreshControl = [[PKRefreshControl alloc] initInScrollView:self.tableView];
    // if you wanna change opened height
    // PKRefreshControl refreshControl = [[PKRefreshControl alloc] initInScrollView:self.collectionView openedHeight:100];

    [refreshControl addTarget:self action:@selector(onRefresh:) forControlEvents:UIControlEventValueChanged];
}

- (void)onRefresh:(id)refreshControl {
	~~~~~
	[refreshControl endRefreshing];
}
```

### 