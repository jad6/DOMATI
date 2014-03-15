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
@property (strong, nonatomic) NSManagedObjectContext *managedContext;

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

#pragma mark - Core Data Core

- (void)flushDatabase
{
    [self.managedContext lock];
    NSArray *stores = [self.persistentStoreCoordinator persistentStores];
    for (NSPersistentStore *store in stores) {
        [self.persistentStoreCoordinator removePersistentStore:store error:nil];
        [[NSFileManager defaultManager] removeItemAtPath:store.URL.path error:nil];
    }
    [self.managedContext unlock];
    
    self.managedObjectModel = nil;
    self.managedContext = nil;
    self.persistentStoreCoordinator = nil;
}

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
    
    self.managedContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [self.managedContext setPersistentStoreCoordinator:self.persistentStoreCoordinator];
}

- (void)saveContext:(NSManagedObjectContext *)context
{
    NSError *childError = nil;
    [context save:&childError];
    if (childError) {
        [childError handle];
    }
    
    UIBackgroundTaskIdentifier task = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
    [self.managedContext performBlock:^{
        NSError *parentError = nil;
        if ([self.managedContext hasChanges] && ![self.managedContext save:&parentError]) {
            [parentError handle];
        }
        [[UIApplication sharedApplication] endBackgroundTask:task];
    }];
}

- (void)saveMainContext
{
    [self saveContext:self.managedContext];
}

- (void)applicationShouldSaveContext:(NSNotification *)notification
{
    [self saveMainContext];
}

@end
