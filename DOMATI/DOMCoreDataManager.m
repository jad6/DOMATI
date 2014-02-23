//
//  DOMCoreDataManager.m
//  DOMATI
//
//  Created by Jad Osseiran on 6/09/13.
//  Copyright (c) 2013 Jad. All rights reserved.
//

#import <CoreData/CoreData.h>

#import "DOMCoreDataManager.h"

#import "DOMTouchData+Extension.h"
#import "NSManagedObject+Appulse.h"

#define DATABASE_NAME @"DOMATI"

@interface DOMCoreDataManager ()

@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) NSManagedObjectContext *mainContext;

@end

@implementation DOMCoreDataManager

+ (instancetype)sharedManager
{
    static __DISPATCH_ONCE__ id singletonObject = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singletonObject = [[self alloc] init];
    });
    
    return singletonObject;
}

#pragma mark - Logic

- (DOMTouchData *)createTouchData:(void (^)(DOMTouchData *touchData))touchDataBlock
{
    DOMTouchData *touchData = nil;
    touchData = [DOMTouchData newEntity:NSStringFromClass([DOMTouchData class])
                              inContext:self.mainContext
                            idAttribute:@"identifier"
                                  value:[DOMTouchData localIdentifier]
                               onInsert:^(DOMTouchData *object) {                                   
                                   if (touchDataBlock) {
                                       touchDataBlock(object);
                                   }
                               }];
    [self saveContext];
    
    return touchData;
}

#pragma mark - Core Data Core

- (void)setupCoreData
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationShouldSaveContext:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationShouldSaveContext:) name:UIApplicationWillTerminateNotification object:nil];
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:DATABASE_NAME withExtension:@"momd"];
    self.managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    NSURL *documentDirectoryURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *storeURL = [documentDirectoryURL URLByAppendingPathComponent:@"coredata_domati.sqlite"];
    NSError *error = nil;
    self.persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
    if (![self.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:@{ NSMigratePersistentStoresAutomaticallyOption : @YES , NSInferMappingModelAutomaticallyOption : @YES } error:&error]) {
    }
    
    if (error) {
        [error handle];
    }
    
    self.mainContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [self.mainContext setPersistentStoreCoordinator:self.persistentStoreCoordinator];
}

- (void)saveContext:(NSManagedObjectContext *)context
{
    NSError *childError = nil;
    [context save:&childError];
    if (childError) {
        [childError handle];
    }
    
    UIBackgroundTaskIdentifier task = UIBackgroundTaskInvalid;
    dispatch_block_t block = ^{
        NSError *parentError = nil;
        if ([self.mainContext hasChanges] && ![self.mainContext save:&parentError]) {
            [parentError handle];
        }
        [[UIApplication sharedApplication] endBackgroundTask:task];
    };
    
    task = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:NULL];
    [self.mainContext performBlock:block];
}

- (void)saveContext
{
    [self saveContext:self.mainContext];
}

- (void)applicationShouldSaveContext:(NSNotification *)notification
{
    [self saveContext];
}

@end
