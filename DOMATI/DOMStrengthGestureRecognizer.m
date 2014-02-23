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

#import "DOMRawData.h"
#import "DOMTouchData+Extension.h"
#import "NSObject+Extensions.h"
#import "UITouch+Extension.h"

#import "DOMErrors.h"

#define PRESS_DELTA 0.5

@interface DOMStrengthGestureRecognizer ()

@property (nonatomic, strong) DOMMotionManager *motionManager;

@property (nonatomic, strong) NSMutableDictionary *touchesDurations;
@property (nonatomic, strong) NSTimer *longPressTimer;

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
        
    DOMMotionManager *motionManager = self.motionManager;
    if (![motionManager isDeviceMotionActive]) {
        NSError *error = nil;
        [motionManager startDeviceMotion:&error];
        if (error) {
            [error handle];
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    self.numActiveTouches -= [touches count];
    
    NSArray *touchesTouchData = [self touchesTouchDataFromTouches:touches];
    
    DOMMotionManager *motionManager = self.motionManager;
//    if (self.numActiveTouches == 0) {
//        [motionManager stopDeviceMotionWithMotionProcessCompletion:^(NSArray *motions) {
//            [self saveDeviceMotions:motions
//                 onTouchesTouchData:touchesTouchData];
//            
//            if (self.state == UIGestureRecognizerStatePossible) {
//                self.state = UIGestureRecognizerStateRecognized;
//            }
//        }];
//    } else {
        NSArray *motions = [motionManager currentDeviceMotions];
        [self saveDeviceMotions:motions
             onTouchesTouchData:touchesTouchData];
        
        if (self.state == UIGestureRecognizerStatePossible) {
            self.state = UIGestureRecognizerStateRecognized;
        }
//    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    
    self.state = UIGestureRecognizerStateFailed;
    
    if (self.numActiveTouches == 0) {
        [self.motionManager stopDeviceMotion];
    }
}

- (void)reset
{
    [super reset];
    
    [self.motionManager stopDeviceMotion];
}

#pragma mark - Motion

- (NSArray *)touchesTouchDataFromTouches:(NSSet *)touches
{
    NSMutableArray *touchesTouchData = [[NSMutableArray alloc] init];
    
    for (UITouch *touch in touches) {
        NSString *pointerKey = [touch pointerString];
        NSTimeInterval duration = touch.timestamp - [self.touchesDurations[pointerKey] floatValue];
        
        [self.touchesDurations removeObjectForKey:pointerKey];
        
        DOMTouchData *touchData = [[DOMCoreDataManager sharedManager] createTouchData:^(DOMTouchData *touchData) {
            touchData.duration = @(duration);
        }];
        
        [touchesTouchData addObject:touchData];
    }
    
    return touchesTouchData;
}

- (void)saveDeviceMotions:(NSArray *)motions
       onTouchesTouchData:(NSArray *)touchesTouchData
{
    for (DOMTouchData *touchData in touchesTouchData) {
        DOMRawData *rawData = [touchData motionRawData];
        rawData.data = motions;
        
        if ([motions count] > 0) {
            NSLog(@"MOTION %@", touchData.duration);
        } else {
            NSLog(@"%@", touchData.duration);
        }
    }
}

@end
