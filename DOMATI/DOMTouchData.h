//
//  DOMTouchData.h
//  DOMATI
//
//  Created by Jad Osseiran on 23/02/2014.
//  Copyright (c) 2014 Jad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DOMRawData;

@interface DOMTouchData : NSManagedObject

@property (nonatomic, retain) NSNumber * acceleration;
@property (nonatomic, retain) NSNumber * calibrationStrength;
@property (nonatomic, retain) NSNumber * duration;
@property (nonatomic, retain) NSNumber * group;
@property (nonatomic, retain) NSNumber * identifier;
@property (nonatomic, retain) NSNumber * numTouches;
@property (nonatomic, retain) NSNumber * radius;
@property (nonatomic, retain) NSNumber * rotation;
@property (nonatomic, retain) NSNumber * strength;
@property (nonatomic, retain) NSNumber * x;
@property (nonatomic, retain) NSNumber * y;
@property (nonatomic, retain) NSSet *rawData;
@end

@interface DOMTouchData (CoreDataGeneratedAccessors)

- (void)addRawDataObject:(DOMRawData *)value;
- (void)removeRawDataObject:(DOMRawData *)value;
- (void)addRawData:(NSSet *)values;
- (void)removeRawData:(NSSet *)values;

@end
