//
//  DOMTouchData.h
//  DOMATI
//
//  Created by Jad Osseiran on 27/02/2014.
//  Copyright (c) 2014 Jad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DOMRawMotionData, DOMRawTouchData;

@interface DOMTouchData : NSManagedObject

@property (nonatomic, retain) NSNumber * accelerationAvg;
@property (nonatomic, retain) NSNumber * calibrationStrength;
@property (nonatomic, retain) NSNumber * duration;
@property (nonatomic, retain) NSNumber * group;
@property (nonatomic, retain) NSNumber * identifier;
@property (nonatomic, retain) NSNumber * maxRadius;
@property (nonatomic, retain) NSNumber * rotationAvg;
@property (nonatomic, retain) NSNumber * xDetla;
@property (nonatomic, retain) NSNumber * yDelta;
@property (nonatomic, retain) NSSet * rawMotionData;
@property (nonatomic, retain) NSSet * rawTouchData;
@end

@interface DOMTouchData (CoreDataGeneratedAccessors)

- (void)addRawMotionDataObject:(DOMRawMotionData *)value;
- (void)removeRawMotionDataObject:(DOMRawMotionData *)value;
- (void)addRawMotionData:(NSSet *)values;
- (void)removeRawMotionData:(NSSet *)values;

- (void)addRawTouchDataObject:(DOMRawTouchData *)value;
- (void)removeRawTouchDataObject:(DOMRawTouchData *)value;
- (void)addRawTouchData:(NSSet *)values;
- (void)removeRawTouchData:(NSSet *)values;

@end
