//
//  DOMAppDelegate.m
//  DOMATI
//
//  Created by Jad Osseiran on 10/08/13.
//  Copyright (c) 2013 Jad. All rights reserved.
//

#import "DOMAppDelegate.h"

#import "DOMCoreDataManager.h"
#import "DOMThemeManager.h"
#import "DOMRequestOperationManager.h"

#import "DOMUser.h"

#import "DOMLocalNotificationHelper.h"

@implementation DOMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    self.window.tintColor = DOMATI_COLOR;

    // This is done so that upon launch the User data is pulled from iCloud.
    [DOMUser refreshCurrentUser];

    // Handle the local notifications.
    UILocalNotification * localNotif = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    [DOMLocalNotificationHelper handleLaunchLocalNotification:localNotif];
    // If the badge was showing remove it.
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;

    // Set the appearance of the app.
    [DOMThemeManager customiseAppAppearance];
    // Set up Core Data.
    [[DOMCoreDataManager sharedManager] setupCoreData];

    // Only attempt uploads at launch once the user has been sycned.
    if ([DOMUser currentUser].identifier > 0)
    {
        [[DOMRequestOperationManager sharedManager] uploadDataWhenPossible];
    }

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
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
