//
//  OrderItemCell.h
//  BinFenV10
//
//  Created by Wang Long on 2/12/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

typedef enum {
    OrderCellTypeNeedPay = 0,
    OrderCellTypePaid,
    OrderCellTypeHistory
} OrderCellType;

#import <UIKit/UIKit.h>

@class OrderItemCell;
@protocol ButtonClickDelegate <NSObject>

- (void)leftButtonClicked:(OrderItemCell *)cell;
- (void)rightButtonClicked:(OrderItemCell *)cell;

@end

@interface OrderItemCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;

@property (weak, nonatomic) id<ButtonClickDelegate> buttonClickDelegate;

@property OrderCellType orderCellType;

@end
