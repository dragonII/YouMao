//
//  OrderDetailViewController.m
//  BinFenV10
//
//  Created by Wang Long on 2/9/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import "ShoppingCartViewController.h"
#import "DeviceHardware.h"
#import "ProductTableCartCell.h"
#import "TextInfoCartCell.h"
#import "CommentCartCell.h"

static NSString *ProductCartCellIdentifier = @"ProductCartCell";
static NSString *TextInfoCartCellIdentifier = @"TextCartCell";
static NSString *CommentCartCellIdentifier = @"CommentCartCell";

typedef enum
{
    ProductCartCellSection = 0,
    AddressCartCellSection,
    PaymentCartCellSection,
    CommentCartCellSection
} CartSectionIndexType;

@interface ShoppingCartViewController () <UITableViewDataSource, UITableViewDelegate, CommentEditDelegate, ItemCheckedDelegate>

@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *sortCartItemArray;

@end

@implementation ShoppingCartViewController

- (void)initTableView
{
    self.view.backgroundColor = [UIColor colorWithRed:225/255.0f
                                                green:225/255.0f
                                                 blue:225/255.0f
                                                alpha:1.0f];
    
    CGRect tableViewFrame;
    
    CGFloat bottomViewHeight = 49.0f;
    
    DeviceHardwareGeneralPlatform generalPlatform = [DeviceHardware generalPlatform];
    NSLog(@"generalPlatform: %d", generalPlatform);
    
    switch (generalPlatform)
    {
        case DeviceHardwareGeneralPlatform_iPhone_4:
        case DeviceHardwareGeneralPlatform_iPhone_4S:
        {
            CGFloat navigationBarHeight = self.navigationController.navigationBar.frame.size.height;
            CGFloat statusBarHeight = 20;
            if(self.showShoppingCartViewFrom == ShowViewFromHome)
            {
                tableViewFrame = CGRectMake(0, navigationBarHeight + statusBarHeight,
                                            self.view.bounds.size.width,
                                            self.view.bounds.size.height - navigationBarHeight - statusBarHeight -bottomViewHeight);
            } else {
                tableViewFrame = CGRectMake(0, 0,
                                            self.view.bounds.size.width,
                                            self.view.bounds.size.height - bottomViewHeight - statusBarHeight - 49 + 8);
            }
            break;
        }
        case DeviceHardwareGeneralPlatform_iPhone_5:
        case DeviceHardwareGeneralPlatform_iPhone_5C:
        case DeviceHardwareGeneralPlatform_iPhone_5S:
        case DeviceHardwareGeneralPlatform_iPhone_6:
        case DeviceHardwareGeneralPlatform_iPhone_6_Plus:
        {
            tableViewFrame = CGRectMake(0, 0,
                                        self.view.bounds.size.width,
                                        self.view.bounds.size.height - bottomViewHeight);
            break;
        }
            
        default:
            tableViewFrame = CGRectMake(0, 0,
                                        self.view.bounds.size.width,
                                        self.view.bounds.size.height - bottomViewHeight);
            break;
    }
    
    self.tableView = [[UITableView alloc] initWithFrame:tableViewFrame];
    self.tableView.backgroundColor = [UIColor colorWithRed:225/255.0f
                                                     green:225/255.0f
                                                      blue:225/255.0f
                                                     alpha:1.0f];
    
    // Remove the separator lines for emtpy cells
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.tableFooterView = footerView;
    
    UINib *nib = [UINib nibWithNibName:@"ProductTableCartCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:ProductCartCellIdentifier];
    
    nib = [UINib nibWithNibName:@"TextInfoCartCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:TextInfoCartCellIdentifier];
    
    nib = [UINib nibWithNibName:@"CommentCartCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:CommentCartCellIdentifier];
    
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.view addSubview:self.tableView];
}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)keyboardWasShown:(NSNotification *)notification
{
    DeviceHardwareGeneralPlatform generalPlatform = [DeviceHardware generalPlatform];
    if(generalPlatform == DeviceHardwareGeneralPlatform_iPhone_6 || generalPlatform == DeviceHardwareGeneralPlatform_iPhone_6_Plus)
    {
        return;
    }
    
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    NSLog(@"kbheight: %f", kbSize.height);
    UIEdgeInsets contentInsets;
    if(self.showShoppingCartViewFrom == ShowViewFromHome)
    {
        contentInsets = UIEdgeInsetsMake(0, 0, kbSize.height, 0);
    } else {
        contentInsets = UIEdgeInsetsMake(0, 0, kbSize.height, 0);
    }
    self.tableView.contentInset = contentInsets;
    self.tableView.scrollIndicatorInsets = contentInsets;
}

- (void)keyboardWillBeHidden:(NSNotification *)notification
{
    DeviceHardwareGeneralPlatform generalPlatform = [DeviceHardware generalPlatform];
    if(generalPlatform == DeviceHardwareGeneralPlatform_iPhone_6 || generalPlatform == DeviceHardwareGeneralPlatform_iPhone_6_Plus)
    {
        return;
    }
    
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.tableView.contentInset = contentInsets;
    self.tableView.scrollIndicatorInsets = contentInsets;
}

- (void)loadShoppingCartItems
{
    NSDictionary *dict1 = @{@"productName":@"a",
                            @"productID":@"a",
                           @"price":@"38.5",
                           @"quantity":@"1",
                           @"description":@"a description",
                            @"itemChecked": @0,
                           @"shop":@"id1"};
    NSDictionary *dict2 = @{@"productName":@"ab",
                            @"productID": @"ab",
                           @"price":@"318",
                           @"quantity":@"2",
                           @"description":@"ab description",
                            @"itemChecked": @0,
                           @"shop":@"id1"};
    NSDictionary *dict3 = @{@"productName":@"abc",
                            @"productID":@"abc",
                           @"price":@"28",
                           @"quantity":@"9",
                           @"description":@"abc description",
                            @"itemChecked": @0,
                           @"shop":@"id2"};
    NSDictionary *dict4 = @{@"productName":@"abcd",
                            @"productID":@"abcd",
                           @"price":@"17",
                           @"quantity":@"7",
                           @"description":@"abcd description",
                            @"itemChecked": @0,
                           @"shop":@"id2"};
    NSDictionary *dict5 = @{@"productName":@"abcde",
                            @"productID":@"abcde",
                           @"price":@"28",
                           @"quantity":@"6",
                           @"description":@"abcde description",
                            @"itemChecked": @0,
                           @"shop":@"id3"};
    NSDictionary *dict6 = @{@"productName":@"abcdef",
                            @"productID":@"abcdef",
                            @"price":@"24",
                            @"quantity":@"11",
                            @"description":@"abcdef description",
                            @"itemChecked": @0,
                            @"shop":@"id2"};
    NSDictionary *dict7 = @{@"productName":@"abcdefg",
                            @"productID":@"abcdefg",
                            @"price":@"23",
                            @"quantity":@"12",
                            @"description":@"abcdefg description",
                            @"itemChecked": @0,
                            @"shop":@"id3"};
    NSDictionary *dict8 = @{@"productName":@"abcdefgh",
                            @"productID":@"abcdefgh",
                            @"price":@"42",
                            @"quantity":@"5",
                            @"description":@"abcdefgh description",
                            @"itemChecked": @0,
                            @"shop":@"id1"};

    
    self.cartItemsArray = @[dict1, dict2, dict3, dict4, dict5, dict6, dict7, dict8];
    self.sortCartItemArray = [[NSMutableArray alloc] init];
    self.shopsArray = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *tmpDict;
    
    if([self.cartItemsArray count] > 0)
    {
        tmpDict = [[NSMutableDictionary alloc] init];
        [tmpDict setObject:@0 forKey:@"shopChecked"];
        [tmpDict setObject:@"" forKey:@"comment"];
        [tmpDict setObject:[[self.cartItemsArray objectAtIndex:0] objectForKey:@"shop"] forKey:@"shopID"];
        [self.shopsArray addObject:tmpDict];
        
        BOOL found;
        NSString *shopID;
        
        for(int i = 0; i < [self.cartItemsArray count]; i++)
        {
            found = NO;
            shopID = [[self.cartItemsArray objectAtIndex:i] objectForKey:@"shop"];
            for(int j = 0; j < [self.shopsArray count]; j++)
            {
                if([shopID isEqualToString:[[self.shopsArray objectAtIndex:j] objectForKey:@"shopID"]])
                {
                    found = YES;
                    break;
                }
            }
            if(found == NO)
            {
                tmpDict = [[NSMutableDictionary alloc] init];
                [tmpDict setObject:@0 forKey:@"shopChecked"];
                [tmpDict setObject:@"" forKey:@"comment"];
                [tmpDict setObject:shopID forKey:@"shopID"];
                [self.shopsArray addObject:tmpDict];
            }
        }
    }
    
    for(int i = 0; i < [self.shopsArray count]; i++)
    {
        NSMutableArray *tmpArray = [[NSMutableArray alloc] init];
        NSString *shopID = [[self.shopsArray objectAtIndex:i] objectForKey:@"shopID"];
        for(int j = 0; j < [self.cartItemsArray count]; j++)
        {
            if([shopID isEqualToString:[[self.cartItemsArray objectAtIndex:j] objectForKey:@"shop"]])
            {
                [tmpArray addObject:[self.cartItemsArray objectAtIndex:j]];
            }
        }
        [self.sortCartItemArray addObject:tmpArray];
    }
    
    self.itemCheckedDict = [[NSMutableDictionary alloc] init];
    for(int i = 0; i < [self.cartItemsArray count]; i++)
    {
        [self.itemCheckedDict setObject:@0 forKey:[[self.cartItemsArray objectAtIndex:i] objectForKey:@"productID"]];
    }
    
    //NSLog(@"cartItem: %@", self.cartItemsArray);
    //NSLog(@"shops: %@", self.shopsArray);
    //NSLog(@"Sorted: %@", self.sortCartItemArray);
}

- (void)initBottomView
{
    self.submitButton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ButtonBGOrange"]];
    self.submitButton.layer.cornerRadius = 5.0f;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"购物车";
    
    [self loadShoppingCartItems];
    
    [self initBottomView];
    
    [self initTableView];
    
    [self registerForKeyboardNotifications];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSLog(@"ShopArray: %@", self.shopsArray);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Delegate, DataSource for UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return 1;
    if(section == 0)
        return 1;
    else
    {
        // 货品列表和备注信息
        return [[self.sortCartItemArray objectAtIndex:(section - 1)] count] + 1;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // 按照店铺展示，顶部为收货联系信息
    return [self.shopsArray count] + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
        return 44;
    else
    {
        NSInteger index = indexPath.section - 1;
        if(indexPath.row != [[self.sortCartItemArray objectAtIndex:index] count])
            return 125;
        else
        {
            // 备注行
            return 44;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0)
        return 0;
    
    return 30.0f;
}

-(void)shopSelected:(UITapGestureRecognizer *)sender
{
    NSInteger tag = sender.view.tag - 50;
    UIImageView *checkImage = (UIImageView *)sender.view;
    NSInteger checkedStatus = [[[self.shopsArray objectAtIndex:tag] objectForKey:@"shopChecked"] integerValue];
    if(checkedStatus == 0)
    {
        [[self.shopsArray objectAtIndex:tag] setObject:@1 forKey:@"shopChecked"];
        checkImage.image = [UIImage imageNamed:@"CartItemSelected"];
    } else
    {
        [[self.shopsArray objectAtIndex:tag] setObject:@0 forKey:@"shopChecked"];
        checkImage.image = [UIImage imageNamed:@"CartItemNotSelected"];
    }
    
    [self.tableView reloadData];
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section == 0)
        return nil;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 30.0f)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *checkImageView = [[UIImageView alloc] initWithFrame:CGRectMake(11, 6, 18, 18)];
    NSInteger checkedStatus = [[[self.shopsArray objectAtIndex:section - 1] objectForKey:@"shopChecked"] integerValue];
    if(checkedStatus == 0)
        checkImageView.image = [UIImage imageNamed:@"CartItemNotSelected"];
    else
        checkImageView.image = [UIImage imageNamed:@"CartItemSelected"];
    checkImageView.tag = 50 + section - 1;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shopSelected:)];
    [checkImageView setUserInteractionEnabled:YES];
    [checkImageView addGestureRecognizer:tapGesture];
    
    UILabel *shopNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 5, 200, 21)];
    shopNameLabel.text = [[[self.sortCartItemArray objectAtIndex:(section - 1)] objectAtIndex:0] objectForKey:@"shop"];
    
    [headerView addSubview:checkImageView];
    [headerView addSubview:shopNameLabel];
    
    UIView *separatorLine = [[UIView alloc] initWithFrame:CGRectMake(0, 29, self.view.bounds.size.width, 0.5)];
    separatorLine.backgroundColor = [UIColor colorWithRed:225/255.0f
                                                    green:225/255.0f
                                                     blue:225/255.0f
                                                    alpha:1.0f];
    [headerView addSubview:separatorLine];
    
    return headerView;
}

-(void)itemSelected:(UITapGestureRecognizer *)sender
{
    NSInteger tag = sender.view.tag - 50;
    UIImageView *checkImage = (UIImageView *)sender.view;
    NSInteger checkedStatus = [[[self.shopsArray objectAtIndex:tag] objectForKey:@"shopChecked"] integerValue];
    if(checkedStatus == 0)
    {
        [[self.shopsArray objectAtIndex:tag] setObject:@1 forKey:@"shopChecked"];
        checkImage.image = [UIImage imageNamed:@"CartItemSelected"];
    } else
    {
        [[self.shopsArray objectAtIndex:tag] setObject:@0 forKey:@"shopChecked"];
        checkImage.image = [UIImage imageNamed:@"CartItemNotSelected"];
    }
    
    [self.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        TextInfoCartCell *cell = (TextInfoCartCell *)[tableView dequeueReusableCellWithIdentifier:TextInfoCartCellIdentifier];
        if(cell == nil)
            cell = [[TextInfoCartCell alloc] init];
        cell.textInfoTitleLabel.text = @"1234568 地址ABC";
        return cell;
    }
    
    int sectionIndex = (int)indexPath.section - 1;
    NSArray *itemInShopArray = [self.sortCartItemArray objectAtIndex:sectionIndex];
    if(indexPath.row < [itemInShopArray count])
    {
        ProductTableCartCell *cell = (ProductTableCartCell *)[tableView dequeueReusableCellWithIdentifier:ProductCartCellIdentifier];
        if(cell == nil)
            cell = [[ProductTableCartCell alloc] init];
        
        cell.itemCheckedDelegate = self;
        
        NSDictionary *infoDict = [[self.sortCartItemArray objectAtIndex:(indexPath.section - 1)] objectAtIndex:indexPath.row];
        cell.productNameLabel.text = [infoDict objectForKey:@"productName"];
        cell.priceLabel.text = [infoDict objectForKey:@"price"];
        cell.quantityLabel.text = [infoDict objectForKey:@"quantity"];
        NSInteger shopSelected = [[[self.shopsArray objectAtIndex:indexPath.section - 1] objectForKey:@"shopChecked"] integerValue];
        NSInteger itemSelected = [[self.itemCheckedDict objectForKey:@"productID"] integerValue];
        if(shopSelected == 1 || itemSelected == 1)
        {
            cell.itemCheckImage.image = [UIImage imageNamed:@"CartItemSelected"];
        } else {
            cell.itemCheckImage.image = [UIImage imageNamed:@"CartItemNotSelected"];
        }
        return cell;
    } else {
        CommentCartCell *cell = (CommentCartCell *)[tableView dequeueReusableCellWithIdentifier:CommentCartCellIdentifier];
        if(cell == nil)
            cell = [[CommentCartCell alloc] init];
        
        cell.commentTextField.text = [[self.shopsArray objectAtIndex:sectionIndex] objectForKey:@"comment"];
        cell.editDelegate = self;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)editClicked:(CommentCartCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSLog(@"Editting: %ld", indexPath.section - 1);
    NSInteger sectionIndex = indexPath.section - 1;
    [[self.shopsArray objectAtIndex:sectionIndex] setObject:cell.commentTextField.text forKey:@"comment"];
}

- (void)itemChecked:(ProductTableCartCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSString *productID = [[self.sortCartItemArray objectAtIndex:indexPath.section - 1] objectForKey:@"productID"];
    NSInteger checkedStatus = [[self.itemCheckedDict objectForKey:productID] integerValue];
    if(checkedStatus == 0)
    {
        [self.itemCheckedDict setObject:@1 forKey:productID];
        cell.itemCheckImage.image = [UIImage imageNamed:@"CartItemSelected"];
    } else {
        [self.itemCheckedDict setObject:@0 forKey:productID];
        cell.itemCheckImage.image = [UIImage imageNamed:@"CartItemNotSelected"];
    }
}

- (void)productItemChecked:(ProductTableCartCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    NSString *productID = [[[self.sortCartItemArray objectAtIndex:indexPath.section - 1] objectAtIndex:indexPath.row] objectForKey:@"productID"];

    NSInteger checkedStatus = [[self.itemCheckedDict objectForKey:productID] integerValue];
    if(checkedStatus == 0)
    {
        [self.itemCheckedDict setObject:@1 forKey:productID];
        cell.itemCheckImage.image = [UIImage imageNamed:@"CartItemSelected"];
    } else {
        [self.itemCheckedDict setObject:@0 forKey:productID];
        cell.itemCheckImage.image = [UIImage imageNamed:@"CartItemNotSelected"];
    }
}

@end
