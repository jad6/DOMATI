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

- (NSArray *)currentDeviceMotions;

- (void)startDeviceMotion:(NSError * __autoreleasing *)error;
- (void)stopDeviceMotion;
- (void)stopDeviceMotionWithMotionProcessCompletion:(DOMMotionProcessCompletionBlock)motionProcessCompletionBlock;

@end
