//
//  DOMMotionManager.m
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

#import "DOMMotionManager.h"

#import "DOMErrors.h"

@interface DOMMotionManager ()
{
    NSError *__autoreleasing *startingError;
}

@end

/// 100 Hz update interval.
static NSTimeInterval kUpdateInterval = 1 / 100.0;

@implementation DOMMotionManager

- (void)dealloc
{
    
}

- (void)setNumListeners:(NSInteger)numListeners
{
    if (self->_numListeners != numListeners)
    {
        NSInteger previousNumListeners = self->_numListeners;
        self->_numListeners = numListeners;
        
        // If the new value for the number of listeners is zero stop
        // recording the device motions. However if the listener added
        //  is brings the count from 0 to 1 then start the sensors.
        if (numListeners == 0)
        {
            [self stopDeviceMotion];
        }
        else if (numListeners == 1 && previousNumListeners == 0)
        {
            // Turn on the motion sensing if possible.
            if (![self isDeviceMotionActive])
            {
                [self startDeviceMotion:self->startingError];
            }
        }
    }
}

#pragma mark - Abstract Methods

- (void)handleMotionObjectUpdate:(CMDeviceMotion *)deviceMotion
{
    
}

- (BOOL)resetDataStructureIfPossible
{
    return NO;
}

#pragma mark - Logic

- (BOOL)startListening:(NSError *__autoreleasing *)error
{
    self->startingError = error;
    
    self.numListeners++;
    
    return self->startingError != nil;
}

- (void)stopListening
{
    self.numListeners--;
}

/**
 *  Start the motion sensors of the device.
 *
 *  @param error The error which may occur when starting the sensors.
 *  @return True if the motion sensors were usccessfully turned on.
 */
- (BOOL)startDeviceMotion:(NSError *__autoreleasing *)error
{
    // Do nothing if the motion sensors are already turned on.
    if ([self isDeviceMotionActive])
    {
        return NO;
    }

    // Do not attempt to turn on the sensors if the device does not
    // have them enabled or available.
    if (![self isDeviceMotionAvailable])
    {
        // Populate the error to alert the user.
        if (error)
        {
            *error = [DOMErrors noDeviceMotionError];
        }
        return NO;
    }

    // Set up the variables to be used.
    self.deviceMotionUpdateInterval = kUpdateInterval;

    // Observe the operation queue with KVO to be alerted when it is empty.
    NSOperationQueue *deviceMotionQueue = [[NSOperationQueue alloc] init];
    // Start the device motion update.
    [self startDeviceMotionUpdatesToQueue:deviceMotionQueue
                              withHandler:^(CMDeviceMotion *motion, NSError *error) {
         if (!error)
         {
             [self handleMotionObjectUpdate:motion];
         }
         else
         {
             // Something has gone wrong, log
             // the error and stop the sensors.
             [error handle];
             [self stopDeviceMotion];
         }
     }];

    return YES;
}

/**
 *  Stop updating the device's motion.
 */
- (void)stopDeviceMotion
{
    // Only stop the sensors if they were already active and no
    // other classes are using the manager.
    if ([self isDeviceMotionActive] &&
        self.numListeners == 0 &&
        self.numActivities == 0)
    {
        [self stopDeviceMotionUpdates];
        
        [self resetDataStructureIfPossible];
    }
}

@end
