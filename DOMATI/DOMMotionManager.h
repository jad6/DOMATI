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

/**
 *  Creates a singleton subclass of CMMotionManager to ensure we are only
 *  ever accessing the one manager accross the program.
 *
 *  @return The singleton object.
 */
+ (instancetype)sharedManager;

/**
 *  Start the motion sensors of the device.
 *
 *  @param error The error which may occur when starting the sensors.
 *  @return True if the motion sensors were usccessfully turned on.
 */
- (BOOL)startDeviceMotion:(NSError * __autoreleasing *)error;
/**
 *  Stop updating the device's motion.
 */
- (void)stopDeviceMotion;

/**
 *  Method which gets the tail of the linked list holding the device motion
 *  updates.
 *
 *  @param phase The phase of the touch when the tail was requested.
 *
 *  @return The tail motion item of the linked list.
 */
- (DOMMotionItem *)lastMotionItemWithTouchPhase:(UITouchPhase)phase;

/**
 *  Method which gets the tail of the linked list holding the device motion
 *  updates.
 *
 *  @return The tail motion item of the linked list.
 */
- (DOMMotionItem *)lastMotionItem;

/**
 *  Reset the linked list freeing up memory. This method will only succeed 
 *  there are no other resources (such as touches) currently using the 
 *  motion linked list.
 *
 *  @return True if the linked list has been reset.
 */
- (BOOL)resetLinkedListIfPossible;

@end
