//
//  UserInfoViewController.m
//  BinFenV10
//
//  Created by Wang Long on 2/11/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import "UserInfoViewController.h"
#import "EditInforCell.h"
#import "AppData.h"
#import "EditUserInfoViewController.h"

static NSString *ShowUserInfoCellIdentifier = @"ShowUserInfoCell";

@interface UserInfoViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableDictionary *userInfoDict;

@property NSInteger selectedCellIndex;

@end

@implementation UserInfoViewController

- (void)initNavigationItem
{
    UIColor *backgroundColor = [UIColor colorWithRed:253/255.0f
                                               green:150/255.0f
                                                blue:93/255.0f
                                               alpha:1.0f];
    self.navigationItem.title = @"我的账号";
    [self.navigationController.navigationBar setBarTintColor:backgroundColor];
    [self.navigationController.navigationBar setTranslucent:NO];
}

- (void)initTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,
                                                                   self.view.bounds.size.width,
                                                                   44.0f * 3 + 12 - 1) //隐藏最后一行Cell的Seperator
                      ];
    self.tableView.scrollEnabled = NO;
    
    
    UINib *nib = [UINib nibWithNibName:@"EditInforCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:ShowUserInfoCellIdentifier];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
}

- (void)initUserInfo
{
    self.userInfoDict = [NSMutableDictionary dictionaryWithDictionary:[AppData loadUserInfoDict]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initUserInfo];
    
    [self initNavigationItem];
    
    [self initTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma UITAbleView DataSource, Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
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
    EditInforCell *cell = (EditInforCell *)[tableView dequeueReusableCellWithIdentifier:ShowUserInfoCellIdentifier];
    if(cell == nil)
    {
        cell = [[EditInforCell alloc] init];
    }
    
    switch (indexPath.row)
    {
        case 0:
            cell.cellType = UsernameInAccout;
            cell.detailEdit.text = [self.userInfoDict objectForKey:DictUsernameInAccountKey];
            return cell;
        case 1:
            cell.cellType = PhoneInAccount;
            cell.detailEdit.text = [self.userInfoDict objectForKey:DictPhoneNumInAccountKey];
            return cell;
        case 2:
            cell.cellType = PasswordInAccount;
            cell.detailEdit.text = [self.userInfoDict objectForKey:DictPasswordInAccountKey];
            return cell;
        default:
            return [[UITableViewCell alloc] init];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    EditUserInfoViewController *vc = (EditUserInfoViewController *)segue.destinationViewController;
    vc.editUserInfoType = (int)self.selectedCellIndex;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedCellIndex = indexPath.row;
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self performSegueWithIdentifier:@"EditUserInfoSegue" sender:self];
}

@end
