//
//  CommunitySelectionViewController.m
//  BinFenV10
//
//  Created by Wang Long on 2/9/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import "CommunitySelectionViewController.h"
#import "CommunityForSelectionCell.h"

static const NSInteger SectionCurrentIndex = 0;
static const NSInteger SectionHistoryIndex = 1;

@interface CommunitySelectionViewController () <UITableViewDataSource, UITableViewDelegate, DeleteHistoryCommunityDelegate>

@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *communityHistoryList;
@property (copy, nonatomic) NSString *currentCommunity;

@end

@implementation CommunitySelectionViewController

- (void)loadCommunityByCurrentLocation
{
    self.currentCommunity = [@"加拿大" copy];
}

- (void)loadCommunityByHistory
{
    self.communityHistoryList = [[NSMutableArray alloc] init];
    [self.communityHistoryList addObject:@"荷兰"];
    [self.communityHistoryList addObject:@"滑雪"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadCommunityByCurrentLocation];
    [self loadCommunityByHistory];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20 + 44, self.view.bounds.size.width, self.view.bounds.size.height - 20 - 44)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    // Remove the separator lines for emtpy cells
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.tableFooterView = footerView;
    
    self.tableView.separatorColor = [UIColor colorWithWhite:0.0f alpha:0.2f];
    self.tableView.rowHeight = 80.0f;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    
    UINib *nib = [UINib nibWithNibName:@"CommunityForSelectionCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"CommunityCell"];
    
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma TableViewDataSource and Delegate

// 当前定位所在社区以及历史浏览社区
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case SectionCurrentIndex:
            return 1;
        
        case SectionHistoryIndex:
            return [self.communityHistoryList count];
            
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommunityForSelectionCell *cell = (CommunityForSelectionCell *)[tableView dequeueReusableCellWithIdentifier:@"CommunityCell"];
    if(cell == nil)
    {
        cell = [[CommunityForSelectionCell alloc] init];
    }
    
    switch (indexPath.section)
    {
        case SectionCurrentIndex:
            // 设置cell右侧小图片为定位图标或者删除图标
            //cell.operationImage = ...设置定位标识
            // 设置此cell的类型
            cell.nameLabel.text = self.currentCommunity;
            cell.cellType = CommunityCellTypeCurrent;
            break;
            
        case SectionHistoryIndex:
            //cell.operationImage = ...
            cell.nameLabel.text = [self.communityHistoryList objectAtIndex:indexPath.row];
            cell.cellType = CommunityCellTypeHistory;
            break;
            
        default:
            break;
    }
    cell.deleteHistoryDelegate = self;
    return cell;
}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 28)];
    bgView.backgroundColor = [UIColor lightGrayColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, self.view.bounds.size.width - 16, 28)];
    label.textColor = [UIColor whiteColor];
    label.text = @"历史浏览";
    [bgView addSubview:label];
    
    return bgView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section)
    {
        case SectionHistoryIndex:
            return 28.0f;
            
        default:
            return 0.0f;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.searchBar resignFirstResponder];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma DeleteHistoryCommunityDelegate

- (void)deleteClickedInCell:(CommunityForSelectionCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    //NSLog(@"section: %d, row: %d", indexPath.section, indexPath.row);
    [self.communityHistoryList removeObjectAtIndex:indexPath.row];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

@end
