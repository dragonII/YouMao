//
//  AppData.h
//  BinFenV10
//
//  Created by Wang Long on 2/11/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *DictPhoneInAddrKey = @"PhoneInAddr";
static NSString *DictAddrInAddrKey = @"AddrInAddr";

static NSString *DictUsernameInAccountKey = @"UsernameInAccount";
static NSString *DictPhoneNumInAccountKey = @"PhoneNumInAccount";
static NSString *DictPasswordInAccountKey = @"PasswordInAccount";

@interface AppData : NSObject

+ (NSArray *)loadAddrDataArray;
+ (void)saveAddrDataArray:(NSArray *)array;

+ (NSDictionary *)loadUserInfoDict;
+ (void)saveUserInfoDict:(NSDictionary *)dict;

@end
