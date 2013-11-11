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
#import "UITouch+Extension.h"

@interface DOMStrengthGestureRecognizer ()

@property (strong, nonatomic) NSMutableDictionary *touchesDurations, *touchStates;

@property (nonatomic) CGFloat strength;

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

#pragma mark - Logic

- (BOOL)noTouchEvents
{
    return [self.touchesDurations count] == 0;
}

- (void)handleTouchesBegining:(NSSet *)touches
{
    [touches enumerateObjectsUsingBlock:^(UITouch *touch, BOOL *stop) {
        NSString *pointerKey = [touch pointerString];
        self.touchesDurations[pointerKey] = @(touch.timestamp);
    }];
}

- (void)handleTouchesEnd:(NSSet *)touches
{
    [touches enumerateObjectsUsingBlock:^(UITouch *touch, BOOL *stop) {
        NSString *pointerKey = [touch pointerString];
        NSTimeInterval duration = touch.timestamp - [self.touchesDurations[pointerKey] floatValue];
        
        [[DOMCoreDataManager sharedManager] saveTouchData:^(DOMTouchData *touchData) {
            touchData.duration = @(duration);
            [[DOMMotionManager sharedManager] setMotionDataOnTouchData:touchData];
        }];
    }];
}

#pragma mark - Touches

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    [self handleTouchesBegining:touches];

    if ([self noTouchEvents]) {
        NSError *error = nil;
        [[DOMMotionManager sharedManager] startDeviceMotion:&error];
        if (error) {
            NSLog(@"%@", error);
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
    
    if ([self noTouchEvents]) {
        [[DOMMotionManager sharedManager] stopDeviceMotion];
    }
    
    [self handleTouchesEnd:touches];
    
    if (self.state == UIGestureRecognizerStatePossible) {
        self.state = UIGestureRecognizerStateRecognized;
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    
    self.state = UIGestureRecognizerStateFailed;
    
    if ([self noTouchEvents]) {
        [[DOMMotionManager sharedManager] stopDeviceMotion];
    }
}

- (void)reset
{
    [super reset];
    
    [[DOMMotionManager sharedManager] stopDeviceMotion];
}

@end
