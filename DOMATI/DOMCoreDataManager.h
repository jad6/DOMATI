//
//  DOMCoreDataManager.h
//  DOMATI
//
//  Created by Jad Osseiran on 6/09/13.
//  Copyright (c) 2013 Jad. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DOMTouchData;

@interface DOMCoreDataManager : NSObject

@property (strong, nonatomic, readonly) NSManagedObjectContext * managedContext;

+ (instancetype)sharedManager;

- (void)flushDatabase;
- (void)setupCoreData;
- (void)saveMainContext;
- (void)saveContext:(NSManagedObjectContext *)context;

@end
