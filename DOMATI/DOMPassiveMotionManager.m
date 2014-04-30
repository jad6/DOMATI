//  DOMPassiveMotionManager.m
// 
//  Created by Jad on 29/04/2014.
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

#import "DOMPassiveMotionManager.h"

@interface DOMPassiveMotionManager ()
{
    // The backgorund queue for the saving of the motion data.
    dispatch_queue_t listQueue;
}

/// The pointers for the head and tail of the linked list.
@property (nonatomic, strong) DOMMotionItem *headMotionItem, *tailMotionItem;

@end

@implementation DOMPassiveMotionManager

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self->listQueue = dispatch_queue_create("list_queue", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

#pragma mark - Abstract Methods

- (void)handleMotionObjectUpdate:(CMDeviceMotion *)deviceMotion
{
    [self enqueueDeviceMotion:deviceMotion];
}

- (BOOL)resetDataStructureIfPossible
{
    // Free up some memory if you can.
    return [self resetLinkedListIfPossible];
}

#pragma mark - Linked List

- (BOOL)resetLinkedListIfPossible
{
    __block BOOL didReset = NO;
    
    dispatch_sync(self->listQueue, ^{
        // Make sure no activities and listeners are currently using
        // the motion manager.
        if (self.numActivities == 0 && self.numListeners == 0)
        {
            //            self.tailMotionItem = nil;
            //            self.headMotionItem = nil;
            //            self.headMotionItem = self.tailMotionItem;
            didReset = YES;
        }
    });
    
    return didReset;
}

/**
 *  Enqueues the given device motion to the linked list. This method
 *  works on the list queue thead.
 *
 *  @param deviceMotion The motion to enqueue.
 */
- (void)enqueueDeviceMotion:(CMDeviceMotion *)deviceMotion
{
    dispatch_sync(self->listQueue, ^{
        DOMMotionItem *motionItem = [[DOMMotionItem alloc] initWithDeviceMotion:deviceMotion];
        
        if (!self.headMotionItem)
        {
            // Initialise the linked list pointers.
            self.headMotionItem = motionItem;
            self.tailMotionItem = motionItem;
        }
        else
        {
            self.tailMotionItem = [self.tailMotionItem insertObjectAfter:motionItem];
        }
    });
}

- (DOMMotionItem *)lastMotionItemWithTouchPhase:(UITouchPhase)phase;
{
    __block DOMMotionItem *motionItem = nil;
    dispatch_barrier_sync(self->listQueue, ^{
        // Update the activity tracker.
        if (phase == UITouchPhaseEnded)
        {
            self.numActivities--;
        }
        else if (phase == UITouchPhaseBegan)
        {
            self.numActivities++;
        }
        
        motionItem = self.tailMotionItem;
    });
    return motionItem;
}

@end
