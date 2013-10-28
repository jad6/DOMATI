//
//  DMTouchData.h
//  DOMATI
//
//  Created by Jad Osseiran on 28/10/2013.
//  Copyright (c) 2013 Jad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DMTouchData : NSManagedObject

@property (nonatomic, retain) NSData * accelerometerInfo;
@property (nonatomic, retain) NSNumber * avgStrength;
@property (nonatomic, retain) NSNumber * duration;
@property (nonatomic, retain) NSData * gyroscopeInfo;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSData * microphoneInfo;
@property (nonatomic, retain) NSNumber * phase;
@property (nonatomic, retain) NSNumber * radius;
@property (nonatomic, retain) NSNumber * strength;
@property (nonatomic, retain) NSNumber * tapCount;
@property (nonatomic, retain) NSNumber * timestamp;
@property (nonatomic, retain) NSNumber * x;
@property (nonatomic, retain) NSNumber * y;

@end
