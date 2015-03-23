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

static const NSInteger SectionImageAndPriceInfo = 0;
static const NSInteger SectionBasicInfo = 1;
static const NSInteger SectionComments = 2;

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
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, mainFrame.size.height - bottomViewHeight - 64, mainFrame.size.width, 44)];
    bottomView.backgroundColor = [UIColor whiteColor];
    
    self.addToCartButton = [[UIButton alloc] initWithFrame:CGRectMake(16, 7, 34, 30)];
    [self.addToCartButton setBackgroundImage:[UIImage imageNamed:@"AddToCart"] forState:UIControlStateNormal];
    [self.addToCartButton setBackgroundImage:[UIImage imageNamed:@"AddToCartSelected"] forState:UIControlStateSelected];
    [self.addToCartButton addTarget:self action:@selector(addToCartClicked:) forControlEvents:UIControlEventTouchUpInside];
    //[bottomView addSubview:self.addToCartButton];
    
    self.quantityInCartLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 16, 35, 12)];
    UIFont *font = [UIFont fontWithName:@"STHeitiSC-Light" size:12];
    self.quantityInCartLabel.font = font;
    self.quantityInCartLabel.textColor = [UIColor redColor];
    self.quantityInCartLabel.text = @"0";
    //[bottomView addSubview:self.quantityInCartLabel];
    
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
    [self.orderButton setTitle:@"点击购买" forState:UIControlStateNormal];
    self.orderButton.layer.cornerRadius = 5.0f;
    //self.orderButton.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"OrderButtonBG"]];
    self.orderButton.backgroundColor = [UIColor colorWithRed:70/255.0f green:159/255.0f blue:183/255.0f alpha:1.0f];
    [self.orderButton addTarget:self action:@selector(orderClicked:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:self.orderButton];
    
    [self.view addSubview:bottomView];
    
}

- (void)initTableView
{
    CGRect tableViewFrame;
    CGFloat bottomViewHeight = 44.0f;
    
    DeviceHardwareGeneralPlatform generalPlatform = [DeviceHardware generalPlatform];
    
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
    /*
    for(NSDictionary *dict in self.dataModel.products)
    {
        if([self.productID isEqualToString:[dict objectForKey:@"ID"]])
        {
            self.product = [NSMutableDictionary dictionaryWithDictionary:dict];
        }
    }
     */
    self.product = [NSMutableDictionary dictionaryWithDictionary:[self.dataModel.products objectAtIndex:self.selectedProductIndex]];
    
    if(self.product != nil)
    {
        self.navigationItem.title = [self.product objectForKey:@"name"];
        UIColor *backgroundColor = [UIColor colorWithRed:70/255.0f green:159/255.0f blue:183/255.0f alpha:1.0f];
        [self.navigationController.navigationBar setBarTintColor:backgroundColor];
        [self.navigationController.navigationBar setTranslucent:NO];
    }
    
    /*
    [self.dataModel loadCommentsByProductID:self.productID];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                  target:self
                                                selector:@selector(loadingCommentData)
                                                userInfo:nil repeats:YES];
     */
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma TableView Delegate, DataSource

// 含有3个Section，图片，商品基本信息和用户评论信息，当无评论时，section隐藏
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

//Image, Price, Description, Seperator, Comments (0 or N)
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == SectionImageAndPriceInfo)
    {
        return 2; // Image and Price
    }
    if(section == SectionBasicInfo)
    {
        return 2; // Desc and separator
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
    if(indexPath.section == SectionImageAndPriceInfo)
    {
        if(indexPath.row == 0)
        {
            ProductImageCell *cell = (ProductImageCell *)[tableView dequeueReusableCellWithIdentifier:ProductImageCellIdentifier];
            if(cell == nil)
            {
                cell = [[ProductImageCell alloc] init];
            }
            
            //cell.imageNamesArray = @[[self.product objectForKey:@"image"]];
            cell.imageNamesArray = @[[self.product objectForKey:@"image1"],
                                     [self.product objectForKey:@"image2"],
                                     [self.product objectForKey:@"image3"],
                                     [self.product objectForKey:@"image4"]];
            return cell;
        } else
        {
            PriceTableCell *cell = (PriceTableCell *)[tableView dequeueReusableCellWithIdentifier:ProductPriceCellIdentifier];
            if(cell == nil)
            {
                cell = [[PriceTableCell alloc] init];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    if(indexPath.section == SectionBasicInfo)
    {
        switch (indexPath.row)
        {
            case 0: //ProductDescriptionCellIndex:
            {
                DescriptionTableCell *cell = (DescriptionTableCell *)[tableView dequeueReusableCellWithIdentifier:ProductDescriptionIdentifier];
                if(cell == nil)
                {
                    cell = [[DescriptionTableCell alloc] init];
                }
                cell.descriptionString = [self.product objectForKey:@"description"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
            case 1: //SeperatorCellIndex:
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
    if(indexPath.section == SectionImageAndPriceInfo)
    {
        if(indexPath.row == 0) //ProductImageCellIndex
            return 200.0f;
        if(indexPath.row == 1) //ProductPriceCellIndex
            return 28.0f;
    }
    if(indexPath.section == SectionBasicInfo)
    {
        switch (indexPath.row)
        {
            case 0: //ProductDescriptionCellIndex:
                return 256;
            
            case 1: //SeperatorCellIndex:
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

- (void)categoryButtonClicked:(UIButton *)sender
{
    UIButton *button = sender;
    NSInteger tag = button.tag - 150;
    NSLog(@"categoryButton: %d clicked", tag);
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    DescriptionTableCell *cell = (DescriptionTableCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    NSArray *array = @[@"90分钟香艳秀场，近百名魔鬼身材的性感美女上演精彩的“上空秀”，火辣爆表，怎能错过！上空秀自1981年开演以来，口碑一直很好，票房也一支独秀，是这座罪恶之城历史最为悠久的表演秀，并被碧昂斯创意总监设计的新的舞蹈动作和故事情节刷新纪录。曼妙的身材、精致豪华的舞台设计，训练有素的舞台演出、热闹紧凑的内容……都是吸引观众的卖点！还可以重现泰坦尼克等举世有名的场面！",
                       @"如果你正在考虑哈佛大学，或者你只是想看看这所常春藤联盟学校的学生生活是怎样的，那这一个小时的“Hahvahd”之旅绝对是为您设计的！可以听到哈佛在校大学生独家爆料大学生活，他将从内幕人员的视角，精彩绝伦的讲解哈佛学生生活的情景。还可以参观历史建筑，游览哈佛校园和哈佛广场，聆听学校历史掌故，了解学校知名人物。您可以选择参观哈佛自然史博物馆去体验哈佛之旅或先去参观哈佛自然史博物馆，然后到任吃到饱的冰火餐厅享用午餐，二选一。",
                       @"这是华特迪士尼创建的第一座原创主题公园，是地球上最欢乐的地方。进入其中的每一个园区，熟悉的电影画面也就随之栩栩如生地展现您的面前，您会不断发掘这个神奇、幻想世界里的奥妙。加州冒险乐园以您从未想象过的方式，发掘您喜爱的迪士尼故事和卡通人物。和各个熟悉的卡通人物一起参加丰富多彩的冒险活动，开启新鲜有趣的体验活动。"];
    if(tag > 0 && tag < 4)
    {
        cell.descriptionString = [array objectAtIndex:tag - 1];
    } else {
        cell.descriptionString = [self.product objectForKey:@"description"];
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
    } if(section == SectionBasicInfo)
    {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44.0f)];
        headerView.layer.borderWidth = 0.5f;
        headerView.layer.borderColor = [UIColor whiteColor].CGColor;
        NSArray *array = @[@"产品简介", @"详细信息", @"预定须知", @"点评咨询"];
        for(int i = 0; i < 4; i++)
        {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((102 + 2) * i, 0, 102, 44)];
            button.tag = 150 + i;
            [button setBackgroundColor:[UIColor lightGrayColor]];
            [button setTitle:[array objectAtIndex:i] forState:UIControlStateNormal];
            [button setTitle:[array objectAtIndex:i] forState:UIControlStateSelected];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [button addTarget:self action:@selector(categoryButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            /*
            if(i < 3)
            {
                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(102 * (i+1), 4, 0.5, 36)];
                line.backgroundColor = [UIColor lightGrayColor];
                [headerView addSubview:line];
            }
             */
            [headerView addSubview:button];
        }
        return headerView;
    } else
        return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section)
    {
        case SectionBasicInfo:
            return 44.0f;
        case SectionComments:
            return 28.0f;
            
        default:
            return 0;
    }
}

@end
