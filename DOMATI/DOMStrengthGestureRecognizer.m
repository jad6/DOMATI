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

@interface DOMStrengthGestureRecognizer () {
    /// The queue running on a different thread to process the data.
    dispatch_queue_t dataProcessingQueue;
}

@property (nonatomic, strong) DOMMotionManager *motionManager;

/// Dictionaries to hold the various informations for each touch.
@property (nonatomic, strong) NSMutableDictionary *touchesInfo, *motionsInfo, *motionItems;

@property (nonatomic) CGFloat strength;

@end

@implementation DOMStrengthGestureRecognizer

- (id)initWithTarget:(id)target action:(SEL)action
{
    self = [super initWithTarget:target action:action];
    if (self) {
        // Create the serial queue to ensure FIFS
        self->dataProcessingQueue = dispatch_queue_create("data_processing_queue", DISPATCH_QUEUE_SERIAL);
        dispatch_sync(self->dataProcessingQueue, ^{
            // Initialise storing objects on the dataProcessingQueue
            self.touchesInfo = [[NSMutableDictionary alloc] init];
            self.motionsInfo = [[NSMutableDictionary alloc] init];
            self.motionItems = [[NSMutableDictionary alloc] init];
        });
        
        DOMMotionManager *motionManager = [DOMMotionManager sharedManager];
        [motionManager startListening];
        
        self.motionManager = motionManager;
    }
    return self;
}

- (id)init
{
    return [self initWithTarget:nil action:nil];
}

- (void)dealloc
{
    // Stop recording the device motions when the gesture
    // recogniser is dealloced.
    [self.motionManager stopListening];
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

/**
 *  Gets the location of the touch in relation to the whole screen.
 *
 *  @param touch The touch who's location to grab.
 *  @param view  The view in which the touch has been made.
 *
 *  @return The point of the touch in relation to the whole screen.
 */
- (CGPoint)locationOfTouch:(UITouch *)touch onScreenForView:(UIView *)view
{
    CGPoint location = [touch locationInView:self.view];
    CGPoint viewOrigin = view.frame.origin;
    
    return CGPointMake(viewOrigin.x + location.x, viewOrigin.y + location.y);
}

/**
 *  Helper method to store the touches' touch and motion data.
 *
 *  @param touches The touches who's data we want to store.
 */
- (void)storeTouchesInfo:(NSSet *)touches
{
    // Make sure we are processing the data on a different queue.
    dispatch_sync(self->dataProcessingQueue, ^{
        for (UITouch *touch in touches) {
            NSString *pointerKey = [touch pointerString];
            
            // Get the tail for the linked list on touches began.
            if (touch.phase == UITouchPhaseBegan) {
                self.motionItems[pointerKey] = [[DOMMotionManager sharedManager] lastMotionItemWithTouchPhase:UITouchPhaseBegan];
            }
            
            // Retreive the touch location on the scren.
            CGPoint touchLocation = [self locationOfTouch:touch onScreenForView:self.view];
            
            // Store all the relevant touch info in a dictionary.
            NSDictionary *touchInfo = @{kTouchInfoTimestampKey : @(touch.timestamp),
                                        kTouchInfoXKey : @(touchLocation.x),
                                        kTouchInfoYKey : @(touchLocation.y),
                                        kTouchInfoPhaseKey : @(touch.phase),
                                        kTouchInfoRadiusKey : @([touch radius])};
            
            // Get the existing touch info for possible other states.
            NSMutableArray *touchAllPhasesInfo = self.touchesInfo[pointerKey];
            // If there are no other touch info states stored create
            // an array to hold them.
            if (!touchAllPhasesInfo) {
                touchAllPhasesInfo = [[NSMutableArray alloc] init];
            }
            // Store the new touch info.
            [touchAllPhasesInfo addObject:touchInfo];
            
            // Store the touch info phases in the overall dictionary.
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
    
    // We are about to do somewhat intensive work, let's keep that away form the main queue.
    dispatch_sync(self->dataProcessingQueue, ^{
        
        for (UITouch *touch in touches) {
            NSString *pointerKey = [touch pointerString];
            
            // The head of the linked list is the item stored when
            // the touch was in its UITouchPhaseBegan phase.
            DOMMotionItem *headMotionItem = self.motionItems[pointerKey];
            // Set a new pointer to enumerate with.
            DOMMotionItem *currentMotionItem = headMotionItem;
            // Get the new tail from the linked list.
            DOMMotionItem *tailMotionItem = [[DOMMotionManager sharedManager] lastMotionItemWithTouchPhase:UITouchPhaseEnded];
            
            // We have a stored scope reference to the head of the
            // linked list, therefore we can remove it from our
            // class collection.
            [self.motionItems removeObjectForKey:pointerKey];
            
            // Variables which will be used to calculate raw motion
            // data attributes.
            double totalAcceleration = 0.0;
            double totalRotation = 0.0;
            
            // Allocate array to store the touch's motions.
            NSMutableArray *motions = [[NSMutableArray alloc] init];
            while (currentMotionItem != tailMotionItem) {
                CMDeviceMotion *motion = currentMotionItem.deviceMotion;
                [motions addObject:motion];
                
                // Good old pythagorus to get the average acceleration.
                CMAcceleration acc = motion.userAcceleration;
                totalAcceleration += sqrt(acc.x * acc.x + acc.y * acc.y + acc.z * acc.z);
                
#warning Shit! was I meant to use pythagorus for rotaion?!
                // And again for the rotation.
                CMRotationRate rot = motion.rotationRate;
                totalRotation += sqrt(rot.x * rot.x + rot.y * rot.y + rot.z * rot.z);
                
                // Iterate the pointer to the next linked list item.
                currentMotionItem = [currentMotionItem nextObject];
            }
            
            // Work out the averages for the acceleration and rotation.
            NSUInteger motionsCount = [motions count];
            CGFloat avgAcceleration = (totalAcceleration / (motionsCount * 1.0));
            CGFloat avgRotation = (totalRotation / (motionsCount * 1.0));
            
            // Save the values in a dictionary for future possible reference.
            self.motionsInfo[[touch pointerString]] = @{kMotionInfoMotionsKey : motions,
                                                        kMotionInfoAvgAccelerationKey : @(avgAcceleration),
                                                        kMotionInfoAvgRotationKey : @(avgRotation)};
        }
    });
    
    // The touch has ended and reset the linked list if the motion
    // manager is not using for anything else.
    [self.motionManager resetLinkedListIfPossible];

    // Set the gesture recogniser to a recognised state.
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
