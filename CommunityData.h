//
//  CommunityData.h
//  BinFenV10
//
//  Created by Wang Long on 3/3/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommunityData : NSObject <NSCoding>

@property (copy, nonatomic) NSString *communityName;
@property (assign, nonatomic) NSInteger communityID;
@property (strong, nonatomic) NSMutableArray *imagesArray;
@property (copy, nonatomic) NSString *address;
@property (copy, nonatomic) NSString *communityDescription;

@end
