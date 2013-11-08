//
//  DOMMotionManager.h
//  DOMATI
//
//  Created by Jad Osseiran on 2/11/2013.
//  Copyright (c) 2013 Jad. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DOMMotionManager;
@class DOMTouchData;

@interface DOMMotionManager : NSObject

+ (instancetype)sharedManager;

- (void)startDeviceMotion:(NSError * __autoreleasing *)error;
- (void)stopDeviceMotion;

- (void)setMotionDataOnTouchData:(DOMTouchData *)touchData;

@end
