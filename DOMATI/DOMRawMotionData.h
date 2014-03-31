//
//  DOMRawMotionData.h
//  DOMATI
//
//  Created by Jad Osseiran on 27/02/2014.
//  Copyright (c) 2014 Jad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DOMTouchData;

@interface DOMRawMotionData : NSManagedObject

@property (nonatomic, retain) NSNumber *identifier;
@property (nonatomic, retain) NSNumber *pitch;
@property (nonatomic, retain) NSNumber *quaternionW;
@property (nonatomic, retain) NSNumber *quaternionX;
@property (nonatomic, retain) NSNumber *quaternionY;
@property (nonatomic, retain) NSNumber *quaternionZ;
@property (nonatomic, retain) NSNumber *roll;
@property (nonatomic, retain) NSNumber *rotationRateX;
@property (nonatomic, retain) NSNumber *rotationRateY;
@property (nonatomic, retain) NSNumber *rotationRateZ;
@property (nonatomic, retain) NSNumber *userAccelX;
@property (nonatomic, retain) NSNumber *userAccelY;
@property (nonatomic, retain) NSNumber *userAccelZ;
@property (nonatomic, retain) NSNumber *yaw;
@property (nonatomic, retain) NSNumber *timestamp;
@property (nonatomic, retain) DOMTouchData *touchData;

@end
