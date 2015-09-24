//
//  DOMStrengthGestureRecognizer.m
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

#import <UIKit/UIGestureRecognizerSubclass.h>

#import "DOMStrengthGestureRecognizer.h"

#import "NSObject+Extensions.h"
#import "UITouch+Extension.h"

#import "DOMErrors.h"

static NSString *kTouchInfoPhaseKey = @"phase";
static NSString *kTouchInfoTimestampKey = @"timestamp";
static NSString *kTouchInfoRadiusKey = @"radius";
static NSString *kTouchInfoXKey = @"x";
static NSString *kTouchInfoYKey = @"y";

static CGFloat const kAccLowerSoft = 0.0;
static CGFloat const kAccLowerNormal = 0.0525;
static CGFloat const kAccUpperNormal = 0.1505;
static CGFloat const kAccUpperHard = 1.0;

static CGFloat const kRotLowerSoft = 0.0;
static CGFloat const kRotLowerNormal = 0.1585;
static CGFloat const kRotUpperNormal = 0.458;
static CGFloat const kRotUpperHard = 1.0;

static NSTimeInterval const kMaxAcceptableDuration = 1.2;

@interface DOMStrengthGestureRecognizer () {
    /// The queue running on a different thread to process the data.
    dispatch_queue_t dataProcessingQueue;
}

@property (nonatomic, strong) DOMPassiveMotionManager *motionManager;

@property (nonatomic, strong) NSMutableDictionary *touchesInfo;
@property (nonatomic, strong) NSMutableDictionary *allPhasesTouchesInfo;
@property (nonatomic, strong) NSMutableDictionary *motionsInfo;
@property (nonatomic, strong) NSMutableDictionary *motionItems;

@property (nonatomic) CGFloat strength;

@end

@implementation DOMStrengthGestureRecognizer

- (instancetype)initWithTarget:(id)target
                        action:(SEL)action
                 motionManager:(DOMPassiveMotionManager *)motionManager
                         error:(NSError *__autoreleasing *)error {
    self = [super initWithTarget:target action:action];
    if (self) {
        self.automaticallyResetDataBuffers = YES;

        // Create the serial queue to ensure FIFS
        self->dataProcessingQueue = dispatch_queue_create("data_processing_queue", DISPATCH_QUEUE_SERIAL);
        dispatch_sync(self->dataProcessingQueue, ^{
          // Initialise storing objects on the dataProcessingQueue
          self.touchesInfo = [[NSMutableDictionary alloc] init];
          self.allPhasesTouchesInfo = [[NSMutableDictionary alloc] init];
          self.motionsInfo = [[NSMutableDictionary alloc] init];
          self.motionItems = [[NSMutableDictionary alloc] init];
        });

        [motionManager startListening:error];
        self.motionManager = motionManager;
    }
    return self;
}

- (instancetype)initWithTarget:(id)target action:(SEL)action {
    NSError *error = nil;
    self = [self initWithTarget:target
                         action:action
                  motionManager:[[DOMPassiveMotionManager alloc] init]
                          error:nil];

    if (error) {
        [error handle];
    }

    return self;
}

- (instancetype)init {
    return [self initWithTarget:nil action:nil];
}

- (void)dealloc {
    // Stop recording the device motions when the gesture
    // recogniser is dealloced.
    [self.motionManager stopListening];
}

#pragma mark - Logic

- (void)resetDataBufferForTouch:(UITouch *)touch {
    NSString *pointerKey = [touch pointerString];

    [self.motionsInfo removeObjectForKey:pointerKey];
    [self.touchesInfo removeObjectForKey:pointerKey];
    [self.allPhasesTouchesInfo removeObjectForKey:pointerKey];
}

- (void)resetMotionCache {
    [self.motionManager resetDataStructureIfPossible];
}

- (NSDictionary *)touchesInfoForTouch:(UITouch *)touch {
    NSString *pointerKey = [touch pointerString];

    __block NSDictionary *touchesInfo = nil;

    dispatch_barrier_sync(self->dataProcessingQueue, ^{
      touchesInfo = self.touchesInfo[pointerKey];
    });

    return touchesInfo;
}

- (NSDictionary *)motionsInfoForTouch:(UITouch *)touch {
    NSString *pointerKey = [touch pointerString];

    __block NSDictionary *motionsInfo = nil;

    dispatch_barrier_sync(self->dataProcessingQueue, ^{
      motionsInfo = self.motionsInfo[pointerKey];
    });

    return motionsInfo;
}

/**
 *  Gets the location of the touch in relation to the whole screen.
 *
 *  @param touch The touch who's location to grab.
 *  @param view  The view in which the touch has been made.
 *
 *  @return The point of the touch in relation to the whole screen.
 */
- (CGPoint)locationOfTouch:(UITouch *)touch onScreenForView:(UIView *)view {
    CGPoint location = [touch locationInView:self.view];
    CGPoint viewOrigin = view.frame.origin;

    return CGPointMake(viewOrigin.x + location.x, viewOrigin.y + location.y);
}

- (CGFloat)normalisedValueFromValue:(CGFloat)value
                         boundaries:(NSArray *)boundaries {
    NSSortDescriptor *sortOrder = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES];
    boundaries = [boundaries sortedArrayUsingDescriptors:@[ sortOrder ]];

    NSUInteger numBoundaries = [boundaries count];
    if (numBoundaries <= 2)
        return value;

    CGFloat minBoundary = TO_CGFLOAT([boundaries firstObject]);
    CGFloat maxBoundary = TO_CGFLOAT([boundaries lastObject]);
    CGFloat sizeFactor = maxBoundary / (float)(numBoundaries - 1);

    if (value < minBoundary)
        return minBoundary;
    if (value > maxBoundary)
        return maxBoundary;

    CGFloat normalisedValue = 0.0f;
    for (NSInteger i = 1; i < numBoundaries; i++) {
        CGFloat upperBoundary = TO_CGFLOAT(boundaries[i]);
        CGFloat lowerBoundary = TO_CGFLOAT(boundaries[i - 1]);
        if (value > lowerBoundary && value <= upperBoundary) {
            normalisedValue = ((i - 1) * sizeFactor) + ((value / upperBoundary) * sizeFactor);
            break;
        }
    }

    return normalisedValue;
}

- (CGFloat)strengthForTouch:(UITouch *)touch {
    __block CGFloat strength = 0.0;

    dispatch_sync(self->dataProcessingQueue, ^{
      NSString *pointerKey = [touch pointerString];

      CGFloat duration = TO_CGFLOAT(self.touchesInfo[pointerKey][kTouchInfoDurationKey]);
      if (duration > kMaxAcceptableDuration) {
          strength = -1.5;
      } else {
          CGFloat avgAcceleration = TO_CGFLOAT(self.motionsInfo[pointerKey][kMotionInfoAvgAccelerationKey]);
          NSArray *accelerationBoundries = @[ @(kAccLowerSoft), @(kAccLowerNormal), @(kAccUpperNormal), @(kAccUpperHard) ];
          CGFloat acceleration = [self normalisedValueFromValue:avgAcceleration boundaries:accelerationBoundries];

          CGFloat avgRotation = TO_CGFLOAT(self.motionsInfo[pointerKey][kMotionInfoAvgRotationKey]);
          NSArray *rotationBoundaries = @[ @(kRotLowerSoft), @(kRotLowerNormal), @(kRotUpperNormal), @(kRotUpperHard) ];
          CGFloat rotation = [self normalisedValueFromValue:avgRotation boundaries:rotationBoundaries];

          strength = (rotation + acceleration) / 2.0;
      }
    });

    return strength;
}

#pragma mark - Storing & Processing

- (void)processTouchesInfo:(NSSet *)touches {
    dispatch_sync(self->dataProcessingQueue, ^{
      for (UITouch *touch in touches) {
          NSString *pointerKey = [touch pointerString];

          NSArray *touchAllPhasesInfo = self.allPhasesTouchesInfo[pointerKey];
          // Need the start and end times to calculate duration
          NSTimeInterval startTimestamp = 0.0;
          NSTimeInterval endTimestamp = 0.0;

          // Used to calculate the x & y deltas.
          CGFloat startX = 0.0;
          CGFloat endX = 0.0;
          CGFloat startY = 0.0;
          CGFloat endY = 0.0;

          // Variable to store the maximum radius found for the touch.
          CGFloat maxRadius = (CGFLOAT_IS_DOUBLE) ? DBL_MIN : FLT_MIN;

          // Enumerate through each of the touch's phase info.
          for (NSDictionary *touchPhaseInfo in touchAllPhasesInfo) {
              // Save the start variables on UITouchPhaseBegan and the end
              // variables on UITouchPhaseEnded.
              if ([touchPhaseInfo[kTouchInfoPhaseKey] integerValue] == UITouchPhaseBegan) {
                  startTimestamp = [touchPhaseInfo[kTouchInfoTimestampKey] doubleValue];

                  startX = TO_CGFLOAT(touchPhaseInfo[kTouchInfoXKey]);
                  startY = TO_CGFLOAT(touchPhaseInfo[kTouchInfoYKey]);
              } else if ([touchPhaseInfo[kTouchInfoPhaseKey] integerValue] == UITouchPhaseEnded) {
                  endTimestamp = [touchPhaseInfo[kTouchInfoTimestampKey] doubleValue];

                  endX = TO_CGFLOAT(touchPhaseInfo[kTouchInfoXKey]);
                  endY = TO_CGFLOAT(touchPhaseInfo[kTouchInfoYKey]);
              }

              // Get the current touch radius.
              CGFloat radius = TO_CGFLOAT(touchPhaseInfo[kTouchInfoRadiusKey]);
              // Save it if it is the new maximum.
              if (radius > maxRadius) {
                  maxRadius = radius;
              }
          }

          NSDictionary *touchInfo = @{ kTouchInfoAllPhasesKey : touchAllPhasesInfo,
                                       kTouchInfoDeltaXKey : @(ABS(endX - startX)),
                                       kTouchInfoDeltaYKey : @(ABS(endY - startY)),
                                       kTouchInfoMaxRadiusKey : @(maxRadius),
                                       kTouchInfoDurationKey : @(endTimestamp - startTimestamp) };

          self.touchesInfo[pointerKey] = touchInfo;
      }
    });
}

/**
 *  Helper method to store the touches' touch and motion data.
 *
 *  @param touches The touches who's data we want to store.
 */
- (void)storeTouchesInfo:(NSSet *)touches {
    // Make sure we are processing the data on a different queue.
    dispatch_sync(self->dataProcessingQueue, ^{
      for (UITouch *touch in touches) {
          NSString *pointerKey = [touch pointerString];

          // Get the tail for the linked list on touches began.
          if (touch.phase == UITouchPhaseBegan) {
              self.motionItems[pointerKey] = [self.motionManager lastMotionItemWithTouchPhase:UITouchPhaseBegan];
          }

          // Retreive the touch location on the scren.
          CGPoint touchLocation = [self locationOfTouch:touch onScreenForView:self.view];

          // Store all the relevant touch info in a dictionary.
          NSDictionary *touchInfo = @{ kTouchInfoTimestampKey : @(touch.timestamp),
                                       kTouchInfoXKey : @(touchLocation.x),
                                       kTouchInfoYKey : @(touchLocation.y),
                                       kTouchInfoPhaseKey : @(touch.phase),
                                       kTouchInfoRadiusKey : @([touch radius]) };

          // Get the existing touch info for possible other states.
          NSMutableArray *touchAllPhasesInfo = self.allPhasesTouchesInfo[pointerKey];
          // If there are no other touch info states stored create
          // an array to hold them.
          if (!touchAllPhasesInfo) {
              touchAllPhasesInfo = [[NSMutableArray alloc] init];
          }
          // Store the new touch info.
          [touchAllPhasesInfo addObject:touchInfo];

          // Store the touch info phases in the overall dictionary.
          self.allPhasesTouchesInfo[pointerKey] = touchAllPhasesInfo;
      }
    });
}

- (void)storeAndProcessMotionsInfo:(NSSet *)touches {
    // We are about to do somewhat intensive work, let's keep that away form the main queue.
    dispatch_sync(self->dataProcessingQueue, ^{
      for (UITouch *touch in touches) {
          NSString *pointerKey = [touch pointerString];

          // The head of the linked list is the item stored when
          // the touch was in its UITouchPhaseBegan phase.
          DOMMotionItem *headMotionItem = self.motionItems[pointerKey];
          // Set a new pointer to enumerate with.
          DOMMotionItem *currentMotionItem = headMotionItem;
          // Get the new tail from the linked list.
          DOMMotionItem *tailMotionItem = [self.motionManager lastMotionItemWithTouchPhase:UITouchPhaseEnded];

          // We have a stored scope reference to the head of the
          // linked list, therefore we can remove it from our
          // class collection.
          [self.motionItems removeObjectForKey:pointerKey];

          // Variables which will be used to calculate raw motion
          // data attributes.
          double totalAcceleration = 0.0;
          double totalRotation = 0.0;

          // Allocate array to store the touch's motions.
          NSMutableArray *motions = [[NSMutableArray alloc] init];
          while (currentMotionItem != tailMotionItem) {
              CMDeviceMotion *motion = currentMotionItem.deviceMotion;
              [motions addObject:motion];

              // Good old pythagorus to get an abstract measure of
              // the combined acceleration on the device.
              CMAcceleration acc = motion.userAcceleration;
              totalAcceleration += sqrt(acc.x * acc.x + acc.y * acc.y + acc.z * acc.z);

              // Using pythagorus on rotation values gives a
              // scalar value which can be used to determine the
              // level of rotation of a touch.
              CMRotationRate rot = motion.rotationRate;
              totalRotation += sqrt(rot.x * rot.x + rot.y * rot.y + rot.z * rot.z);

              // Iterate the pointer to the next linked list item.
              currentMotionItem = [currentMotionItem nextObject];
          }

          // Work out the averages for the acceleration and rotation.
          NSUInteger motionsCount = [motions count];
          CGFloat avgAcceleration = (totalAcceleration / (motionsCount * 1.0));
          CGFloat avgRotation = (totalRotation / (motionsCount * 1.0));

          // Save the values in a dictionary for future possible reference.
          self.motionsInfo[[touch pointerString]] = @{ kMotionInfoMotionsKey : motions,
                                                       kMotionInfoAvgAccelerationKey : @(avgAcceleration),
                                                       kMotionInfoAvgRotationKey : @(avgRotation) };
      }
    });
}

#pragma mark - Touches

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];

    [self storeTouchesInfo:touches];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];

    [self storeTouchesInfo:touches];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];

    [self storeTouchesInfo:touches];
    [self processTouchesInfo:touches];
    [self storeAndProcessMotionsInfo:touches];

    // The touch has ended and reset the linked list if the motion
    // manager is not using for anything else.
    [self.motionManager resetDataStructureIfPossible];

    self.strength = [self strengthForTouch:[touches anyObject]];

    if (self.automaticallyResetDataBuffers) {
        for (UITouch *touch in touches) {
            [self resetDataBufferForTouch:touch];
        }
    }

    // Set the gesture recogniser to a recognised state.
    if (self.state == UIGestureRecognizerStatePossible) {
        self.state = (self.strength == -1.0) ? UIGestureRecognizerStateFailed : UIGestureRecognizerStateRecognized;
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];

    self.state = UIGestureRecognizerStateFailed;
}

- (void)reset {
    [super reset];
}

@end
