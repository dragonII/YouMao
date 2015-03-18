//
//  BFPreferenceData.m
//  sterminal
//
//  Created by Wang Long on 1/23/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import "BFPreferenceData.h"

static NSString *GlobalPreferenceFileName = @"preference.plist";

@implementation BFPreferenceData

+ (NSString *)appNameAndVersionNumberDisplayString {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    //NSString *appDisplayName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    NSString *shortVersionString = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    //NSString *minorVersion = [infoDictionary objectForKey:@"CFBundleVersion"];
    
    //return [NSString stringWithFormat:@"%@, Version %@ (%@)",appDisplayName, majorVersion, minorVersion];
    return shortVersionString;
}

+ (NSString *)getShortVersionString
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    
    NSString *shortVersionString = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    return shortVersionString;
}

+ (NSString *)getFilePathWithName:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *prefereceFilePath = [documentDirectory stringByAppendingPathComponent:fileName];
    
    return prefereceFilePath;
}

+ (NSDictionary *) getDictionaryFilePreferenceFile:(NSString *)fileName
{
    NSString *filePath = [self getFilePathWithName:fileName];
    
    NSMutableDictionary *dict;
    
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        dict = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
    } else {
        dict = [[NSMutableDictionary alloc] init];
    }
    
    return dict;
}


+ (NSDictionary *)getPreferenceDict
{
    return [self getDictionaryFilePreferenceFile:GlobalPreferenceFileName];
}

+ (NSString *)getFirstLaunchKey
{
    return [NSString stringWithFormat:@"firstLaunch_%@", [self getShortVersionString]];
}

+ (void)saveTestDataArray:(NSArray *)array
{
    NSString *filePath = [self getFilePathWithName:@"testDataArray.plist"];
    [array writeToFile:filePath atomically:YES];
}

+ (NSArray *)loadTestDataArray
{
    NSString *filePath = [self getFilePathWithName:@"testDataArray.plist"];
    NSArray *array;
    
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        array = [NSArray arrayWithContentsOfFile:filePath];
    } else {
        array = [[NSArray alloc] init];
    }
    return array;
}

@end
