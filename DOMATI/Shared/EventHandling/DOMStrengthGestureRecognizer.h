//
//  DOMStrengthGestureRecognizer.h
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

@import UIKit;
@import CoreMotion.CMDeviceMotion;

#import "DOMPassiveMotionManager.h"

// Touch info dictionary keys.
static NSString *kTouchInfoAllPhasesKey = @"allPhasesTouchInfo";
static NSString *kTouchInfoMaxRadiusKey = @"maxRadius";
static NSString *kTouchInfoDeltaYKey = @"deltaY";
static NSString *kTouchInfoDeltaXKey = @"deltaX";
static NSString *kTouchInfoDurationKey = @"duration";
// Motion info dictionary keys.
static NSString *kMotionInfoMotionsKey = @"motions";
static NSString *kMotionInfoAvgAccelerationKey = @"accelerationAvg";
static NSString *kMotionInfoAvgRotationKey = @"rotationAvg";

@interface DOMStrengthGestureRecognizer : UIGestureRecognizer

/// The strength of the touch(es). This value is ranged from 0.0 to 1.0.
///
/// [0.0, 0.33] is a soft touch.
///
/// (0.33, 0.66] is a normal touch.
///
/// (0.66, 1.0] is a hard touch.
@property (nonatomic, readonly) CGFloat strength;

/// Setting this flag to no will mean that the subclass is responsible
/// for clearing the buffer data associated with a touch.
///
/// By default this property is YES and clears at the end of
/// touchesEnded:withEvents:.
@property (nonatomic) BOOL automaticallyResetDataBuffers;

- (instancetype)initWithTarget:(id)target
                        action:(SEL)action
                 motionManager:(DOMPassiveMotionManager *)motionManager
                         error:(NSError *__autoreleasing *)error;

- (NSDictionary *)touchesInfoForTouch:(UITouch *)touch;
/**
 *  Returns a dictionary with 3 elements: an array of CMDeviceMotion
 *  objects which can be accessed via kMotionInfoMotionsKey, the
 *  average acceleration accessed via kMotionInfoAvgAccelerationKey,
 *  and the average rotation accessed via kMotionInfoAvgRotationKey.
 *
 *  @param touch The touch who's information is requested.
 *
 *  @return return The dictionary containing the motions info.
 */
- (NSDictionary *)motionsInfoForTouch:(UITouch *)touch;

- (void)resetDataBufferForTouch:(UITouch *)touch;

/**
 *  Resets the linked list in the motion manager in an attempt to
 *  free memory.
 */
- (void)resetMotionCache;

@end
