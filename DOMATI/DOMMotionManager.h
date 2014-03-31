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
 *  Adds to the number of listeners on the manager. If there are
 *  no listeners prior to this call the manager will start the
 *  device motion.
 *
 *  You should ALWAYS balance this call by calling stopListening
 *  the calling object is no longer interested in device motions.
 *  Failure to do so will result in the manager always recording
 *  motion data.
 */
- (void)startListening;
/**
 *  Decrements the number of listeners that the manager keeps track
 *  of. If after calling this methid the manager listener count is
 *  zero then device motions will cease to be recorded until another
 *  object calls startListening.
 */
- (void)stopListening;

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
