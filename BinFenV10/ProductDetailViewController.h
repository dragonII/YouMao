//
//  ProductDetailViewController.h
//  BinFenV10
//
//  Created by Wang Long on 2/7/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "defs.h"

@interface ProductDetailViewController : UIViewController

@property ShowViewBySourceType showProductViewFrom;

@property (copy, nonatomic) NSString *productID;
@property (assign, nonatomic) NSInteger selectedProductIndex;

@end
