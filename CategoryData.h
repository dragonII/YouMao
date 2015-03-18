//
//  CategoryData.h
//  BinFenV10
//
//  Created by Wang Long on 3/3/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CategoryData : NSObject <NSCoding>

@property (nonatomic, copy) NSString *categoryName;
@property (nonatomic, assign) NSInteger categoryID;
@property (nonatomic, strong) NSString *categoryIcon;

@end
