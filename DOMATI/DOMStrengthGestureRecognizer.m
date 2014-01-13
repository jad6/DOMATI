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

#import "DOMDataFile.h"
#import "DOMTouchData+Extension.h"
#import "UITouch+Extension.h"

#import "DOMErrors.h"

@interface DOMStrengthGestureRecognizer ()

@property (nonatomic, strong) NSMutableDictionary *touchesDurations, *touchStates;

@property (nonatomic, strong) DOMMotionManager *motionManager;

@property (nonatomic) CGFloat strength;

@property (nonatomic) NSInteger numActiveTouches;

#ifdef DEBUG
@property (nonatomic) CGFloat averageAcceleration;
@property (nonatomic) CGFloat averageRotation;
@property (nonatomic) CGFloat touchRadius;
@property (nonatomic) NSTimeInterval duration;
#endif

@end

@implementation DOMStrengthGestureRecognizer

#pragma mark - Setters & Getters

- (NSMutableDictionary *)touchesDurations
{
    if (!_touchesDurations) {
        _touchesDurations = [[NSMutableDictionary alloc] init];
    }
    
    return _touchesDurations;
}

- (DOMMotionManager *)motionManager
{
    if (!_motionManager) {
        _motionManager = [DOMMotionManager sharedManager];
    }
    
    return _motionManager;
}

#pragma mark - Touches

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    self.numActiveTouches += [touches count];
    
    for (UITouch *touch in touches) {
        NSString *pointerKey = [touch pointerString];
        self.touchesDurations[pointerKey] = @(touch.timestamp);
    }
    
    NSLog(@"BEGAN %@", self);
    
    DOMMotionManager *motionManager = self.motionManager;
    if (![motionManager isDeviceMotionActive]) {
        NSError *error = nil;
        [motionManager startDeviceMotion:&error];
        if (error) {
            [error show];
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    
    if (self.state == UIGestureRecognizerStateFailed) {
        return;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    self.numActiveTouches -= [touches count];
    
    __block NSArray *savedMotions = nil;
    DOMMotionManager *motionManager = self.motionManager;
    if (self.numActiveTouches == 0) {
        [motionManager stopDeviceMotion:^(NSArray *motions) {
            savedMotions = motions;
        }];
    } else {
        savedMotions = [motionManager currentDeviceMotions];
    }
    
    
    for (UITouch *touch in touches) {
        NSString *pointerKey = [touch pointerString];
        NSTimeInterval duration = touch.timestamp - [self.touchesDurations[pointerKey] floatValue];
        
        [[DOMCoreDataManager sharedManager] saveTouchData:^(DOMTouchData *touchData) {
            touchData.duration = @(duration);
            [self setMotions:savedMotions onTouchData:touchData];
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
    
    if (self.numActiveTouches == 0) {
        [self.motionManager stopDeviceMotion:nil];
    }
}

- (void)reset
{
    [super reset];
    
    [self.motionManager stopDeviceMotion:nil];
}

#pragma mark - Motion

- (void)setMotions:(NSArray *)motions
       onTouchData:(DOMTouchData *)touchData
{
    NSError *error = nil;
    [self saveMotions:motions
          onTouchData:touchData
                error:&error];
    
    if (error) {
        NSLog(@"%@", error);
    }
}

- (void)saveMotions:(NSArray *)motions
        onTouchData:(DOMTouchData *)touchData
              error:(NSError *__autoreleasing *)error
{
    DOMDataFile *dataFile = [touchData motionDataFile];
    
    if (![NSKeyedArchiver archiveRootObject:motions toFile:dataFile.path]) {
        *error = [DOMErrors couldNotWriteFileError];
    }
}

@end
