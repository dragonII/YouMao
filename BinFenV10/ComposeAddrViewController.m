//
//  ComposeAddrViewController.m
//  BinFenV10
//
//  Created by Wang Long on 2/11/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import "ComposeAddrViewController.h"
#import "EditInforCell.h"
#import "AppData.h"

static NSString *EditInfoCellIdentifier = @"EditInfoCell";

@interface ComposeAddrViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *addrArray;

@end

@implementation ComposeAddrViewController

- (void)initNavigationItem
{
    UIColor *backgroundColor = [UIColor colorWithRed:253/255.0f
                                               green:150/255.0f
                                                blue:93/255.0f
                                               alpha:1.0f];
    self.navigationItem.title = @"添加收货人信息";
    [self.navigationController.navigationBar setBarTintColor:backgroundColor];
    [self.navigationController.navigationBar setTranslucent:NO];
}

- (void)initTableView
{
    //CGFloat navigationBarHeight = self.navigationController.navigationBar.frame.size.height;
    //CGFloat tabBarHeight = self.tabBarController.tabBar.frame.size.height;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,
                                                                   self.view.bounds.size.width,
                                                                   44.0f * 2 + 12 - 1) //隐藏最后一行Cell的Seperator
                      ];
    self.tableView.scrollEnabled = NO;
    
    
    UINib *nib = [UINib nibWithNibName:@"EditInforCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:EditInfoCellIdentifier];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
}

- (void)initAddrArray
{
    self.addrArray = [NSMutableArray arrayWithArray:[AppData loadAddrDataArray]];
    if(self.addrArray == nil)
        self.addrArray = [[NSMutableArray alloc] init];
    
    //self.selectedIndexForEdit = -1;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initNavigationItem];
    
    [self initAddrArray];
    
    [self initTableView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma UITableView DataSource, Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EditInforCell *cell = (EditInforCell *)[tableView dequeueReusableCellWithIdentifier:EditInfoCellIdentifier];
    if(cell == nil)
    {
        cell = [[EditInforCell alloc] init];
    }
    //NSLog(@"selectedIndexForEdit: %d", self.selectedIndexForEdit);
    switch (indexPath.row)
    {
        case 0:
            cell.cellType = AddressInAddr;
            if(self.selectedIndexForEdit >= 0)
            {
                cell.detailEdit.text = [[self.addrArray objectAtIndex:self.selectedIndexForEdit] objectForKey:DictAddrInAddrKey];
            }
            return cell;
        case 1:
            cell.cellType = PhoneInAddr;
            if(self.selectedIndexForEdit >= 0)
            {
                cell.detailEdit.text = [[self.addrArray objectAtIndex:self.selectedIndexForEdit] objectForKey:DictPhoneInAddrKey];
            }
            return cell;
        default:
            return [[UITableViewCell alloc] init];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    EditInforCell *cell = (EditInforCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell.titleLabel becomeFirstResponder];
}

- (IBAction)saveClicked:(id)sender
{
    EditInforCell *cell;
    NSIndexPath *indexPath;
    
    indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    cell = (EditInforCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    NSString *addr = cell.detailEdit.text;
    
    indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    cell = (EditInforCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    NSString *phone = cell.detailEdit.text;
    
    if([phone length] == 0 || [addr length] == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请重新输入"
                                                            message:@"字段不能为空"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    NSDictionary *dict = @{DictPhoneInAddrKey: phone,
                           DictAddrInAddrKey: addr};
    
    [self.addrArray addObject:dict];
    
    [AppData saveAddrDataArray:self.addrArray];
    
    [self.navigationController popViewControllerAnimated:YES];
}



@end
