//
//  AboutMeViewController.m
//  BinFenV10
//
//  Created by Wang Long on 2/10/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import "AboutMeViewController.h"
#import "UserInforTableViewCell.h"
#import "BasicSettingTableCell.h"
#import "AboutProductViewController.h"
#import "ShoppingCartViewController.h"

static NSString *UserInfoCellIdentifier = @"UserInfoCell";
static NSString *BasicSettingCellIdentifier = @"BasicSettingCell";

typedef enum
{
    SectionIndexUser = 0,
    SectionIndexAddr,
    SectionIndexOthers,
    SectionIndexAbout
} SectionIndexType;

@interface AboutMeViewController () <UITableViewDataSource, UITableViewDelegate, AvatarChangeDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation AboutMeViewController


- (void)initNavigationItem
{
    UIColor *backgroundColor = [UIColor colorWithRed:70/255.0f green:159/255.0f blue:183/255.0f alpha:1.0f];
    self.navigationItem.title = @"关于";
    [self.navigationController.navigationBar setBarTintColor:backgroundColor];
    [self.navigationController.navigationBar setTranslucent:NO];
}

- (void)initTableView
{
    CGFloat navigationBarHeight = self.navigationController.navigationBar.frame.size.height;
    CGFloat tabBarHeight = self.tabBarController.tabBar.frame.size.height;

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,
                                                                   self.view.bounds.size.width,
                                                                   self.view.bounds.size.height - navigationBarHeight - tabBarHeight)];
    
    self.tableView.backgroundColor = [UIColor colorWithRed:225/255.0f
                                                     green:225/255.0f
                                                      blue:225/255.0f
                                                     alpha:1.0f];
    
    // Remove the separator lines for emtpy cells
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.tableFooterView = footerView;
    
    
    UINib *nib = [UINib nibWithNibName:@"UserInforTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:UserInfoCellIdentifier];
    
    nib = [UINib nibWithNibName:@"BasicSettingTableCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:BasicSettingCellIdentifier];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initNavigationItem];
    [self initTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma UITAbleView DataSouce and Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case SectionIndexUser:
            return 1;
    
        case SectionIndexAddr:
            return 1;
            
        case SectionIndexOthers:
            return 3;
            
        case SectionIndexAbout:
            return 1;
            
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger sectionIndex = indexPath.section;
    switch (sectionIndex)
    {
        case SectionIndexUser:
        {
            UserInforTableViewCell *cell = (UserInforTableViewCell *)[tableView dequeueReusableCellWithIdentifier:UserInfoCellIdentifier];
            if(cell == nil)
            {
                cell = [[UserInforTableViewCell alloc] init];
            }
            cell.editDelegate = self;
            return cell;
        }
            
        case SectionIndexAddr:
        {
            BasicSettingTableCell *cell = (BasicSettingTableCell *)[tableView dequeueReusableCellWithIdentifier:BasicSettingCellIdentifier];
            if(cell == nil)
                cell = [[BasicSettingTableCell alloc] init];
            cell.symbolImage.image = [UIImage imageNamed:@"AddrEdit"];
            cell.titleLabel.text = @"送货地址管理";
            
            return cell;
        }
            
        case SectionIndexOthers:
        {
            BasicSettingTableCell *cell = (BasicSettingTableCell *)[tableView dequeueReusableCellWithIdentifier:BasicSettingCellIdentifier];
            if(cell == nil)
            {
                cell = [[BasicSettingTableCell alloc] init];
            }
            if(indexPath.row == 0)
            {
                cell.symbolImage.image = [UIImage imageNamed:@"OrderEdit"];
                cell.titleLabel.text = @"订单";
            }
            if(indexPath.row == 1)
            {
                cell.symbolImage.image = [UIImage imageNamed:@"FavoriteEdit"];
                cell.titleLabel.text = @"收藏";
            }
            if(indexPath.row == 2)
            {
                cell.symbolImage.image = [UIImage imageNamed:@"ShoppingCart"];
                cell.titleLabel.text = @"购物车";
            }
            return cell;
        }
        
        case SectionIndexAbout:
        {
            BasicSettingTableCell *cell = (BasicSettingTableCell *)[tableView dequeueReusableCellWithIdentifier:BasicSettingCellIdentifier];
            if(cell == nil)
            {
                cell = [[BasicSettingTableCell alloc] init];
            }
            cell.symbolImage.image = [UIImage imageNamed:@"About"];
            cell.titleLabel.text = @"关于";
            return cell;
        }
            
        default:
            return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == SectionIndexUser)
    {
        return 76.0f;
    } else {
        return 44.0f;
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController *vc = (UIViewController *)segue.destinationViewController;
    vc.hidesBottomBarWhenPushed = YES;
    
    if([segue.identifier isEqualToString:@"ShowShoppingCartFromAboutSegue"])
    {
        ShoppingCartViewController *cartVC = (ShoppingCartViewController *)segue.destinationViewController;
        cartVC.showShoppingCartViewFrom = ShowViewFromOthers;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section)
    {
        case SectionIndexUser:
        {
            [self performSegueWithIdentifier:@"ShowUserInfoSegue" sender:self];
            break;
        }
        case SectionIndexAddr:
        {
            [self performSegueWithIdentifier:@"ShowAddrEditSegue" sender:self];
            break;
        }
        case SectionIndexOthers:
        {
            if(indexPath.row == 0) //订单
            {
                [self performSegueWithIdentifier:@"ShowOrdersSegue" sender:self];
            }
            if(indexPath.row == 1)// 收藏
            {
                [self performSegueWithIdentifier:@"ShowFavoriateSegue" sender:self];
            }
            if(indexPath.row == 2) //购物车
            {
                [self performSegueWithIdentifier:@"ShowShoppingCartFromAboutSegue" sender:self];
            }
            break;
        }
        
        case SectionIndexAbout:
        {
            [self performSegueWithIdentifier:@"ShowAboutProductSegue" sender:self];
            break;
        }
            
        default:
            break;
    }
}

#pragma mark - AvatarChangeDelegate

- (void)editClicked:(UserInforTableViewCell *)cell
{
    NSLog(@"Edit Avatar");
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    /*
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
    }
     */
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark -
#pragma mark ImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    NSLog(@"info = %@",info);
    
    UIImage *editedImage;
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if([mediaType isEqualToString:@"public.movie"])			//被选中的是视频
    {

    }
    else if([mediaType isEqualToString:@"public.image"])	//被选中的是图片
    {
        //获取照片实例
        editedImage = [info objectForKey:UIImagePickerControllerEditedImage];
        
        [self performSelector:@selector(saveImg:) withObject:editedImage afterDelay:0.0];
    }
    else
    {
        NSLog(@"Error media type");
        return;
    }
}

-(void)saveImg:(UIImage *) image
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:SectionIndexUser];
    UserInforTableViewCell *cell = (UserInforTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    cell.userImage.image = image;
}

@end
