//
//  DOMLocalNotificationHelper.m
//  DOMATI
//
//  Created by Jad Osseiran on 12/02/2014.
//  Copyright (c) 2014 Jad. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  Redistributions of source code must retain the above copyright notice, this
//  list of conditions and the following disclaimer. Redistributions in binary
//  form must reproduce the above copyright notice, this list of conditions and
//  the following disclaimer in the documentation and/or other materials
//  provided with the distribution. Neither the name of the nor the names of
//  its contributors may be used to endorse or promote products derived from
//  this software without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
//  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
//  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
//  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
//  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
//  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
//  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
//  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
//  POSSIBILITY OF SUCH DAMAGE.

#import "DOMLocalNotificationHelper.h"

#import "NSDate+Helper.h"

@implementation DOMLocalNotificationHelper

+ (void)schedualLocalNotification {
    // Ensure that there is only ever one local notification.
    [DOMLocalNotificationHelper reset];

    NSDate *threeDaysFromNow = [[NSDate date] dateByAddingNumberOfDays:3];
    threeDaysFromNow = [threeDaysFromNow dayWithHour:11 minute:0 second:0];

    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    localNotif.fireDate = threeDaysFromNow;
    localNotif.timeZone = [NSTimeZone defaultTimeZone];

    localNotif.alertBody = @"Time to record a new touch set";
    localNotif.alertAction = @"Calibrate";

    localNotif.soundName = UILocalNotificationDefaultSoundName;
    localNotif.applicationIconBadgeNumber = 1;

    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
}

+ (void)handleLaunchLocalNotification:(UILocalNotification *)localNotification {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    [defaults setObject:@(localNotification != nil) forKey:DEFAULTS_SKIP_TO_CALI];
    [defaults synchronize];
}

+ (BOOL)didOpenFromLocalNotification {
    return [[[NSUserDefaults standardUserDefaults] objectForKey:DEFAULTS_SKIP_TO_CALI] boolValue];
}

+ (void)reset {
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@(NO) forKey:DEFAULTS_SKIP_TO_CALI];
    [defaults synchronize];

    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

@end
