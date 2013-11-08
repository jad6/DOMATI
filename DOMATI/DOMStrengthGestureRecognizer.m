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

#import "DOMTouchData+Extension.h"
#import "UITouch+Extension.h"

@interface DOMStrengthGestureRecognizer ()


@end

@implementation DOMStrengthGestureRecognizer

#pragma mark - Logic

#pragma mark - Touches

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    NSLog(@"%f", [touch radius]);
    
    NSError *error = nil;
    [[DOMMotionManager sharedManager] startDeviceMotion:&error];
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
    
    if (self.state == UIGestureRecognizerStatePossible) {
        self.state = UIGestureRecognizerStateRecognized;
    }
    
    [[DOMMotionManager sharedManager] stopDeviceMotion];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    
    self.state = UIGestureRecognizerStateFailed;
    
    [[DOMMotionManager sharedManager] stopDeviceMotion];
}

- (void)reset
{
    [super reset];
    
    [[DOMMotionManager sharedManager] stopDeviceMotion];
}

@end
