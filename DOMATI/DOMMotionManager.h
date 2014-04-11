//
//  DOMMotionManager.h
//  DOMATI
//
//  Created by Jad Osseiran on 2/11/2013.
//  Copyright (c) 2013 Jad. All rights reserved.
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
