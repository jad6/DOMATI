//
//  DOMRawData.h
//  DOMATI
//
//  Created by Jad Osseiran on 13/02/2014.
//  Copyright (c) 2014 Jad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DOMTouchData;

@interface DOMRawData : NSManagedObject

@property (nonatomic, retain) NSNumber * kind;
@property (nonatomic, retain) id data;
@property (nonatomic, retain) NSNumber * identifier;
@property (nonatomic, retain) DOMTouchData *touchData;

@end
