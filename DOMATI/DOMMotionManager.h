//
//  DOMMotionManager.h
//  DOMATI
//
//  Created by Jad Osseiran on 2/11/2013.
//  Copyright (c) 2013 Jad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>

typedef void (^DOMMotionProcessCompletionBlock)(NSArray *motions);

@interface DOMMotionManager : CMMotionManager

+ (instancetype)sharedManager;

// NOTE: This is a weird case where I am unsure if the motions
// at the point this method will be called will be the complete
// set of motions associated to a touch. Also this returns a copy
// of the internal mutable array to avoid the array changing once
// it is retrieved.
- (NSArray *)currentDeviceMotions;

- (void)startDeviceMotion:(NSError * __autoreleasing *)error;
- (void)stopDeviceMotion:(DOMMotionProcessCompletionBlock)motionProcessCompletionBlock;

@end
