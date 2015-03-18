//
//  ProductData.m
//  BinFenV10
//
//  Created by Wang Long on 3/3/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import "ProductData.h"

static NSString *ProductNameKey = @"ProductName";
static NSString *ProductIDKey = @"ProductID";
static NSString *ProductPriceKey = @"ProductPrice";
static NSString *ProductDiscountKey = @"ProductDiscount";
static NSString *ProductImagesKey = @"ProductImages";
static NSString *ProductDescKey = @"ProductDescription";

@implementation ProductData

- (id)initWithCoder:(NSCoder *)decoder
{
    if((self = [super init]))
    {
        self.productName = [decoder decodeObjectForKey:ProductNameKey];
        self.productID = [[decoder decodeObjectForKey:ProductIDKey] integerValue];
        self.priceString = [decoder decodeObjectForKey:ProductPriceKey];
        self.discountString = [decoder decodeObjectForKey:ProductDiscountKey];
        self.imagesArray = [decoder decodeObjectForKey:ProductImagesKey];
        self.productDescription = [decoder decodeObjectForKey:ProductDescKey];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.productName forKey:ProductNameKey];
    [encoder encodeObject:[NSNumber numberWithInteger:self.productID] forKey:ProductIDKey];
    [encoder encodeObject:self.priceString forKey:ProductPriceKey];
    [encoder encodeObject:self.discountString forKey:ProductDiscountKey];
    [encoder encodeObject:self.imagesArray forKey:ProductImagesKey];
    [encoder encodeObject:self.productDescription forKey:ProductDescKey];
}

@end
