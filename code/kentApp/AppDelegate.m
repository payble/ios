//
//  AppDelegate.m
//  kentApp
//
//  Created by pericent on 12/18/14.
//  Copyright (c) 2014 pericent. All rights reserved.
//

#import "AppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>
#import "HomeVC.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize urlString;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    NSString *path=[[NSBundle mainBundle] pathForResource:@"url" ofType:@"plist"];
    NSMutableDictionary *tmpDic=[[NSMutableDictionary alloc]initWithContentsOfFile:path];
    urlString=[[NSString alloc]initWithString:[tmpDic valueForKey:@"url"]];
    
//    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
//    self.window.backgroundColor     =   [UIColor whiteColor];
//    
//    if([[NSUserDefaults standardUserDefaults]objectForKey:@"userdataKey"])
//    {
//        HomeVC *obj    =   [[HomeVC alloc]init];
//        navObj  =   [[UINavigationController alloc]initWithRootViewController:obj];
//    }else{
//        ViewController *obj    =   [[ViewController alloc]init];
//        navObj  =   [[UINavigationController alloc]initWithRootViewController:obj];
//    }
//    
//    
//    
//    
//    
//    
//    [self.window setRootViewController:navObj];
//    
//    [self.window makeKeyAndVisible];

    
    // Override point for customization after application launch.
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
    
    // Logs 'install' and 'app activate' App Events.
    //[FBAppEvents activateApp];
    
    [FBAppCall handleDidBecomeActive];
}


- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    
    return [FBSession.activeSession handleOpenURL:url];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
