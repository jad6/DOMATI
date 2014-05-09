//  DOMActiveMotionManager.m
// 
//  Created by Jad on 29/04/2014.
//  Copyright (c) 2014 Jad. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
// 
//  Redistributions of source code must retain the above copyright notice, this
//  list of conditions and the following disclaimer. Redistributions in binary
//  form must reproduce the above copyright notice, this list of conditions and
//  the following disclaimer in the documentation and/or other materials
//  provided with the distribution. Neither the name of the nor the names of
//  its contributors may be used to endorse or promote products derived from
//  this software without specific prior written permission.
// 
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
//  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
//  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
//  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
//  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
//  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
//  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
//  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
//  POSSIBILITY OF SUCH DAMAGE.

#import "DOMActiveMotionManager.h"

@interface DOMActiveMotionManager ()

@property (nonatomic, strong) NSMutableArray *motions;

@end

@implementation DOMActiveMotionManager

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.motions = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark - Abstract Methods

- (void)handleMotionObjectUpdate:(CMDeviceMotion *)deviceMotion
{
    if (self.motions)
    {
        [self.motions addObject:deviceMotion];
    }
}

- (BOOL)resetDataStructureIfPossible
{
    return [self resetArrayIfPossible];
}

#pragma mark - Storing

- (BOOL)resetArrayIfPossible
{
    __block BOOL didReset = NO;
    
    if (self.numActivities == 0 && self.numListeners == 0)
    {
        if (self.motions)
        {
            [self.motions removeAllObjects];
        }
        didReset = YES;
    }
    
    return didReset;
}

- (NSUInteger)currentMotionIndexWithTouchPhase:(UITouchPhase)phase
{
    if (phase == UITouchPhaseEnded)
    {
        self.numActivities--;
    }
    else if (phase == UITouchPhaseBegan)
    {
        self.numActivities++;
    }
    
    return [self.motions count];
}

- (NSArray *)currentMotions
{
    return [self.motions copy];
}

@end
