//
//  CommunityData.m
//  BinFenV10
//
//  Created by Wang Long on 3/3/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import "CommunityData.h"

static NSString *CommunityNameKey = @"CommunityName";
static NSString *CommunityIDKey = @"CommunityID";
static NSString *CommunityImagesKey = @"CommunityImages";
static NSString *CommunityAddressKey = @"CommunityAddress";
static NSString *CommunityDespKey = @"CommunityDescription";


@implementation CommunityData

- (id)initWithCoder:(NSCoder *)decoder
{
    if((self = [super init]))
    {
        self.communityName = [decoder decodeObjectForKey:CommunityNameKey];
        self.communityID = [[decoder decodeObjectForKey:CommunityIDKey] integerValue];
        self.imagesArray = [decoder decodeObjectForKey:CommunityImagesKey];
        self.address = [decoder decodeObjectForKey:CommunityAddressKey];
        self.communityDescription = [decoder decodeObjectForKey:CommunityDespKey];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.communityName forKey:CommunityNameKey];
    [encoder encodeObject:[NSNumber numberWithInteger:self.communityID] forKey:CommunityIDKey];
    [encoder encodeObject:self.imagesArray forKey:CommunityImagesKey];
    [encoder encodeObject:self.address forKey:CommunityAddressKey];
    [encoder encodeObject:self.communityDescription forKey:CommunityDespKey];
}


@end
