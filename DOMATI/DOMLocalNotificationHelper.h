//
//  DOMLocalNotificationHelper.h
//  DOMATI
//
//  Created by Jad Osseiran on 12/02/2014.
//  Copyright (c) 2014 Jad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DOMLocalNotificationHelper : NSObject

+ (void)schedualLocalNotification;
+ (void)handleLaunchLocalNotification:(UILocalNotification *)localNotification;

+ (BOOL)didOpenFromLocalNotification;

+ (void)reset;

@end
