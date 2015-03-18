//
//  CategoryData.m
//  BinFenV10
//
//  Created by Wang Long on 3/3/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import "CategoryData.h"

static NSString *CategoryNameKey = @"CategoryName";
static NSString *CategoryIDKey = @"CategoryID";
static NSString *CategoryIconKey = @"CategoryIcon";

@implementation CategoryData

- (id)initWithCoder:(NSCoder *)decoder
{
    if((self = [super init]))
    {
        self.categoryName = [decoder decodeObjectForKey:CategoryNameKey];
        self.categoryID = [[decoder decodeObjectForKey:CategoryIDKey] integerValue];
        self.categoryIcon = [decoder decodeObjectForKey:CategoryIconKey];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.categoryName forKey:CategoryNameKey];
    [encoder encodeObject:[NSNumber numberWithInteger:self.categoryID] forKey:CategoryIDKey];
    [encoder encodeObject:self.categoryIcon forKey:CategoryIconKey];
}

@end
