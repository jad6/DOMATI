//
//  Touch.h
//  DOMATI
//
//  Created by Jad Osseiran on 6/09/13.
//  Copyright (c) 2013 Jad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Touch : NSManagedObject

@property (nonatomic, retain) NSNumber * x;
@property (nonatomic, retain) NSNumber * y;
@property (nonatomic, retain) NSNumber * timestamp;
@property (nonatomic, retain) NSNumber * tapCount;
@property (nonatomic, retain) NSNumber * strength;
@property (nonatomic, retain) NSNumber * phase;
@property (nonatomic, retain) NSNumber * avgStrength;
@property (nonatomic, retain) NSNumber * duration;
@property (nonatomic, retain) NSNumber * radius;
@property (nonatomic, retain) NSData * gyroscopeInfo;
@property (nonatomic, retain) NSData * accelerometerInfo;
@property (nonatomic, retain) NSData * microphoneInfo;

@end
