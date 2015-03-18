//
//  ProductDetailViewController.m
//  BinFenV10
//
//  Created by Wang Long on 2/7/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import "ProductDetailViewController.h"
#import "ProductImageCell.h"
#import "PriceTableCell.h"
#import "DescriptionTableCell.h"
#import "SeperatorTableCell.h"
#import "CommentTableViewCell.h"
#import "ShoppingCartViewController.h"
#import "DataModel.h"
#import "AFNetworking.h"
#import "AppDelegate.h"

#import "DeviceHardware.h"

static NSString *ProductImageCellIdentifier = @"ProductImageCell";
static NSString *ProductPriceCellIdentifier = @"ProductPriceCell";
static NSString *ProductDescriptionIdentifier = @"ProductDescription";
static NSString *SeperatorIdentifier = @"Seperator";
static NSString *CommentCellIdentifier = @"CommentCell";

static const NSInteger SectionBasicInfo = 0;
static const NSInteger SectionComments = 1;

static const NSInteger ProductImageCellIndex = 0;
static const NSInteger ProductPriceCellIndex = 1;
static const NSInteger ProductDescriptionCellIndex = 2;
static const NSInteger SeperatorCellIndex = 3;

@interface ProductDetailViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIButton *addToCartButton;
@property (strong, nonatomic) UILabel *quantityInCartLabel;
@property (strong, nonatomic) UIButton *shareButton;
@property (strong, nonatomic) UIButton *orderButton;

@property (strong, nonatomic) NSArray *commentArray;

@property (strong, nonatomic) DataModel *dataModel;
@property (strong, nonatomic) NSMutableArray *comments;

@property (strong, nonatomic) NSMutableDictionary *product;

@property (strong, nonatomic) AFHTTPSessionManager *httpSessionManager;

@property (assign, nonatomic) BOOL loadCommentFinished;

@property (strong, nonatomic) NSTimer *timer;

@end

@implementation ProductDetailViewController

- (IBAction)addToCartClicked:(UIButton *)sender
{
    UIButton *button = sender;
    [button setSelected:YES];
    [self performSelector:@selector(addingToCart:) withObject:button afterDelay:0.2f];
}

- (void)addingToCart:(UIButton *)button
{
    int quantity = [self.quantityInCartLabel.text intValue];
    quantity++;
    [self.quantityInCartLabel setText:[NSString stringWithFormat:@"%d", quantity]];
    [button setSelected:NO];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"ShowShoppingCartSegue"])
    {
        ShoppingCartViewController *cartVC = (ShoppingCartViewController *)segue.destinationViewController;
        cartVC.showShoppingCartViewFrom = self.showProductViewFrom;
    }
}

- (IBAction)orderClicked:(UIButton *)sender
{
    [self performSegueWithIdentifier:@"ShowShoppingCartSegue" sender:self];
}

- (void)initBottomView
{
    CGRect mainFrame = self.view.bounds;
    CGFloat bottomViewHeight = 44;
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, mainFrame.size.height - bottomViewHeight, mainFrame.size.width, 44)];
    bottomView.backgroundColor = [UIColor whiteColor];
    
    self.addToCartButton = [[UIButton alloc] initWithFrame:CGRectMake(16, 7, 34, 30)];
    [self.addToCartButton setBackgroundImage:[UIImage imageNamed:@"AddToCart"] forState:UIControlStateNormal];
    [self.addToCartButton setBackgroundImage:[UIImage imageNamed:@"AddToCartSelected"] forState:UIControlStateSelected];
    [self.addToCartButton addTarget:self action:@selector(addToCartClicked:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:self.addToCartButton];
    
    self.quantityInCartLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 16, 35, 12)];
    UIFont *font = [UIFont fontWithName:@"STHeitiSC-Light" size:12];
    self.quantityInCartLabel.font = font;
    self.quantityInCartLabel.textColor = [UIColor redColor];
    self.quantityInCartLabel.text = @"0";
    [bottomView addSubview:self.quantityInCartLabel];
    
    /*
    self.shareButton = [[UIButton alloc] initWithFrame:CGRectMake(98, 12, 20, 20)];
    [self.shareButton setBackgroundImage:[UIImage imageNamed:@"Share"] forState:UIControlStateNormal];
    [bottomView addSubview:self.shareButton];
     */
    
    CGFloat orderButtonWidth = 80.0f;
    CGFloat orderButtonHeight = 30.0f;
    CGRect orderButtonFrame = CGRectMake(bottomView.bounds.size.width - orderButtonWidth - 16,
                                         7,
                                         orderButtonWidth, orderButtonHeight);
    self.orderButton = [[UIButton alloc] initWithFrame:orderButtonFrame];
    [self.orderButton setTitle:@"购物车" forState:UIControlStateNormal];
    self.orderButton.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"OrderButtonBG"]];
    [self.orderButton addTarget:self action:@selector(orderClicked:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:self.orderButton];
    
    [self.view addSubview:bottomView];
    
}

- (void)initTableView
{
    CGRect tableViewFrame;
    CGFloat bottomViewHeight = 44.0f;
    
    DeviceHardwareGeneralPlatform generalPlatform = [DeviceHardware generalPlatform];
    NSLog(@"generalPlatform: %d", generalPlatform);
    
    switch (generalPlatform)
    {
        case DeviceHardwareGeneralPlatform_iPhone_4:
        case DeviceHardwareGeneralPlatform_iPhone_4S:
        {
            CGFloat navigationBarHeight = self.navigationController.navigationBar.frame.size.height;
            CGFloat statusBarHeight = 20;
            if(self.showProductViewFrom == ShowViewFromHome)
            {
            tableViewFrame = CGRectMake(0, navigationBarHeight + statusBarHeight,
                                        self.view.bounds.size.width,
                                        self.view.bounds.size.height - navigationBarHeight - statusBarHeight - bottomViewHeight);
            } else {
                tableViewFrame = self.view.frame;
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
        {
            tableViewFrame = CGRectMake(0, 0,
                                        self.view.bounds.size.width,
                                        self.view.bounds.size.height - bottomViewHeight);
            break;
        }
    }
    
    self.tableView = [[UITableView alloc] initWithFrame:tableViewFrame];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    UINib *nib = [UINib nibWithNibName:@"ProductImageCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:ProductImageCellIdentifier];
    
    nib = [UINib nibWithNibName:@"PriceTableCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:ProductPriceCellIdentifier];
    
    nib = [UINib nibWithNibName:@"DescriptionTableCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:ProductDescriptionIdentifier];
    
    nib = [UINib nibWithNibName:@"SeperatorTableCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:SeperatorIdentifier];
    
    [self.tableView registerClass:[CommentTableViewCell class] forCellReuseIdentifier:CommentCellIdentifier];
    
    /*
    UIEdgeInsets insets = self.tableView.contentInset;
    insets.top = 20;
    [self.tableView setContentInset:insets];
     */
     
    [self.view addSubview:self.tableView];
}


- (void)initProductData
{
    self.dataModel = [[DataModel alloc] init];
    [self.dataModel loadDataModelLocally];
    
    self.commentArray = @[
                          @{@"user":@"1234", @"comment":@"jdifjidbhj"},
                          @{@"user":@"ffff", @"comment":@"HelloWorld"},
                          @{@"user":@"gggg", @"comment":@"Hello World!"},
                          @{@"user":@"234", @"comment":@"中文评论字符"},
                          @{@"user":@"TestUser", @"comment":@"Is there a good way to adjust the size of a UITextView to conform to its content? Say for instance I have a UITextView that contains one line of text:\nIs there a good way in Cocoa Touch to get the rect that will hold all of the lines in the text view so that I can adjust the parent view accordingly?\nAs another example, look at the Notes field for events in the Calendar application--note how the cell (and the UITextView it contains) expands to hold all lines of text in the notes string."}];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initTableView];
    [self initBottomView];
    
    [self initProductData];
}

- (void)loadingCommentData
{
    if(self.dataModel.loadCommentsFinished == YES)
    {
        [self.timer invalidate];
        self.comments = [NSMutableArray arrayWithArray:self.dataModel.comments];
        [self.tableView reloadData];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //NSLog(@"%@", self.dataModel.products);
    
    //self.product = [[NSMutableDictionary alloc] init];
    for(NSDictionary *dict in self.dataModel.products)
    {
        if([self.productID isEqualToString:[dict objectForKey:@"ID"]])
        {
            self.product = [NSMutableDictionary dictionaryWithDictionary:dict];
        }
    }
    
    if(self.product != nil)
    {
        self.navigationItem.title = [self.product objectForKey:@"name"];
    }
    
    [self.dataModel loadCommentsByProductID:self.productID];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                  target:self
                                                selector:@selector(loadingCommentData)
                                                userInfo:nil repeats:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma TableView Delegate, DataSource

// 含有2个Section，商品基本信息和用户评论信息，当无评论时，section隐藏
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

//Image, Price, Description, Seperator, Comments (0 or N)
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == SectionBasicInfo)
    {
        return 4;
    }
    //具体评论信息数目根据来自服务器的信息为准，从0到N
    if(section == SectionComments)
    {
        //return [self.commentArray count];
        NSInteger num = [self.comments count];
        if(num == 0)
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        else
            tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        
        return num;
    }
    else
        return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == SectionBasicInfo)
    {
        switch (indexPath.row)
        {
            case ProductImageCellIndex: //ProductImageCell
            {
                ProductImageCell *cell = (ProductImageCell *)[tableView dequeueReusableCellWithIdentifier:ProductImageCellIdentifier];
                if(cell == nil)
                {
                    cell = [[ProductImageCell alloc] init];
                }
                
                cell.imageNamesArray = @[[self.product objectForKey:@"image"]];
                return cell;
            }
            case ProductPriceCellIndex:
            {
                PriceTableCell *cell = (PriceTableCell *)[tableView dequeueReusableCellWithIdentifier:ProductPriceCellIdentifier];
                if(cell == nil)
                {
                    cell = [[PriceTableCell alloc] init];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
            case ProductDescriptionCellIndex:
            {
                DescriptionTableCell *cell = (DescriptionTableCell *)[tableView dequeueReusableCellWithIdentifier:ProductDescriptionIdentifier];
                if(cell == nil)
                {
                    cell = [[DescriptionTableCell alloc] init];
                }
                return cell;
            }
            case SeperatorCellIndex:
            {
                SeperatorTableCell *cell = (SeperatorTableCell *)[tableView dequeueReusableCellWithIdentifier:SeperatorIdentifier];
                if(cell == nil)
                    cell = [[SeperatorTableCell alloc] init];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
            
            default:
                return  [[UITableViewCell alloc] init];
        }
    } else // section == SectionComment
    {
        CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CommentCellIdentifier];
        //NSString *commentText = [[self.commentArray objectAtIndex:indexPath.row] objectForKey:@"comment"];
        //NSString *commentUser = [[self.commentArray objectAtIndex:indexPath.row] objectForKey:@"user"];
        
        NSString *commentText = [[self.comments objectAtIndex:indexPath.row] objectForKey:@"Content"];
        NSString *commentUser = [[self.comments objectAtIndex:indexPath.row] objectForKey:@"UserName"];
        
        [cell setCommentText:commentText];
        [cell setCommentUser:commentUser];
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == SectionBasicInfo)
    {
        switch (indexPath.row)
        {
            case ProductImageCellIndex:
                return 200.0f;
            
            case ProductPriceCellIndex:
                return 28.0f;
            
            case ProductDescriptionCellIndex:
                return 92.0f;
            
            case SeperatorCellIndex:
                return 12.0f;
            
            default:
                return 0.0f;
        }
    } else
    {
        //NSString *commentText = [[self.commentArray objectAtIndex:indexPath.row] objectForKey:@"comment"];
        NSString *commentText = [[self.comments objectAtIndex:indexPath.row] objectForKey:@"Content"];
        CGSize textSize = [CommentTableViewCell sizeOfTextViewForText:commentText];

        //NSLog(@"Height: %f, width: %f", textSize.height + 40, textSize.width);
        return textSize.height + 40;
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section == SectionComments)
    {
        UIView *headerBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 28)];
        headerBackgroundView.backgroundColor = [UIColor whiteColor];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(headerBackgroundView.frame.origin.x + 16,
                                                              headerBackgroundView.frame.origin.y,
                                                              headerBackgroundView.frame.size.width - 16,
                                                               headerBackgroundView.frame.size.height)];
        label.text = @"评论";
        [headerBackgroundView addSubview:label];
        return headerBackgroundView;
    } else
    {
        return [[UIView alloc] initWithFrame:CGRectZero];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == SectionComments)
        return 28.0f;
    else
        return 0.0f;
}

@end
