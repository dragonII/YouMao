//
//  NearbyViewController.m
//  BinFenV10
//
//  Created by Wang Long on 2/10/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import "NearbyViewController.h"
#import "NearbyTableViewCell.h"

static NSString *NearbyCellIdentifier = @"NearbyCellIdentifier";

@interface NearbyViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSArray *dataArray;

@end

@implementation NearbyViewController

- (void)initNavigationItem
{
    UIColor *backgroundColor = [UIColor colorWithRed:70/255.0f green:159/255.0f blue:183/255.0f alpha:1.0f];
    self.navigationItem.title = @"周边";
    //self.navigationController.navigationBar.backgroundColor = backgroundColor;
    [self.navigationController.navigationBar setBarTintColor:backgroundColor];
    [self.navigationController.navigationBar setTranslucent:NO];
}

- (void)initTableView
{
    CGFloat navigationBarHeight = self.navigationController.navigationBar.frame.size.height;
    CGFloat tabBarHeight = self.tabBarController.tabBar.frame.size.height;
    //NSLog(@"tabBarHeight: %f", tabBarHeight);
    //NSLog(@"naviBarHeight: %f", navigationBarHeight);
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,
                                                                  self.view.bounds.size.width,
                                                                   self.view.bounds.size.height - navigationBarHeight - tabBarHeight)];
    //NSLog(@"view: %f, %f, %f", self.view.frame.origin.x, self.view.frame.origin.y, self.view.bounds.size.height);
    //NSLog(@"table: %f, %f, %f", self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.height);
    self.tableView.backgroundColor = [UIColor colorWithRed:225/255.0f
                                                     green:225/255.0f
                                                      blue:225/255.0f
                                                     alpha:1.0f];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UINib *nib = [UINib nibWithNibName:@"NearbyTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:NearbyCellIdentifier];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dataArray = @[@"1", @"2", @"3"];
    
    [self initNavigationItem];
    [self initTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma UITableView Delegate and DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NearbyTableViewCell *cell = (NearbyTableViewCell *)[tableView dequeueReusableCellWithIdentifier:NearbyCellIdentifier];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 112.0f;
}

@end
