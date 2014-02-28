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

#import "NSObject+Extensions.h"
#import "UITouch+Extension.h"

#import "DOMErrors.h"

#define PRESS_DELTA 0.5

@interface DOMStrengthGestureRecognizer () {
    dispatch_queue_t dataProcessingQueue;
}

@property (nonatomic, strong) DOMMotionManager *motionManager;

@property (nonatomic, strong) NSMutableDictionary *touchesInfo, *motionsInfo, *motionItems;
@property (nonatomic, strong) NSTimer *longPressTimer;

@property (nonatomic) CGFloat strength;

@end

@implementation DOMStrengthGestureRecognizer

- (id)initWithTarget:(id)target action:(SEL)action
{
    self = [super initWithTarget:target action:action];
    if (self) {
        self->dataProcessingQueue = dispatch_queue_create("data_processing_queue", DISPATCH_QUEUE_SERIAL);
        dispatch_sync(self->dataProcessingQueue, ^{
            self.touchesInfo = [[NSMutableDictionary alloc] init];
            self.motionsInfo = [[NSMutableDictionary alloc] init];
            self.motionItems = [[NSMutableDictionary alloc] init];
        });
        
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

#pragma mark - Logic

- (void)resetMotionCache
{
    [self.motionManager resetLinkedListIfPossible];
}

- (NSDictionary *)motionsInfoForTouch:(UITouch *)touch
{
    NSString *pointerKey = [touch pointerString];
    
    __block NSDictionary *motionsInfo = nil;
    dispatch_barrier_sync(self->dataProcessingQueue, ^{
        motionsInfo = [self.motionsInfo[pointerKey] copy];
        [self.motionsInfo removeObjectForKey:pointerKey];
    });
    
    return motionsInfo;
}

- (NSArray *)allPhasesInfoForTouch:(UITouch *)touch
{
    NSString *pointerKey = [touch pointerString];

    __block NSArray *touchAllPhasesInfo = nil;
    dispatch_barrier_sync(self->dataProcessingQueue, ^{
        touchAllPhasesInfo = [self.touchesInfo[pointerKey] copy];
        [self.touchesInfo removeObjectForKey:pointerKey];
    });
    
    return touchAllPhasesInfo;
}

- (CGPoint)locationOfTouch:(UITouch *)touch onScreenForView:(UIView *)view
{
    CGPoint location = [touch locationInView:self.view];
    CGPoint viewOrigin = view.frame.origin;
    
    return CGPointMake(viewOrigin.x + location.x, viewOrigin.y + location.y);
}

- (void)storeTouchesInfo:(NSSet *)touches
{
    dispatch_sync(self->dataProcessingQueue, ^{
        for (UITouch *touch in touches) {
            NSString *pointerKey = [touch pointerString];
            
            if (touch.phase == UITouchPhaseBegan) {
                self.motionItems[pointerKey] = [[DOMMotionManager sharedManager] lastMotionItemWithTouchPhase:UITouchPhaseBegan];
            }
            
            CGPoint touchLocation = [self locationOfTouch:touch onScreenForView:self.view];
            
            NSDictionary *touchInfo = @{@"timestamp" : @(touch.timestamp),
                                        @"x" : @(touchLocation.x),
                                        @"y" : @(touchLocation.y),
                                        @"phase" : @(touch.phase),
                                        @"radius" : @([touch radius])};
            
            NSMutableArray *touchAllPhasesInfo = self.touchesInfo[pointerKey];
            if (!touchAllPhasesInfo) {
                touchAllPhasesInfo = [[NSMutableArray alloc] init];
            }
            [touchAllPhasesInfo addObject:touchInfo];
            
            self.touchesInfo[pointerKey] = touchAllPhasesInfo;
        }
    });
}

#pragma mark - Touches

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    [self storeTouchesInfo:touches];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    
    [self storeTouchesInfo:touches];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    [self storeTouchesInfo:touches];
    
    dispatch_sync(self->dataProcessingQueue, ^{
        
        for (UITouch *touch in touches) {
            NSString *pointerKey = [touch pointerString];
            
            DOMMotionItem *motionItem = [[DOMMotionManager sharedManager] lastMotionItemWithTouchPhase:UITouchPhaseEnded];
            
            DOMMotionItem *headMotionItem = self.motionItems[pointerKey];
            DOMMotionItem *currentMotionItem = headMotionItem;
            DOMMotionItem *tailMotionItem = motionItem;
            
            [self.motionItems removeObjectForKey:pointerKey];
            
            double totalAcceleration = 0.0;
            double totalRotation = 0.0;
            NSUInteger motionsCount = 0;
            
            NSMutableArray *motions = [[NSMutableArray alloc] init];
            while (currentMotionItem != tailMotionItem) {
                CMDeviceMotion *motion = currentMotionItem.deviceMotion;
                [motions addObject:motion];
                
                CMAcceleration acc = motion.userAcceleration;
                totalAcceleration += sqrt(acc.x * acc.x + acc.y * acc.y + acc.z * acc.z);
                
                CMRotationRate rot = motion.rotationRate;
                totalRotation += sqrt(rot.x * rot.x + rot.y * rot.y + rot.z * rot.z);
                
                currentMotionItem = [currentMotionItem nextObject];
                
                motionsCount++;
            }
            
            
            CGFloat avgAcceleration = (totalAcceleration / (motionsCount * 1.0));
            CGFloat avgRotation = (totalRotation / (motionsCount * 1.0));
            
            NSLog(@"%f", avgAcceleration);
            
            self.motionsInfo[[touch pointerString]] = @{@"motions" : motions,
                                                        @"accelerationAvg" : @(avgAcceleration),
                                                        @"rotationAvg" : @(avgRotation)};
        }
    });
    
    [self.motionManager resetLinkedListIfPossible];

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

@end
