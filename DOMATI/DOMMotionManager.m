//
//  DOMMotionManager.m
//  DOMATI
//
//  Created by Jad Osseiran on 2/11/2013.
//  Copyright (c) 2013 Jad. All rights reserved.
//

#import "DOMMotionManager.h"

#import "DOMErrors.h"

@interface DOMMotionManager ()

// The completion block which will be called when the motion manager's
// operation queue is completed.
@property (nonatomic, copy) DOMMotionProcessCompletionBlock motionProcessCompletionBlock;
// The stored motion data.
@property (strong, nonatomic) NSMutableArray *motions;

@end

// 60 Hz update interval to match the 60 fps of the display.
static NSTimeInterval kUpdateInterval = 0.06;

@implementation DOMMotionManager

/**
 *  This makes sure we only ever access one istance of the manager.
 *
 *  @return the singleton manager object.
 */
+ (instancetype)sharedManager
{
    static __DISPATCH_ONCE__ id singletonObject = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singletonObject = [[self alloc] init];
    });
    
    return singletonObject;
}

/**
 *  This will get the current state of the motions. Note that it does
 *  not include data which may still be in the operation queue!
 *
 *  @return a copy of the current device motions
 */
- (NSArray *)currentDeviceMotions
{
    return [self.motions copy];
}

/**
 *  Starts the device sensors (both accelerometer and gyroscope).
 *
 *  @param error The error object which will be nil if the operation is successful
 */
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
    self.motions = [[NSMutableArray alloc] init];
    self.deviceMotionUpdateInterval = kUpdateInterval;

    // Observe the operation queue with KVO to be alerted when it is empty.
    NSOperationQueue *queue = [NSOperationQueue currentQueue];
    [queue addObserver:self
            forKeyPath:NSStringFromSelector(@selector(operationCount))
               options:0
               context:NULL];

    // Start the device motion update.
    [self startDeviceMotionUpdatesToQueue:queue withHandler:^(CMDeviceMotion *motion, NSError *error) {
        if (!error) {
            // On every new successful record save the motion data.
            [self.motions addObject:motion];
        } else {
            // Something has gone wrong, log the error and stop the sensors.
            [error handle];
//            [self stopDeviceMotion];
        }
    }];
}

/**
 *  Stops the device sensors (both accelerometer and gyroscope) and
 *  calls a completion block with all the motions from the
 *  operation queue.
 *
 *  @param motionProcessCompletionBlock the block to be called when the operation queue finishes
 */
- (void)stopDeviceMotionWithMotionProcessCompletion:(DOMMotionProcessCompletionBlock)motionProcessCompletionBlock
{
    // Store the given block for later invocation.
    self.motionProcessCompletionBlock = motionProcessCompletionBlock;
    
    [self stopDeviceMotion];
}

/**
 *  Stops the device sensors (both accelerometer and gyroscope).
 */
- (void)stopDeviceMotion
{
    // Only stop the sensors if they were already active.
    if ([self isDeviceMotionActive]) {
        [self stopDeviceMotionUpdates];
    }
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([object isKindOfClass:[NSOperationQueue class]] &&
        [keyPath isEqualToString:NSStringFromSelector(@selector(operationCount))]) {
        if ([object operationCount] == 0) {
            // Call the blcok
            if (self.motionProcessCompletionBlock) {
                self.motionProcessCompletionBlock([self.motions copy]);
            }
        }
    }
}

@end
