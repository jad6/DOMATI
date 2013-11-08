//
//  DOMMotionManager.m
//  DOMATI
//
//  Created by Jad Osseiran on 2/11/2013.
//  Copyright (c) 2013 Jad. All rights reserved.
//

#import <CoreMotion/CoreMotion.h>

#import "DOMMotionManager.h"

#import "DOMErrors.h"

#import "NSManagedObject+Appulse.h"
#import "DOMTouchData+Extension.h"
#import "DOMDataFile.h"

@interface DOMMotionManager ()

@property (strong, nonatomic) CMMotionManager *motionManager;

@property (strong, nonatomic) NSMutableArray *motions;

@end

// 100 Hz update interval to get best feedback rate of readings
static NSTimeInterval kUpdateInterval = 0.01;

@implementation DOMMotionManager

+ (instancetype)sharedManager
{
    static __DISPATCH_ONCE__ DOMMotionManager *singletonObject = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singletonObject = [[self alloc] init];
        singletonObject.motionManager = [[CMMotionManager alloc] init];
        singletonObject.motions = [[NSMutableArray alloc] init];
    });
    
    return singletonObject;
}

- (void)startDeviceMotion:(NSError * __autoreleasing *)error
{
    if (![self.motionManager isDeviceMotionAvailable]) {
        *error = [DOMErrors noDeviceMotionError];
        return;
    }
    
    self.motionManager.deviceMotionUpdateInterval = kUpdateInterval;
    // Attitude that is referenced to true north
    NSOperationQueue *queue = [NSOperationQueue currentQueue];
    [self.motionManager startDeviceMotionUpdatesToQueue:queue withHandler:^(CMDeviceMotion *motion, NSError *error) {
        if (!error) {
            [self.motions addObject:motion];
        } else {
            NSLog(@"%@", error);
        }
    }];
}

- (void)stopDeviceMotion
{
    if ([self.motionManager isDeviceMotionActive]) {
        [self.motionManager stopDeviceMotionUpdates];
    }
}

#pragma mark - Logic

- (void)setMotionDataOnTouchData:(DOMTouchData *)touchData
{
    NSError *error = nil;
    [self saveMotionDataFromLastTouch:touchData error:&error];
    if (error) {
        NSLog(@"%@", error);
    }
}

- (void)saveMotionDataFromLastTouch:(DOMTouchData *)touchData
                              error:(NSError *__autoreleasing *)error
{    
    DOMDataFile *dataFile = [touchData motionDataFile];
    
    if (![NSKeyedArchiver archiveRootObject:self.motions toFile:dataFile.path]) {
        *error = [DOMErrors couldNotWriteFileError];
    }
}

@end
