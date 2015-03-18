//
//  OrderListViewController.m
//  BinFenV10
//
//  Created by Wang Long on 2/12/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import "OrderListViewController.h"
#import "OrderItemCell.h"

static NSString *OrderItemCellIdentifier = @"OrderItemCell";

static const NSInteger NeedPayImageTag = 41;
static const NSInteger PaidImageTag = 42;
static const NSInteger HistoryImageTag = 43;

@interface OrderListViewController () <UITableViewDataSource, UITableViewDelegate, ButtonClickDelegate>


@property (weak, nonatomic) IBOutlet UIImageView *needPayImage;
@property (weak, nonatomic) IBOutlet UILabel *needPayLabel;

@property (weak, nonatomic) IBOutlet UIImageView *paidImage;
@property (weak, nonatomic) IBOutlet UILabel *paidLabel;

@property (weak, nonatomic) IBOutlet UIImageView *historyImage;
@property (weak, nonatomic) IBOutlet UILabel *historyLabel;

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *needPayOrderList;
@property (strong, nonatomic) NSMutableArray *paidOrderList;
@property (strong, nonatomic) NSMutableArray *historyOrderList;

@property OrderCellType selectedOrderType;

@end


@implementation OrderListViewController

- (void)initOrderListArray
{
    self.needPayOrderList = [[NSMutableArray alloc] init];
    [self.needPayOrderList addObject:@"Order1"];
    [self.needPayOrderList addObject:@"订单2"];
    [self.needPayOrderList addObject:@"订单3"];
    
    self.paidOrderList = [[NSMutableArray alloc] init];
    [self.paidOrderList addObject:@"Order1"];
    [self.paidOrderList addObject:@"订单2"];
    [self.paidOrderList addObject:@"订单3"];
    [self.paidOrderList addObject:@"Order_4"];
    
    self.historyOrderList = [[NSMutableArray alloc] init];
    [self.historyOrderList addObject:@"Order1"];
    [self.historyOrderList addObject:@"订单2"];
    [self.historyOrderList addObject:@"订单3"];
    [self.historyOrderList addObject:@"Order_41"];
    [self.historyOrderList addObject:@"Order_42"];
    
    self.selectedOrderType = OrderCellTypeNeedPay;
}

- (void)initTableView
{
    CGFloat navigationBarHeight = self.navigationController.navigationBar.frame.size.height;
    
    // table上方的订单类型选择区域高度为95: 12 + 12 ＋ 44 ＋ 8 ＋ 21 ＋ 10
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 95,
                                                                   self.view.bounds.size.width,
                                                                   self.view.bounds.size.height - navigationBarHeight - 12 - 95 - 20)];
    
    
    self.tableView.backgroundColor = [UIColor lightGrayColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // Remove the separator lines for emtpy cells
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.tableFooterView = footerView;
    
    UINib *nib = [UINib nibWithNibName:@"OrderItemCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:OrderItemCellIdentifier];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
}

- (void)setLabelHightlightedColor:(UILabel *)label
{
    self.needPayLabel.textColor = [UIColor blackColor];
    self.paidLabel.textColor = [UIColor blackColor];
    self.historyLabel.textColor = [UIColor blackColor];
    
    label.textColor = [UIColor colorWithRed:253/255.0f green:155/255.0f blue:90/255.0f alpha:1.0f];
}

- (void)imageTapped:(UIGestureRecognizer *)gestureRecognizer
{
    UIImageView *imageView = (UIImageView *)gestureRecognizer.view;
    switch (imageView.tag)
    {
        case NeedPayImageTag:
            NSLog(@"Need Pay");
            if(self.selectedOrderType != OrderCellTypeNeedPay)
            {
                self.selectedOrderType = OrderCellTypeNeedPay;
                [self setLabelHightlightedColor:self.needPayLabel];
                [self.tableView reloadData];
            }
            break;
        
        case PaidImageTag:
            NSLog(@"Paid");
            if(self.selectedOrderType != OrderCellTypePaid)
            {
                self.selectedOrderType = OrderCellTypePaid;
                [self setLabelHightlightedColor:self.paidLabel];
                [self.tableView reloadData];
            }
            break;
            
        case HistoryImageTag:
            NSLog(@"History");
            if(self.selectedOrderType != OrderCellTypeHistory)
            {
                self.selectedOrderType = OrderCellTypeHistory;
                [self setLabelHightlightedColor:self.historyLabel];
                [self.tableView reloadData];
            }
            break;
            
        default:
            break;
    }
}

- (void)initImageViewActions
{
    [self addActionInView:self.needPayImage Tag:NeedPayImageTag];
    [self addActionInView:self.paidImage Tag:PaidImageTag];
    [self addActionInView:self.historyImage Tag:HistoryImageTag];
    
    //default
    [self setLabelHightlightedColor:self.needPayLabel];
}

- (void)addActionInView:(UIImageView *)imageView Tag:(NSInteger)tag
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.numberOfTouchesRequired = 1;
    
    imageView.tag = tag;
    imageView.userInteractionEnabled = YES;
    [imageView addGestureRecognizer:tapGesture];
    
    // Performance
    imageView.layer.cornerRadius = 22.0f;
    imageView.layer.masksToBounds = NO;
    imageView.layer.shouldRasterize = YES;
    imageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    /////
    //imageView.layer.borderWidth = 1.0f;
    //imageView.layer.borderColor = [UIColor whiteColor].CGColor;
    imageView.clipsToBounds = YES;
    imageView.alpha = 1.0f;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initOrderListArray];
    
    [self initImageViewActions];
    
    [self initTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma UITableView DataSource, Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return [self.orderListArray count];
    switch (self.selectedOrderType)
    {
        case OrderCellTypeNeedPay:
            return [self.needPayOrderList count];
            
        case OrderCellTypePaid:
            return [self.paidOrderList count];
            
        case OrderCellTypeHistory:
            return [self.historyOrderList count];
            
        default:
            return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 144.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderItemCell *cell = (OrderItemCell *)[tableView dequeueReusableCellWithIdentifier:OrderItemCellIdentifier];
    if(cell == nil)
        cell = [[OrderItemCell alloc] init];
    
    cell.buttonClickDelegate = self;
    
    switch (self.selectedOrderType)
    {
        case OrderCellTypeNeedPay:
            cell.statusLabel.text = @"待支付";
            [cell.leftButton setTitle:@"取消订单" forState:UIControlStateNormal];
            [cell.rightButton setTitle:@"付款" forState:UIControlStateNormal];
            break;
            
        case OrderCellTypePaid:
            cell.statusLabel.text = @"待收货";
            [cell.leftButton setTitle:@"查看物流" forState:UIControlStateNormal];
            [cell.rightButton setTitle:@"收货" forState:UIControlStateNormal];
            break;
            
        case OrderCellTypeHistory:
            cell.statusLabel.text = @"待评价";
            [cell.leftButton setTitle:@"删除订单" forState:UIControlStateNormal];
            [cell.rightButton setTitle:@"评价" forState:UIControlStateNormal];
            break;
            
        default:
            break;
    }
    
    return cell;
}

#pragma ButtonClickDelegate

- (void)leftButtonClicked:(OrderItemCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSLog(@"Left Clicked: %d", (int)indexPath.row);
}

- (void)rightButtonClicked:(OrderItemCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSLog(@"Right Clicked: %d", (int)indexPath.row);
    
    switch (self.selectedOrderType)
    {
        case OrderCellTypeHistory:
            [self performSegueWithIdentifier:@"ComposeCommentSegue" sender:self];
            break;
            
        default:
            break;
    }
}

@end
