//
//  DOMDataRecordingStrengthGestureRecognizer.m
//  DOMATI
//
//  Created by Jad Osseiran on 27/02/2014.
//  Copyright (c) 2014 Jad. All rights reserved.
//

#import <UIKit/UIGestureRecognizerSubclass.h>

#import "DOMDataRecordingStrengthGestureRecognizer.h"

#import "DOMCalibrationViewController.h"

#import "DOMCoreDataManager.h"
#import "DOMTouchData+Extension.h"
#import "DOMRawMotionData+Extensions.h"
#import "DOMRawTouchData+Extensions.h"

@interface DOMDataRecordingStrengthGestureRecognizer ()

@property (nonatomic, strong) NSMutableArray *motions;

@property (nonatomic, copy) DOMCoreDataSave saveDataCompletionBlock;

@property (nonatomic) DOMCalibrationState currentState;
@property (nonatomic) BOOL saving;
@property (nonatomic) NSInteger numberOfCoreDataSaves;

@end

@implementation DOMDataRecordingStrengthGestureRecognizer 

- (id)initWithTarget:(id)target action:(SEL)action
{
    self = [super initWithTarget:target action:action];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changedState:) name:kCalibrationStateChangeNotificationName object:nil];
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
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setNumberOfCoreDataSaves:(NSInteger)numberOfCoreDataSaves
{
    if (self->_numberOfCoreDataSaves != numberOfCoreDataSaves) {
        self->_numberOfCoreDataSaves = numberOfCoreDataSaves;
    }
    
    self.saving = (numberOfCoreDataSaves != 0);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    for (UITouch *touch in touches) {
        NSArray *touchAllPhasesInfo = [self allPhasesInfoForTouch:touch];
        NSDictionary *motionsInfo = [self motionsInfoForTouch:touch];
        
        // Create a new ManagedObjectContext for multi threading core data operations.
        NSManagedObjectContext *threadContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        threadContext.parentContext = [DOMCoreDataManager sharedManager].mainContext;
        
        self.numberOfCoreDataSaves++;
        [threadContext performBlock:^{
            [DOMTouchData touchData:^(DOMTouchData *touchData) {
                [self setDeviceMotionsInfo:motionsInfo
                               onTouchData:touchData
                                 inContext:threadContext];
                
                [self setTouchAllPhasesInfo:touchAllPhasesInfo
                                onTouchData:touchData
                                  inContext:threadContext];
            } inContext:threadContext];
            
            [[DOMCoreDataManager sharedManager] saveContext:threadContext];
            
            self.numberOfCoreDataSaves--;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [[DOMCoreDataManager sharedManager] saveMainContext];
                
                if (self.saveDataCompletionBlock) {
                    self.saveDataCompletionBlock();
                }
            });
        }];
    }
}

- (void)setTouchAllPhasesInfo:(NSArray *)touchAllPhasesInfo
                  onTouchData:(DOMTouchData *)touchData
                    inContext:(NSManagedObjectContext *)context
{
    NSTimeInterval startTimestamp = 0.0;
    NSTimeInterval endTimestamp = 0.0;
    
    CGFloat startX = 0.0;
    CGFloat endX = 0.0;
    
    CGFloat startY = 0.0;
    CGFloat endY = 0.0;
    
    CGFloat maxRadius = (CGFLOAT_IS_DOUBLE) ? DBL_MIN : FLT_MIN;
    
    for (NSDictionary *touchInfo in touchAllPhasesInfo) {
        if ([touchInfo[@"phase"] integerValue] == UITouchPhaseBegan) {
            startTimestamp = [touchInfo[@"timestamp"] doubleValue];
            
            startX = (CGFLOAT_IS_DOUBLE) ? [touchInfo[@"x"] doubleValue] : [touchInfo[@"x"] floatValue];
            startY = (CGFLOAT_IS_DOUBLE) ? [touchInfo[@"y"] doubleValue] : [touchInfo[@"y"] floatValue];
        }
        if ([touchInfo[@"phase"] integerValue] == UITouchPhaseEnded) {
            endTimestamp = [touchInfo[@"timestamp"] doubleValue];
            
            endX = (CGFLOAT_IS_DOUBLE) ? [touchInfo[@"x"] doubleValue] : [touchInfo[@"x"] floatValue];
            endY = (CGFLOAT_IS_DOUBLE) ? [touchInfo[@"y"] doubleValue] : [touchInfo[@"y"] floatValue];
        }
        
        CGFloat radius = (CGFLOAT_IS_DOUBLE) ? [touchInfo[@"radius"] doubleValue] : [touchInfo[@"radius"] floatValue];
        if (radius > maxRadius) {
            maxRadius = radius;
        }
        
        DOMRawTouchData *rawData = [DOMRawTouchData rawTouchDataInContext:context fromTouchInfo:touchInfo];
        [touchData addRawTouchDataObject:rawData];
    }
    
    touchData.calibrationStrength = @(self.currentState);
    touchData.xDetla = @(ABS(endX - startX));
    touchData.yDelta = @(ABS(endY - startY));
    touchData.maxRadius = @(maxRadius);
    touchData.duration = @(endTimestamp - startTimestamp);
}

- (void)setDeviceMotionsInfo:(NSDictionary *)motionsInfo
                 onTouchData:(DOMTouchData *)touchData
                   inContext:(NSManagedObjectContext *)context
{
    for (CMDeviceMotion *motion in motionsInfo[@"motions"]) {
        DOMRawMotionData *rawData = [DOMRawMotionData rawMotionDataInContext:context fromDeviceMotion:motion];
        [touchData addRawMotionDataObject:rawData];
    }
    
    touchData.rotationAvg = motionsInfo[@"rotationAvg"];
    touchData.accelerationAvg = motionsInfo[@"accelerationAvg"];
}

- (void)setCoreDataSaveCompletionBlock:(DOMCoreDataSave)block
{
    self.saveDataCompletionBlock = block;
}

#pragma mark - Notification

- (void)changedState:(NSNotification *)notification
{
    self.currentState = [[notification userInfo][@"state"] integerValue];
}

@end
