//
//  DOMRawMotionData.h
//  DOMATI
//
//  Created by Jad Osseiran on 25/04/2014.
//  Copyright (c) 2014 Jad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DOMTouchData;

@interface DOMRawMotionData : NSManagedObject

@property (nonatomic, retain) NSNumber * identifier;
@property (nonatomic, retain) NSNumber * rotationRateX;
@property (nonatomic, retain) NSNumber * rotationRateY;
@property (nonatomic, retain) NSNumber * rotationRateZ;
@property (nonatomic, retain) NSNumber * timestamp;
@property (nonatomic, retain) NSNumber * userAccelX;
@property (nonatomic, retain) NSNumber * userAccelY;
@property (nonatomic, retain) NSNumber * userAccelZ;
@property (nonatomic, retain) DOMTouchData *touchData;

@end
