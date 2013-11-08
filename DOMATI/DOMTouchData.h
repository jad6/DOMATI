//
//  DOMTouchData.h
//  DOMATI
//
//  Created by Jad Osseiran on 2/11/2013.
//  Copyright (c) 2013 Jad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DOMDataFile;

@interface DOMTouchData : NSManagedObject

@property (nonatomic, retain) NSNumber * acceleration;
@property (nonatomic, retain) NSNumber * duration;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSNumber * numTouches;
@property (nonatomic, retain) NSNumber * radius;
@property (nonatomic, retain) NSNumber * rotation;
@property (nonatomic, retain) NSNumber * strength;
@property (nonatomic, retain) NSNumber * synced;
@property (nonatomic, retain) NSNumber * x;
@property (nonatomic, retain) NSNumber * y;
@property (nonatomic, retain) NSSet *dataFiles;
@end

@interface DOMTouchData (CoreDataGeneratedAccessors)

- (void)addDataFilesObject:(DOMDataFile *)value;
- (void)removeDataFilesObject:(DOMDataFile *)value;
- (void)addDataFiles:(NSSet *)values;
- (void)removeDataFiles:(NSSet *)values;

@end
