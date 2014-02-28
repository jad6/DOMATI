//
//  DOMMotionManager.h
//  DOMATI
//
//  Created by Jad Osseiran on 2/11/2013.
//  Copyright (c) 2013 Jad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>

#import "DOMMotionItem.h"

@interface DOMMotionManager : CMMotionManager

+ (instancetype)sharedManager;

- (void)startDeviceMotion:(NSError * __autoreleasing *)error;
- (void)stopDeviceMotion;

- (DOMMotionItem *)lastMotionItem;

- (void)resetLinkedList;

@end
