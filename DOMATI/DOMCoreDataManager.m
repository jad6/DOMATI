//
//  DOMCoreDataManager.m
//  DOMATI
//
//  Created by Jad Osseiran on 6/09/13.
//  Copyright (c) 2013 Jad. All rights reserved.
//

#import <CoreData/CoreData.h>

#import "DOMCoreDataManager.h"

#import "DOMTouch.h"

#import "NSObject+Extension.h"
#import "NSManagedObject+Appulse.h"
#import "Touch.h"

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

#pragma mark - Manipulation

- (Touch *)saveTouch:(DOMTouch *)touch
{    
    Touch *t = [Touch newEntity:@"Touch"
                  inContext:self.mainContext
                idAttribute:@"timestamp"
                      value:@(touch.timestamp)
                   onInsert:^(Touch *newTouch) {
                       [newTouch enumeratePropertiesNames:^(NSString *propertyName) {
//                           NSLog(@"Key: %@, Value: %@", propertyName, [touch valueForKey:propertyName]);
                           id value = [touch valueForKey:propertyName];
                           if ([value isKindOfClass:[NSDictionary class]]) {
                               
                           } else {
                               [newTouch setValue:value forKey:propertyName];
                           }
                       }];
                   }];
    
    NSLog(@"%@", t);
    
    return t;
}

- (void)deleteTouch:(Touch *)touch
{
    
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
        NSLog(@"Error adding persistent store: %@", error);
    }
    
    self.mainContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [self.mainContext setPersistentStoreCoordinator:self.persistentStoreCoordinator];
}

- (void)applicationShouldSaveContext:(NSNotification *)notification
{
    [self saveContext:self.mainContext];
}

- (void)saveContext:(NSManagedObjectContext *)context
{
    NSError *childError = nil;
    [context save:&childError];
    
    UIBackgroundTaskIdentifier task = UIBackgroundTaskInvalid;
    dispatch_block_t block = ^{
        NSError *parentError = nil;
        if ([self.mainContext hasChanges] && ![self.mainContext save:&parentError]) {
            NSLog(@"Error saving context: %@", parentError);
        }
        [[UIApplication sharedApplication] endBackgroundTask:task];
    };
    
    task = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:NULL];
    [self.mainContext performBlock:block];
}

@end
