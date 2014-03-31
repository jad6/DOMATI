//
//  DOMLocalNotificationHelper.m
//  DOMATI
//
//  Created by Jad Osseiran on 12/02/2014.
//  Copyright (c) 2014 Jad. All rights reserved.
//

#import "DOMLocalNotificationHelper.h"

#import "NSDate+Helper.h"

@implementation DOMLocalNotificationHelper

+ (void)schedualLocalNotification
{
    // Ensure that there is only ever one local notification.
    [DOMLocalNotificationHelper reset];

    NSDate * threeDaysFromNow = [[NSDate date] dateByAddingNumberOfDays:3];
    threeDaysFromNow = [threeDaysFromNow dayWithHour:11 minute:0 second:0];

    UILocalNotification * localNotif = [[UILocalNotification alloc] init];
    localNotif.fireDate = threeDaysFromNow;
    localNotif.timeZone = [NSTimeZone defaultTimeZone];

    localNotif.alertBody = @"Time to record a new touch set";
    localNotif.alertAction = @"Calibrate";

    localNotif.soundName = UILocalNotificationDefaultSoundName;
    localNotif.applicationIconBadgeNumber = 1;

    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
}

+ (void)handleLaunchLocalNotification:(UILocalNotification *)localNotification
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];

    [defaults setObject:@(localNotification != nil) forKey:DEFAULTS_SKIP_TO_CALI];
    [defaults synchronize];
}

+ (BOOL)didOpenFromLocalNotification
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:DEFAULTS_SKIP_TO_CALI] boolValue];
}

+ (void)reset
{
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;

    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@(NO) forKey:DEFAULTS_SKIP_TO_CALI];
    [defaults synchronize];

    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

@end
