//
//  AppDelegate.m
//  Hop Hero
//
//  Created by enterpi on 9/10/14.
//  Copyright (c) 2014 enterpi. All rights reserved.
//

#import "AppDelegate.h"
#import <SpriteKit/SpriteKit.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    SKView *view = (SKView *)self.window.rootViewController.view;
    view.paused = YES;
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
     SKView *view = (SKView *)self.window.rootViewController.view;
    view.paused = NO;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
