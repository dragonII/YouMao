//
//  AddrListViewController.m
//  BinFenV10
//
//  Created by Wang Long on 2/11/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import "AddrListViewController.h"
#import "AddrsTableViewCell.h"
#import "AddNewAddrCell.h"
#import "AppData.h"
#import "ComposeAddrViewController.h"

static NSString *AddrCellIdentifier = @"AddrTableCell";
static NSString *AddNewAddrCellIdentifier = @"AddNewAddrCell";

static NSString *PhoneKey = @"Phone";
static NSString *AddrKey = @"Addr";

typedef enum
{
    SectionIndexListAddr = 0,
    SectionIndexAddAddr
} SectionIndexType;

@interface AddrListViewController () <UITableViewDataSource, UITableViewDelegate, EditDeleteDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *addrArray;
@property NSInteger selectedAddrIndex;

@end

@implementation AddrListViewController

- (void)initNavigationItem
{
    UIColor *backgroundColor = [UIColor colorWithRed:253/255.0f
                                               green:150/255.0f
                                                blue:93/255.0f
                                               alpha:1.0f];
    self.navigationItem.title = @"地址列表";
    [self.navigationController.navigationBar setBarTintColor:backgroundColor];
    [self.navigationController.navigationBar setTranslucent:NO];
}

- (void)initTableView
{
    CGFloat navigationBarHeight = self.navigationController.navigationBar.frame.size.height;
    //CGFloat tabBarHeight = self.tabBarController.tabBar.frame.size.height;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,
                                                                   self.view.bounds.size.width,
                                                                   self.view.bounds.size.height - navigationBarHeight)];
    
    self.tableView.backgroundColor = [UIColor colorWithRed:225/255.0f
                                                     green:225/255.0f
                                                      blue:225/255.0f
                                                     alpha:1.0f];

    
    // Remove the separator lines for emtpy cells
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.tableFooterView = footerView;
    
    
    UINib *nib = [UINib nibWithNibName:@"AddrsTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:AddrCellIdentifier];
    
    nib = [UINib nibWithNibName:@"AddNewAddrCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:AddNewAddrCellIdentifier];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
}

- (void)initAddrData
{
    self.addrArray = [NSMutableArray arrayWithArray:[AppData loadAddrDataArray]];
    //NSLog(@"initarray: %@", self.addrArray);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initAddrData];
    
    [self initNavigationItem];
    
    [self initTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self initAddrData];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma UITableView DataSource, Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case SectionIndexListAddr:
            return [self.addrArray count];
            
        case SectionIndexAddAddr:
            return 1;
            
        default:
            return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 12)];
    view.backgroundColor = [UIColor colorWithRed:225/255.0f green:225/255.0f blue:225/255.0f alpha:1.0f];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 12.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case SectionIndexListAddr:
        {
            AddrsTableViewCell *cell = (AddrsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:AddrCellIdentifier];
            if(cell == nil)
            {
                cell = [[AddrsTableViewCell alloc] init];
            }
            cell.phoneLabel.text = [[self.addrArray objectAtIndex:indexPath.row] objectForKey:DictPhoneInAddrKey];
            cell.addrLabel.text = [[self.addrArray objectAtIndex:indexPath.row] objectForKey:DictAddrInAddrKey];
            cell.editDeleteDelegate = self;
            
            return cell;
        }
        case SectionIndexAddAddr:
        {
            AddNewAddrCell *cell = (AddNewAddrCell *)[tableView dequeueReusableCellWithIdentifier:AddNewAddrCellIdentifier];
            if(cell == nil)
            {
                cell = [[AddNewAddrCell alloc] init];
            }
            return cell;
        }
            
        default:
            return [[UITableViewCell alloc] init];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.section == SectionIndexAddAddr && indexPath.row == 0)
    {
        //NSLog(@"set selectedAddrIndex: -1");
        self.selectedAddrIndex = -1;
        [self performSegueWithIdentifier:@"ComposeAddrSegue" sender:self];
    }
}

#pragma Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"ComposeAddrSegue"])
    {
        ComposeAddrViewController *composeVC = (ComposeAddrViewController *)segue.destinationViewController;
        //NSLog(@"set selectedAddrIndex: %d", self.selectedAddrIndex);
        composeVC.selectedIndexForEdit = self.selectedAddrIndex;
    }
}

#pragma EditDeleteDelegate

- (void)editClicked:(AddrsTableViewCell *)cell
{
    //NSLog(@"edit cell row: %d", [self.tableView indexPathForCell:cell].row);
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    self.selectedAddrIndex = indexPath.row;
    
    [self performSegueWithIdentifier:@"ComposeAddrSegue" sender:self];
}

- (void)deleteClicked:(AddrsTableViewCell *)cell
{
    //NSLog(@"delete cell row: %d", [self.tableView indexPathForCell:cell].row);
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];

    [self.addrArray removeObjectAtIndex:indexPath.row];
    [AppData saveAddrDataArray:self.addrArray];
    
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

@end
