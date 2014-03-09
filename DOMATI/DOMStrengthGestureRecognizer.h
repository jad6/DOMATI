//
//  DOMStrengthGestureRecognizer.h
//  DOMATI
//
//  Created by Jad Osseiran on 2/11/2013.
//  Copyright (c) 2013 Jad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CMDeviceMotion.h>

// Touch info dictionary keys.
static NSString *kTouchInfoPhaseKey = @"phase";
static NSString *kTouchInfoTimestampKey = @"timestamp";
static NSString *kTouchInfoRadiusKey = @"radius";
static NSString *kTouchInfoXKey = @"x";
static NSString *kTouchInfoYKey = @"y";
// Motion info dictionary keys.
static NSString *kMotionInfoMotionsKey = @"motions";
static NSString *kMotionInfoAvgAccelerationKey = @"accelerationAvg";
static NSString *kMotionInfoAvgRotationKey = @"rotationAvg";

@interface DOMStrengthGestureRecognizer : UIGestureRecognizer

// The strength of the touch(es).
@property (nonatomic, readonly) CGFloat strength;

/**
 *  Returns an array of dictionaries each 
 *  contianing information on a particular touch
 *  throughot its phases. For example a quick tap will return an 
 *  array with 2 elements, one for UITouchPhaseBegan and one for
 *  UITouchPhaseEnded. In contrast a moving touch will contain more 
 *  elements with the addition of UITouchPhaseMoved phases.
 *
 *  @param touch The touch who's information is requested.
 *
 *  @return return The array containing the touch's info.
 */
- (NSArray *)allPhasesInfoForTouch:(UITouch *)touch;
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

/**
 *  Resets the linked list in the motion manager in an attempt to
 *  free memory.
 */
- (void)resetMotionCache;

@end
