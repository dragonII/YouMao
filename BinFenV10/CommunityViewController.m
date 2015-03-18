//
//  CommunityViewController.m
//  BinFenV10
//
//  Created by Wang Long on 2/5/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import "CommunityViewController.h"
#import "CategoryTableViewCell.h"
#import "ShopsCell.h"
#import "BFPreferenceData.h"
#import "MLKMenuPopover.h"
#import "ShopViewController.h"
#import "defs.h"
#import "DataModel.h"

#import "DeviceHardware.h"

NSString *CategoryCellIdentifier = @"CategoryCellIdentifier";
NSString *ShopsCellIdentifier = @"ShopsCellIdentifier";

static const int SectionCategory = 0;
static const int SectionShops = 1;
static const int SectionLoadMore = 2;

@interface CommunityViewController () <UITableViewDataSource, UITableViewDelegate, MLKMenuPopoverDelegate, ShopsCellSegueDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) MLKMenuPopover *categoryPopover;

@property (assign, nonatomic) NSInteger categoryButtonIndex;

@property (strong, nonatomic) DataModel *dataModel;

@property (strong, nonatomic) NSMutableArray *shops;

@end

@implementation CommunityViewController

- (void)initTableView
{    
    CGRect tableViewFrame;
    
    DeviceHardwareGeneralPlatform generalPlatform = [DeviceHardware generalPlatform];
    
    switch (generalPlatform)
    {
        case DeviceHardwareGeneralPlatform_iPhone_4:
        case DeviceHardwareGeneralPlatform_iPhone_4S:
        {
            CGFloat navigationBarHeight = self.navigationController.navigationBar.frame.size.height;
            CGFloat statusBarHeight = 20;
            tableViewFrame = CGRectMake(0, navigationBarHeight + statusBarHeight,
                                        //self.view.bounds.size.width,
                                        [UIScreen mainScreen].bounds.size.width,
                                        self.view.bounds.size.height - navigationBarHeight - statusBarHeight);
            break;
        }
        case DeviceHardwareGeneralPlatform_iPhone_5:
        case DeviceHardwareGeneralPlatform_iPhone_5C:
        case DeviceHardwareGeneralPlatform_iPhone_5S:
        case DeviceHardwareGeneralPlatform_iPhone_6:
        case DeviceHardwareGeneralPlatform_iPhone_6_Plus:
        {
            tableViewFrame = CGRectMake(0, 0,
                                        //self.view.bounds.size.width,
                                        [UIScreen mainScreen].bounds.size.width,
                                        self.view.bounds.size.height);
            break;
        }
            
        default:
            // For iphone 6 simulator
            tableViewFrame = CGRectMake(0, 0,
                                        //self.view.bounds.size.width,
                                        [UIScreen mainScreen].bounds.size.width,
                                        self.view.bounds.size.height);
            break;
    }
     

    self.tableView = [[UITableView alloc] initWithFrame:tableViewFrame];
    
    [self.tableView registerClass:[CategoryTableViewCell class] forCellReuseIdentifier:CategoryCellIdentifier];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
}

- (CGFloat)getHeightOfItemRow
{
    DeviceHardwareGeneralPlatform generalPlatform = [DeviceHardware generalPlatform];
    
    switch (generalPlatform)
    {
        case DeviceHardwareGeneralPlatform_iPhone_4:
        case DeviceHardwareGeneralPlatform_iPhone_4S:
        {
            return 208 + 10;
            break;
        }
        case DeviceHardwareGeneralPlatform_iPhone_5:
        case DeviceHardwareGeneralPlatform_iPhone_5C:
        case DeviceHardwareGeneralPlatform_iPhone_5S:
        case DeviceHardwareGeneralPlatform_iPhone_6:
        {
            return 246 + 10;
            break;
        }
        case DeviceHardwareGeneralPlatform_iPhone_6_Plus:
        default:
            // For iphone 6 simulator
            return 274 + 10;
            break;
    }
    
}

- (void)loadShopsOfThisCommunity
{
    self.shops = [[NSMutableArray alloc] init];
    
    
    NSString *communityID = [[self.dataModel.communities objectAtIndex:self.communityIndex] objectForKey:@"ID"];
    self.shops = [[NSMutableArray alloc] init];
    
    for(int i = 0; i < [self.dataModel.shops count]; i++)
    {
        NSString *communityIDInShop = [[self.dataModel.shops objectAtIndex:i] objectForKey:@"community"];
        if([communityIDInShop isEqualToString:communityID])
        {
            [self.shops addObject:[self.dataModel.shops objectAtIndex:i]];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dataModel = [[DataModel alloc] init];
    [self.dataModel loadDataModelLocally];
    
    [self loadShopsOfThisCommunity];
    
    [self initTableView];
    
    self.hidesBottomBarWhenPushed = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSString *communityTitle = [[self.dataModel.communities objectAtIndex:self.communityIndex] objectForKey:@"name"];
    self.navigationItem.title = communityTitle;
    
    NSLog(@"CommunityTableWidth: %f", self.tableView.frame.size.width);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setCategoriesListArray:(NSArray *)categoriesListArray
{
    if(![_categoriesListArray isEqualToArray:categoriesListArray])
    {
        _categoriesListArray = [NSArray arrayWithArray:categoriesListArray];
    }
}

#pragma UITableViewDataSource, UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSInteger sectionNumber = indexPath.section;
    switch (sectionNumber)
    {
        case SectionCategory:
        {
            CategoryTableViewCell *cell = (CategoryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CategoryCellIdentifier];
            if(cell == nil)
            {
                cell = [[CategoryTableViewCell alloc] init];
            }
            
            cell.categoriesListArray = self.categoriesListArray;
            
            return cell;
        }
            
        case SectionShops:
        {
            ShopsCell *cell = (ShopsCell *)[tableView dequeueReusableCellWithIdentifier:ShopsCellIdentifier];
            if(cell == nil)
            {
                cell = [[ShopsCell alloc] init];
            }
            
            [cell initShopItemsByCommunityIndex:self.communityIndex];
            
            cell.segueDelegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
            
        case SectionLoadMore:
        {
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            cell.textLabel.text = @"加载更多";
            return cell;
        }
            
        default:
            return nil;
    }
}

- (void)loadNextBatchShops
{
    //NSArray *array = [BFPreferenceData loadTestDataArray];
    NSInteger batchIndex = [[NSUserDefaults standardUserDefaults] integerForKey:LoadContentBatchIndexKey];
    
    if(batchIndex * TotalItemsPerBatch < [self.shops count])
    {
        batchIndex++;
        [[NSUserDefaults standardUserDefaults] setInteger:batchIndex forKey:LoadContentBatchIndexKey];
        NSLog(@"batchIndex in load...: %ld", (long)batchIndex);
        [self.tableView reloadData];
    } else {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:SectionLoadMore];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        cell.textLabel.text = @"没有更多了";
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.section == SectionLoadMore)
    {
        [self loadNextBatchShops];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger sectionNumber = indexPath.section;
    CGFloat heightOfItemInShopTableCell = [self getHeightOfItemRow];
    switch (sectionNumber)
    {
        case SectionCategory:
            return 214.0f;
            break;
        case SectionShops:
        {
            NSInteger batchIndex = [[NSUserDefaults standardUserDefaults] integerForKey:LoadContentBatchIndexKey];
            if([self.shops count] == 0)
            {
                return 0;
            }

            if([self.shops count] >= batchIndex * TotalItemsPerBatch)
            {
                return batchIndex * TotalRowsPerBatch * heightOfItemInShopTableCell;
            }
            else // 0 < count < batchIndex * TotalItemsPerBatch
            {
                NSInteger totalRows = ([self.shops count] - 1) / 2 + 1;
                return totalRows * heightOfItemInShopTableCell;
            }
        }
        case SectionLoadMore:
            return 60.0f;
        default:
            return 60.0f;
    }
}

- (void)menuPopover:(MLKMenuPopover *)menuPopover didSelectMenuItemAtIndex:(NSInteger)selectedIndex
{
    [self.categoryPopover dismissMenuPopover];
    NSLog(@"Category selected");
}


- (void)scrollToTopOfShopsSection
{
    // 检测ShopsSection的Header是否已经被置顶
    if(self.tableView.contentOffset.y < 150)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:SectionShops];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

- (void)showCategoryPopover:(id)sender
{
    CGFloat buttonHeight = 36.0f;
    CGFloat topImageViewHeight = 64.0f;
    CGFloat buttonWidth = 106.0f;
    
    CGRect popoverFrame = CGRectMake(5 + (buttonWidth * self.categoryButtonIndex),
                                     topImageViewHeight + buttonHeight,
                                     self.view.bounds.size.width - 10,
                                     44 * 7);// Only display 7 lines most
    
    // Hide already showing popover
    if(self.categoryPopover)
    {
        [self.categoryPopover dismissMenuPopover];
    }
    
    self.categoryPopover = [[MLKMenuPopover alloc] initWithFrame:popoverFrame menuItems:self.categoriesListArray];
    self.categoryPopover.menuPopoverDelegate = self;
    [self.categoryPopover showInView:self.view];
}


- (void)categoryButtonClicked:(UIButton *)sender
{
    self.categoryButtonIndex = sender.tag - 201;
    [self scrollToTopOfShopsSection];
    
    [NSTimer scheduledTimerWithTimeInterval:0.2f target:self selector:@selector(showCategoryPopover:) userInfo:nil repeats:NO];
}

- (CGFloat)getItemWidthByDevice
{
    DeviceHardwareGeneralPlatform generalPlatform = [DeviceHardware generalPlatform];
    
    switch (generalPlatform)
    {
        case DeviceHardwareGeneralPlatform_iPhone_4:
        case DeviceHardwareGeneralPlatform_iPhone_4S:
        case DeviceHardwareGeneralPlatform_iPhone_5:
        case DeviceHardwareGeneralPlatform_iPhone_5C:
        case DeviceHardwareGeneralPlatform_iPhone_5S:
        {
            return 106.0f;
            
            break;
        }
            
        case DeviceHardwareGeneralPlatform_iPhone_6:
        {
            return 124.0f;
            break;
        }
        case DeviceHardwareGeneralPlatform_iPhone_6_Plus:
        default:
            return 138.0f;
            break;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section == SectionShops)
    {
        CGFloat buttonWidth = [self getItemWidthByDevice];
    
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 36)];
    
        UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(view.frame.origin.x,
                                                                   view.frame.origin.y,
                                                                   buttonWidth, 36)];
        button1.tag = 201;
        button1.backgroundColor = [UIColor redColor];
        [button1 addTarget:self action:@selector(categoryButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
        UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(view.frame.origin.x + buttonWidth + 1,
                                                                   view.frame.origin.y,
                                                                   buttonWidth, 36)];
        button2.tag = 202;
        button2.backgroundColor = [UIColor yellowColor];
        [button2 addTarget:self action:@selector(categoryButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
        UIButton *button3 = [[UIButton alloc] initWithFrame:CGRectMake(view.frame.origin.x + (buttonWidth + 1) * 2,
                                                                   view.frame.origin.y,
                                                                   buttonWidth + 1, 36)];
        button3.tag = 203;
        button3.backgroundColor = [UIColor blackColor];
        [button3 addTarget:self action:@selector(categoryButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
        [view addSubview:button1];
        [view addSubview:button2];
        [view addSubview:button3];
    
        return view;
    } else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == SectionShops)
        return 36.0f;
    else
        return 0;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"ShowShopsSegueFromCommunity"])
    {
        // showShopViewFrom默认值为0，这里可以省略
        //ShopViewController *shopVC = (ShopViewController *)segue.destinationViewController;
        //shopVC.showShopViewFrom = ShowViewFromHome;
    }
}

- (void)shopItemClickedInCell:(ShopsCell *)cell
{
    [self performSegueWithIdentifier:@"ShowShopsSegueFromCommunity" sender:self];
}


@end
