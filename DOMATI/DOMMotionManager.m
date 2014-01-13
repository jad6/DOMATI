//
//  DOMMotionManager.m
//  DOMATI
//
//  Created by Jad Osseiran on 2/11/2013.
//  Copyright (c) 2013 Jad. All rights reserved.
//

#import "DOMMotionManager.h"

#import "DOMErrors.h"

@interface DOMMotionManager ()

@property (nonatomic, copy) DOMMotionProcessCompletionBlock motionProcessCompletionBlock;

@property (strong, nonatomic) NSMutableArray *motions;

@end

// 60 Hz update interval to match the 60 fps of the display.
static NSTimeInterval kUpdateInterval = 0.06;

@implementation DOMMotionManager

+ (instancetype)sharedManager
{
    static __DISPATCH_ONCE__ id singletonObject = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singletonObject = [[self alloc] init];
    });
    
    return singletonObject;
}

- (NSArray *)currentDeviceMotions
{
    return [self.motions copy];
}

- (void)startDeviceMotion:(NSError * __autoreleasing *)error
{
    if ([self isDeviceMotionActive]) {
        return;
    }
    
    if (![self isDeviceMotionAvailable]) {
        *error = [DOMErrors noDeviceMotionError];
        return;
    }
    
    self.motions = [[NSMutableArray alloc] init];
    self.deviceMotionUpdateInterval = kUpdateInterval;

    NSOperationQueue *queue = [NSOperationQueue currentQueue];
    [queue addObserver:self
            forKeyPath:NSStringFromSelector(@selector(operationCount))
               options:0
               context:NULL];

    [self startDeviceMotionUpdatesToQueue:queue withHandler:^(CMDeviceMotion *motion, NSError *error) {
        if (!error) {
            [self.motions addObject:motion];
        } else {
            [error show];
        }
    }];
}

- (void)stopDeviceMotion:(DOMMotionProcessCompletionBlock)motionProcessCompletionBlock
{
    self.motionProcessCompletionBlock = motionProcessCompletionBlock;
    
    if ([self isDeviceMotionActive]) {
        [self stopDeviceMotionUpdates];
    }
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([object isKindOfClass:[NSOperationQueue class]] &&
        [keyPath isEqualToString:NSStringFromSelector(@selector(operationCount))]) {
        if ([object operationCount] == 0) {            
            if (self.motionProcessCompletionBlock) {
                self.motionProcessCompletionBlock([self.motions copy]);
            }
        }
    }
}

@end
