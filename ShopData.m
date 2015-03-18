//
//  ShopData.m
//  BinFenV10
//
//  Created by Wang Long on 3/3/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import "ShopData.h"
#import "CommunityData.h"

static NSString *ShopNameKey = @"ShopName";
static NSString *ShopIDKey = @"ShopID";
static NSString *ShopAddressKey = @"ShopAddress";
static NSString *ShopOwnerKey = @"ShopOwner";
static NSString *ShopCommunityKey = @"ShopCommunity";
static NSString *ShopProductsKey = @"ShopProducts";
static NSString *ShopImagesKey = @"ShopImages";
static NSString *ShopDescKey = @"ShopDescription";

@implementation ShopData

- (id)initWithCoder:(NSCoder *)decoder
{
    if((self = [super init]))
    {
        self.shopName = [decoder decodeObjectForKey:ShopNameKey];
        self.shopID = [[decoder decodeObjectForKey:ShopIDKey] integerValue];
        self.shopAddress = [decoder decodeObjectForKey:ShopAddressKey];
        self.shopOwner = [decoder decodeObjectForKey:ShopOwnerKey];
        self.commnity = [decoder decodeObjectForKey:ShopCommunityKey];
        self.productsArray = [decoder decodeObjectForKey:ShopProductsKey];
        self.imagesArray = [decoder decodeObjectForKey:ShopImagesKey];
        self.shopDescription = [decoder decodeObjectForKey:ShopDescKey];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.shopName forKey:ShopNameKey];
    [encoder encodeObject:[NSNumber numberWithInteger:self.shopID] forKey:ShopIDKey];
    [encoder encodeObject:self.shopAddress forKey:ShopAddressKey];
    [encoder encodeObject:self.shopOwner forKey:ShopOwnerKey];
    [encoder encodeObject:self.commnity forKey:ShopCommunityKey];
    [encoder encodeObject:self.productsArray forKey:ShopProductsKey];
    [encoder encodeObject:self.imagesArray forKey:ShopImagesKey];
    [encoder encodeObject:self.shopDescription forKey:ShopDescKey];
}


@end
