//
//  ProductTableCartCell.h
//  BinFenV10
//
//  Created by Wang Long on 3/2/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProductTableCartCell;

@protocol ItemCheckedDelegate <NSObject>

- (void)productItemChecked:(ProductTableCartCell *)cell;

@end

@interface ProductTableCartCell : UITableViewCell

@property (weak, nonatomic) id<ItemCheckedDelegate> itemCheckedDelegate;

@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *quantityLabel;
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *itemCheckImage;

@end
