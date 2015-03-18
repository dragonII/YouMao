//
//  ThirdTableViewCell.h
//  BinFenV10
//
//  Created by Wang Long on 2/4/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ShopsCell;
@class DataModel;

@protocol ShopsCellSegueDelegate <NSObject>

- (void)shopItemClickedInCell:(ShopsCell *)cell;

@end

@interface ShopsCell : UITableViewCell

- (void)initShopItemsByCommunityIndex:(NSInteger)communityIndex;

@property (strong, nonatomic) DataModel *dataModel;

@property (copy, nonatomic) NSString *shopID;
@property (strong, nonatomic) NSMutableArray *shops;
@property (copy, nonatomic) NSString *productID;
@property (assign, nonatomic) NSInteger selectedShopIndex;

@property (strong, nonatomic) NSMutableArray *products;

@property (weak, nonatomic) id<ShopsCellSegueDelegate> segueDelegate;

@end
