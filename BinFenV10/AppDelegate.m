//
//  AppDelegate.m
//  BinFenV10
//
//  Created by Wang Long on 2/1/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import "AppDelegate.h"
#import "defs.h"

#import "BFPreferenceData.h"
#import "AFNetworking.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

+ (AFHTTPSessionManager *)sharedHttpSessionManager
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"URLs" ofType:@"plist"];
    NSArray *urlArray = [NSArray arrayWithContentsOfFile:path];
    NSString *baseURLString = (NSString *)[[urlArray objectAtIndex:0] objectForKey:@"url"];
    //NSString *baseURLString = (NSString *)[[urlArray objectAtIndex:0] objectForKey:@"backup"];
    
    static AFHTTPSessionManager *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:baseURLString]];
        shared.responseSerializer = [AFHTTPResponseSerializer serializer];
        shared.responseSerializer.acceptableContentTypes = [shared.responseSerializer.acceptableContentTypes setByAddingObject:@"html/text"];
    });
    return shared;
}

- (BOOL)detectFirstLaunch
{
    NSString *firstLaunchKey = [BFPreferenceData getFirstLaunchKey];
    BOOL isFirstLaunch = [[NSUserDefaults standardUserDefaults] boolForKey:firstLaunchKey];
    if(isFirstLaunch)
    {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:firstLaunchKey];
        return YES;
    }
    return isFirstLaunch;
}

- (void)clearFirstLaunch
{
    NSString *firstLaunchKey = [BFPreferenceData getFirstLaunchKey];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:firstLaunchKey];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UIViewController *rootViewController;
    
    //[self clearFirstLaunch];
    
    if([self detectFirstLaunch])
    {
        rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"WizardViewController"];
    } else {
        rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"MainTabsViewController"];
    }
    
    /*
    self.window.tintColor = [UIColor colorWithRed:253/255.0f
                                            green:150/255.0f
                                             blue:93/255.0f
                                            alpha:1.0f];
     */
    self.window.rootViewController = rootViewController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
