//
//  OrderDetailViewController.h
//  BinFenV10
//
//  Created by Wang Long on 2/9/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "defs.h"

@interface ShoppingCartViewController : UIViewController

@property ShowViewBySourceType showShoppingCartViewFrom;

@property (strong, nonatomic) NSArray *cartItemsArray;
@property (strong, nonatomic) NSMutableArray *shopsArray;
@property (strong, nonatomic) NSMutableDictionary *itemCheckedDict;
//@property (strong, nonatomic) NSMutableDictionary *shopCheckedDict;

@end
