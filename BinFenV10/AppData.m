//
//  AppData.m
//  BinFenV10
//
//  Created by Wang Long on 2/11/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import "AppData.h"

@implementation AppData

+ (NSString *)filePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    NSString *path = [basePath stringByAppendingPathComponent:@"AppData.plist"];
    return path;
}

+ (NSArray *)loadAddrDataArray
{
    NSArray *array;
    
    NSString *filePath = [self filePath];
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        array = [NSArray arrayWithContentsOfFile:filePath];
    } else {
        array = nil;
    }
    return array;
}

+ (void)saveAddrDataArray:(NSArray *)array
{
    NSString *filePath = [self filePath];
    [array writeToFile:filePath atomically:YES];
}

+ (NSDictionary *)loadUserInfoDict
{
    NSDictionary *dict;
    
    NSString *filePath = [self filePath];
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        dict = [NSDictionary dictionaryWithContentsOfFile:filePath];
    } else {
        dict = nil;
    }
    return dict;
}

+ (void)saveUserInfoDict:(NSDictionary *)dict
{
    NSString *filePath = [self filePath];
    [dict writeToFile:filePath atomically:YES];
}

@end
