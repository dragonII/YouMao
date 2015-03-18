//
//  EditUserInfoViewController.m
//  BinFenV10
//
//  Created by Wang Long on 2/11/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import "EditUserInfoViewController.h"
#import "AppData.h"
#import "EditUserInfoCell.h"

static NSString *EditInfoCellIdentifier = @"EditInfoUserCell";

@interface EditUserInfoViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIButton *saveButton;

@end

@implementation EditUserInfoViewController

- (void)saveButtonClicked:(UIButton *)sender
{
    EditUserInfoCell *cell;
    NSIndexPath *indexPath;
    switch (self.editUserInfoType)
    {
        case EditUserNameInfo:
            indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            cell = (EditUserInfoCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            NSLog(@"Name: %@", cell.infoTextField.text);
            break;
            
        case EditUserPhoneNum:
            indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            cell = (EditUserInfoCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            NSLog(@"Phone: %@", cell.infoTextField.text);
            break;
            
        case EditUserPassword:
            indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            cell = (EditUserInfoCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            NSLog(@"Old: %@", cell.infoTextField.text);
            
            indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
            cell = (EditUserInfoCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            NSLog(@"New_1: %@", cell.infoTextField.text);
            
            indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
            cell = (EditUserInfoCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            NSLog(@"New_2: %@", cell.infoTextField.text);
            
        default:
            break;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initTableView
{
    CGRect tableFrame;

    switch (self.editUserInfoType)
    {
        case EditUserNameInfo:
        case EditUserPhoneNum:
            tableFrame = CGRectMake(0, 0, self.view.bounds.size.width, 44 + 12);
            break;
        
        case EditUserPassword:
            tableFrame = CGRectMake(0, 0, self.view.bounds.size.width, 44 * 3 + 12);
            break;
            
        default:
            tableFrame = CGRectZero;
            break;
    }
    
    self.tableView = [[UITableView alloc] initWithFrame:tableFrame];
    
    UINib *nib = [UINib nibWithNibName:@"EditUserInfoCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:EditInfoCellIdentifier];

    //[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.saveButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 288, 36)];
    self.saveButton.center = CGPointMake(CGRectGetMidX(self.view.bounds), tableFrame.size.height + 20 + 36/2);
    [self.saveButton setBackgroundImage:[UIImage imageNamed:@"SaveButtonBG"] forState:UIControlStateNormal];
    [self.saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [self.saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.saveButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.saveButton addTarget:self action:@selector(saveButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.saveButton];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma  UITableView DataSource, Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (self.editUserInfoType)
    {
        case EditUserNameInfo:
        case EditUserPhoneNum:
            return 1;
           
        case EditUserPassword:
            return 3;
            
        default:
            return 0;
    }
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
    EditUserInfoCell *cell = (EditUserInfoCell *)[tableView dequeueReusableCellWithIdentifier:EditInfoCellIdentifier];
    
    switch (self.editUserInfoType)
    {
        case EditUserNameInfo:
            cell.infoTextField.keyboardType = UIKeyboardTypeDefault;
            cell.infoTextField.placeholder = @"新用户名";
            [cell.infoTextField becomeFirstResponder];
            break;
            
        case EditUserPhoneNum:
            cell.infoTextField.keyboardType = UIKeyboardTypePhonePad;
            cell.infoTextField.placeholder = @"新手机号码";
            [cell.infoTextField becomeFirstResponder];
            break;
            
        case EditUserPassword:
            cell.infoTextField.keyboardType = UIKeyboardTypeASCIICapable;
            cell.infoTextField.secureTextEntry = YES;
            if(indexPath.row == 0)
            {
                cell.infoTextField.placeholder = @"原密码";
                [cell.infoTextField becomeFirstResponder];
            }
            if(indexPath.row == 1)
                cell.infoTextField.placeholder = @"新密码";
            if(indexPath.row == 2)
                cell.infoTextField.placeholder = @"新密码确认";
            break;
        default:
            break;
    }
    
    return cell;
}

@end
