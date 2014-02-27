//
//  DOMStrengthGestureRecognizer.m
//  DOMATI
//
//  Created by Jad Osseiran on 2/11/2013.
//  Copyright (c) 2013 Jad. All rights reserved.
//

#import <UIKit/UIGestureRecognizerSubclass.h>

#import "DOMStrengthGestureRecognizer.h"

#import "DOMMotionManager.h"
#import "DOMCoreDataManager.h"

#import "DOMTouchData+Extension.h"
#import "DOMRawMotionData+Extensions.h"
#import "DOMRawTouchData+Extensions.h"

#import "NSObject+Extensions.h"
#import "UITouch+Extension.h"

#import "DOMErrors.h"

#define PRESS_DELTA 0.5

@interface DOMStrengthGestureRecognizer ()

@property (nonatomic, strong) DOMMotionManager *motionManager;
@property (nonatomic, strong) DOMMotionItem *motionItem;

@property (nonatomic, strong) NSMutableDictionary *touchesDurations;
@property (nonatomic, strong) NSTimer *longPressTimer;

@property (nonatomic) CGFloat strength;

@end

@implementation DOMStrengthGestureRecognizer

- (id)initWithTarget:(id)target action:(SEL)action
{
    self = [super initWithTarget:target action:action];
    if (self) {
        DOMMotionManager *motionManager = [DOMMotionManager sharedManager];
        if (![motionManager isDeviceMotionActive]) {
            NSError *error = nil;
            [motionManager startDeviceMotion:&error];
            if (error) {
                [error handle];
            }
        }
        
        self.motionManager = motionManager;
    }
    return self;
}

- (id)init
{
    self = [super initWithTarget:nil action:nil];
    if (self) {
        
    }
    return self;
}

- (void)dealloc
{
    [self.motionManager stopDeviceMotion];
}

#pragma mark - Touches

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    self.motionItem = [[DOMMotionManager sharedManager] lastMotionItem];
    
    for (UITouch *touch in touches) {
        NSString *pointerKey = [touch pointerString];
        self.touchesDurations[pointerKey] = @(touch.timestamp);
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    for (UITouch *touch in touches) {
        NSString *pointerKey = [touch pointerString];
        NSTimeInterval duration = touch.timestamp - [self.touchesDurations[pointerKey] floatValue];
    
        [self.touchesDurations removeObjectForKey:pointerKey];
        
        // Create a new ManagedObjectContext for multi threading core data operations.
        NSManagedObjectContext *threadContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        threadContext.parentContext = [DOMCoreDataManager sharedManager].mainContext;
        
        [threadContext performBlock:^{
            [DOMTouchData touchData:^(DOMTouchData *touchData) {
                
                touchData.duration = @(duration);
                
                [self setDeviceMotionsOnTouchData:touchData inContext:threadContext];
            } inContext:threadContext];
        }];
    }

    if (self.state == UIGestureRecognizerStatePossible) {
        self.state = UIGestureRecognizerStateRecognized;
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    
    self.state = UIGestureRecognizerStateFailed;
}

- (void)reset
{
    [super reset];
}

#pragma mark - Motion

- (void)setDeviceMotionsOnTouchData:(DOMTouchData *)touchData
                          inContext:(NSManagedObjectContext *)context
{
    DOMMotionItem *motionItem = [[DOMMotionManager sharedManager] lastMotionItem];
    
    DOMMotionItem *headMotionItem = self.motionItem;
    DOMMotionItem *currentMotionItem = headMotionItem;
    DOMMotionItem *tailMotionItem = motionItem;
    
    double totalAcceleration = 0.0;
    double totalRotation = 0.0;
    NSUInteger motionsCount = 0;
    
    while (currentMotionItem != tailMotionItem) {
        CMDeviceMotion *motion = currentMotionItem.deviceMotion;
        DOMRawMotionData *rawData = [DOMRawMotionData rawMotionDataInContext:context fromDeviceMotion:motion];
        [touchData addRawMotionDataObject:rawData];
        
        CMAcceleration acc = motion.userAcceleration;
        totalAcceleration += sqrt(acc.x * acc.x + acc.y * acc.y + acc.z * acc.z);
        
        CMRotationRate rot = motion.rotationRate;
        totalRotation += sqrt(rot.x * rot.x + rot.y * rot.y + rot.z * rot.z);
        
        currentMotionItem = [currentMotionItem nextObject];
        
        motionsCount++;
    }
    
    touchData.rotation = @((totalRotation / motionsCount));
    touchData.acceleration = @((totalAcceleration / motionsCount));
    
    NSLog(@"rotation: %@, acceleration: %@", touchData.rotation, touchData.acceleration);
}

@end
