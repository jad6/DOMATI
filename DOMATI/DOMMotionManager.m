//
//  DOMMotionManager.m
//  DOMATI
//
//  Created by Jad Osseiran on 2/11/2013.
//  Copyright (c) 2013 Jad. All rights reserved.
//

#import "DOMMotionManager.h"

#import "DOMErrors.h"

@interface DOMMotionManager () {
    dispatch_queue_t listQueue;
}

@property (nonatomic, strong) DOMMotionItem *headMotionItem, *tailMotionItem;

@property (nonatomic) NSInteger numActiveTouches;

@end

// 100 Hz update interval.
static NSTimeInterval kUpdateInterval = 1/100.0;

@implementation DOMMotionManager

+ (instancetype)sharedManager
{
    static __DISPATCH_ONCE__ DOMMotionManager *singletonObject = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singletonObject = [[self alloc] init];
        singletonObject->listQueue = dispatch_queue_create("list_queue", DISPATCH_QUEUE_SERIAL);
    });
    
    return singletonObject;
}

- (BOOL)resetLinkedListIfPossible
{
    __block BOOL didReset = NO;
    dispatch_sync(self->listQueue, ^{
        if (self.numActiveTouches == 0) {
            self.headMotionItem = self.tailMotionItem;
            didReset = YES;
        }
    });
    
    return didReset;
}

- (void)startDeviceMotion:(NSError * __autoreleasing *)error
{
    // Do nothing if the motion sensors are already turned on.
    if ([self isDeviceMotionActive]) {
        return;
    }
    
    // Do not attempt to turn on the sensors if the device does not have
    // them enabled or available.
    if (![self isDeviceMotionAvailable]) {
        // Populate the error to alert the user.
        *error = [DOMErrors noDeviceMotionError];
        return;
    }
    
    // Set up the variables to be used.
    self.deviceMotionUpdateInterval = kUpdateInterval;
    
    // Observe the operation queue with KVO to be alerted when it is empty.
    NSOperationQueue *deviceMotionQueue = [[NSOperationQueue alloc] init];
    // Start the device motion update.
    [self startDeviceMotionUpdatesToQueue:deviceMotionQueue
                              withHandler:^(CMDeviceMotion *motion, NSError *error) {
                                  if (!error) {
                                      [self enqueueDeviceMotion:motion];
                                  } else {
                                      // Something has gone wrong, log the error and stop the sensors.
                                      [error handle];
                                      [self stopDeviceMotion];
                                  }
                              }];
}

- (void)stopDeviceMotion
{
    // Only stop the sensors if they were already active.
    if ([self isDeviceMotionActive]) {
        [self stopDeviceMotionUpdates];
        
        [self resetLinkedListIfPossible];
    }
}

#pragma mark - Linked List

- (void)enqueueDeviceMotion:(CMDeviceMotion *)deviceMotion
{
    dispatch_sync(self->listQueue, ^{
        DOMMotionItem *motionItem = [[DOMMotionItem alloc] initWithDeviceMotion:deviceMotion];
        
        if (!self.headMotionItem) {
            self.headMotionItem = motionItem;
            self.tailMotionItem = motionItem;
        } else {
            self.tailMotionItem = [self.tailMotionItem insertObjectAfter:motionItem];
        }
    });
}

- (DOMMotionItem *)lastMotionItemWithTouchPhase:(UITouchPhase)phase;
{
    __block DOMMotionItem *motionItem = nil;
    dispatch_barrier_sync(self->listQueue, ^{
        if (phase == UITouchPhaseEnded) {
            self.numActiveTouches--;
        } else if (phase == UITouchPhaseBegan) {
            self.numActiveTouches++;
        }
        
        motionItem = self.tailMotionItem;
    });
    return motionItem;
}

- (DOMMotionItem *)lastMotionItem
{
    return [self lastMotionItemWithTouchPhase:UITouchPhaseCancelled];
}


@end
