//
//  ProductData.h
//  BinFenV10
//
//  Created by Wang Long on 3/3/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductData : NSObject <NSCoding>

@property (nonatomic, copy) NSString *productName;
@property (nonatomic, assign) NSInteger productID;
@property (nonatomic, copy) NSString *priceString;
@property (nonatomic, copy) NSString *discountString;
@property (nonatomic, strong) NSArray *imagesArray;
//商家信息
@property (nonatomic, copy) NSString *productDescription;

@end
