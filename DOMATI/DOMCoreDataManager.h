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

@property (strong, nonatomic, readonly) NSManagedObjectContext *mainContext;

+ (instancetype)sharedManager;

- (void)setupCoreData;
- (void)saveContext;

@end
