//
//  ShopData.h
//  BinFenV10
//
//  Created by Wang Long on 3/3/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CommunityData;

@interface ShopData : NSObject <NSCoding>

@property (nonatomic, copy) NSString *shopName;
@property (nonatomic, assign) NSInteger shopID;
@property (nonatomic, copy) NSString *shopAddress;
@property (nonatomic, copy) NSString *shopOwner;
@property (nonatomic, copy) CommunityData *commnity;
@property (nonatomic, strong) NSArray *productsArray;
@property (nonatomic, strong) NSArray *imagesArray;
@property (nonatomic, copy) NSString *shopDescription;

@end
