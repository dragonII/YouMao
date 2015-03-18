//
//  BFPreferenceData.h
//  sterminal
//
//  Created by Wang Long on 1/23/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BFPreferenceData : NSObject

+ (NSDictionary *)getPreferenceDict;

+ (NSString *)getFirstLaunchKey;

+ (void)saveTestDataArray:(NSArray *)array;
+ (NSArray *)loadTestDataArray;

@end
