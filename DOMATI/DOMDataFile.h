//
//  DOMDataFile.h
//  DOMATI
//
//  Created by Jad Osseiran on 2/11/2013.
//  Copyright (c) 2013 Jad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DOMTouchData;

@interface DOMDataFile : NSManagedObject

@property (nonatomic, retain) NSNumber * kind;
@property (nonatomic, retain) NSString * path;
@property (nonatomic, retain) DOMTouchData *touchData;

@end
