//
//  DOMCoreDataManager.m
//
//  Created by Jad Osseiran on 6/09/13.
//  Copyright (c) 2013 Jad. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  Redistributions of source code must retain the above copyright notice, this
//  list of conditions and the following disclaimer. Redistributions in binary
//  form must reproduce the above copyright notice, this list of conditions and
//  the following disclaimer in the documentation and/or other materials
//  provided with the distribution. Neither the name of the nor the names of
//  its contributors may be used to endorse or promote products derived from
//  this software without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
//  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
//  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
//  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
//  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
//  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
//  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
//  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
//  POSSIBILITY OF SUCH DAMAGE.

@import CoreData;

#import "DOMCoreDataManager.h"

#define DATABASE_NAME @"DOMATI"

@interface DOMCoreDataManager ()

@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong) NSManagedObjectContext *managedContext;

@end

@implementation DOMCoreDataManager

+ (instancetype)sharedManager {
    static __DISPATCH_ONCE__ id singletonObject = nil;

    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
      singletonObject = [[self alloc] init];
    });

    return singletonObject;
}

#pragma mark - Core Data Core

- (void)flushDatabase {
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

- (void)setupCoreData {
    // Listen to notifications when the app will lose focus and save
    // the data in that case.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationShouldSaveContext:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationShouldSaveContext:) name:UIApplicationWillTerminateNotification object:nil];

    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:DATABASE_NAME withExtension:@"momd"];
    self.managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];

    NSURL *documentDirectoryURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *storeURL = [documentDirectoryURL URLByAppendingPathComponent:@"coredata_domati.sqlite"];
    NSError *error = nil;
    self.persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
    if (![self.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:@{ NSMigratePersistentStoresAutomaticallyOption : @YES,
                                                                                                                                 NSInferMappingModelAutomaticallyOption : @YES }
                                                               error:&error]) {
    }

    if (error) {
        [error handle];
    }

    self.managedContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [self.managedContext setPersistentStoreCoordinator:self.persistentStoreCoordinator];
}

- (void)saveContext:(NSManagedObjectContext *)context {
    NSError *childError = nil;

    if (![context save:&childError]) {
        [childError handle];
    }

    // Make sure the saving finishes
    UIBackgroundTaskIdentifier task = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
    [self.managedContext performBlock:^{
      NSError *parentError = nil;
      if ([self.managedContext hasChanges] &&
          ![self.managedContext save:&parentError]) {
          [parentError handle];
      }
      [[UIApplication sharedApplication] endBackgroundTask:task];
    }];
}

- (void)saveMainContext {
    [self saveContext:self.managedContext];
}

- (void)applicationShouldSaveContext:(NSNotification *)notification {
    [self saveMainContext];
}

@end
