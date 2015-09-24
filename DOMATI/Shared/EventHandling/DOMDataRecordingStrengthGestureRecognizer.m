//
//  DOMDataRecordingStrengthGestureRecognizer.m
//  DOMATI
//
//  Created by Jad Osseiran on 27/02/2014.
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

@import UIKit.UIGestureRecognizerSubclass;

#import "DOMDataRecordingStrengthGestureRecognizer.h"

#import "DOMCalibrationViewController.h"

#import "DOMCoreDataManager.h"
#import "DOMTouchData+Extension.h"
#import "DOMRawMotionData+Extensions.h"
#import "DOMRawTouchData+Extensions.h"

@interface DOMDataRecordingStrengthGestureRecognizer ()

@property (nonatomic, copy) DOMCoreDataSave saveDataCompletionBlock;

@property (nonatomic) BOOL saving;
/// Variable to keep track of the number of Core Data saves. When this value reaches 0, saving is set to NO. YES otherwise.
@property (nonatomic) NSInteger numberOfCoreDataSaves;
/// The current touch strength being recorded if there is one.
@property (nonatomic) DOMCalibrationState currentState;

@end

@implementation DOMDataRecordingStrengthGestureRecognizer

- (instancetype)initWithTarget:(id)target
                        action:(SEL)action
                         error:(NSError *__autoreleasing *)error
                 motionManager:(DOMPassiveMotionManager *)motionManager {
    self = [super initWithTarget:target
                          action:action
                   motionManager:motionManager
                           error:error];
    if (self) {
        self.currentState = DOMCalibrationStateNone;
        // Listen to the changes of claibration strengths.
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changedState:) name:kCalibrationStateChangeNotificationName object:nil];

        self.automaticallyResetDataBuffers = NO;
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setNumberOfCoreDataSaves:(NSInteger)numberOfCoreDataSaves {
    if (self->_numberOfCoreDataSaves != numberOfCoreDataSaves) {
        self->_numberOfCoreDataSaves = numberOfCoreDataSaves;

        self.saving = (numberOfCoreDataSaves != 0);
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    // Must call this first to populate allPhasesInfoForTouch: &
    // motionsInfoForTouch:
    [super touchesEnded:touches withEvent:event];

    // Create a dispatch group to make sure we only call the
    // completion block once all object have been saved.
    dispatch_group_t savingGroup = dispatch_group_create();

    // Create a new ManagedObjectContext for multi threading core data operations.
    NSManagedObjectContext *threadContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    threadContext.parentContext = [DOMCoreDataManager sharedManager].managedContext;

    for (UITouch *touch in touches) {
        // Get the information from the super class.
        NSDictionary *touchesInfo = [[self touchesInfoForTouch:touch] copy];
        NSDictionary *motionsInfo = [[self motionsInfoForTouch:touch] copy];

        // Increment the number of saves as we are about to do one.
        self.numberOfCoreDataSaves++;
        // Enter the blcok prior to the save.
        dispatch_group_enter(savingGroup);

        [threadContext performBlock:^{
          // Create and set the touch data objects along with
          // its relationships.
          [DOMTouchData touchData:^(DOMTouchData *touchData) {
            [self setDeviceMotionsInfo:motionsInfo
                           onTouchData:touchData
                             inContext:threadContext];
            [self setTouchInfo:touchesInfo
                   onTouchData:touchData
                     inContext:threadContext];
          } inContext:threadContext];

          // Save the thread contexts
          [[DOMCoreDataManager sharedManager] saveContext:threadContext];

          // We finished saving, decrement that operation.
          self.numberOfCoreDataSaves--;
          // Leave the group.
          dispatch_group_leave(savingGroup);
        }];
    }

    for (UITouch *touch in touches) {
        [self resetDataBufferForTouch:touch];
    }

    // All the saves have completed, call the saving block on
    // the main queue.
    dispatch_group_notify(savingGroup, dispatch_get_main_queue(), ^{

      if (self.saveDataCompletionBlock) {
          self.saveDataCompletionBlock();
      }
    });
}

/**
 *  Calculates the touch data attributes which are given from the
 *  touches info form all its phases.
 *
 *  @param touchInfo          A touch's info.
 *  @param touchData          The touch data on which to save data on.
 *  @param context            The context in which to save the data.
 */
- (void)setTouchInfo:(NSDictionary *)touchInfo
         onTouchData:(DOMTouchData *)touchData
           inContext:(NSManagedObjectContext *)context {
    NSArray *touchAllPhasesInfo = touchInfo[kTouchInfoAllPhasesKey];
    // Enumerate through each of the touch's phase info.
    for (NSDictionary *touchPhaseInfo in touchAllPhasesInfo) {
        // Create a raw touch data object in the context from
        // the touch info.
        DOMRawTouchData *rawData = [DOMRawTouchData rawTouchDataInContext:context fromTouchInfo:touchPhaseInfo];
        // Set the relationship between touchData & rawData.
        [touchData addRawTouchDataObject:rawData];
    }

    // Set the calculated variables to the touch data object.
    touchData.xDetla = touchInfo[kTouchInfoDeltaXKey];
    touchData.yDelta = touchInfo[kTouchInfoDeltaYKey];
    touchData.maxRadius = touchInfo[kTouchInfoMaxRadiusKey];
    touchData.duration = touchInfo[kTouchInfoDurationKey];
#if DATA_GATHERING
    touchData.calibrationStrength = @(self.currentState);
#endif
}

/**
 *  Gets the saved motion data for a touch and saves them on a
 *  DOMTouchData object.
 *
 *  @param motionsInfo The motion data picked up by the device.
 *  @param touchData   The touch data on which to save data on.
 *  @param context     The context in which to save the data.
 */
- (void)setDeviceMotionsInfo:(NSDictionary *)motionsInfo
                 onTouchData:(DOMTouchData *)touchData
                   inContext:(NSManagedObjectContext *)context {
    // Enumerate through each motion and save them as
    // DOMRawMotionData object.
    for (CMDeviceMotion *motion in motionsInfo[kMotionInfoMotionsKey]) {
        // Create a raw motion data object in the context from
        // the touch info.
        DOMRawMotionData *rawData = [DOMRawMotionData rawMotionDataInContext:context fromDeviceMotion:motion];
        // Set the relationship between touchData & rawData.
        [touchData addRawMotionDataObject:rawData];
    }

    // Set the calculated variables to the touch data object.
    touchData.rotationAvg = motionsInfo[kMotionInfoAvgRotationKey];
    touchData.accelerationAvg = motionsInfo[kMotionInfoAvgAccelerationKey];
}

- (void)setCoreDataSaveCompletionBlock:(DOMCoreDataSave)block {
    self.saveDataCompletionBlock = block;
}

#pragma mark - Notification

/**
 *  Handler method to save the new state change picked up from
 *  a notification.
 *
 *  @param notification The notification which triggered the call.
 */
- (void)changedState:(NSNotification *)notification {
    self.currentState = [[notification userInfo][@"state"] integerValue];
}

@end
