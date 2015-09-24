//  DOMApproachTestViewController.m
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

#import "DOMApproachTestViewController.h"

#import "DOMPassiveMotionManager.h"
#import "DOMActiveMotionManager.h"

typedef NS_ENUM(NSInteger, DOMApproachTestStrength) {
    DOMApproachTestStrengthSoft,
    DOMApproachTestStrengthNormal,
    DOMApproachTestStrengthHard
};

typedef NS_ENUM(NSInteger, DOMAproachAlgorithm) {
    DOMAproachAlgorithmActive,
    DOMAproachAlgorithmPassive
};

static CGFloat const kSoftDuration = 0.122f;
static CGFloat const kNormakDuration = 0.102f;
static CGFloat const kHardDuration = 0.246f;

static NSTimeInterval const kBetweenDelay = 2.0;

@interface DOMApproachTestViewController ()

@property (nonatomic, strong) id motionManager;

@property (nonatomic, strong) IBOutletCollection(UILabel) NSArray *detailLabels;

@end

@implementation DOMApproachTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Approaches";

    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshAction:) forControlEvents:UIControlEventValueChanged];
    refreshControl.tintColor = [UIColor textColor];
    self.refreshControl = refreshControl;

    for (UILabel *detailLabel in self.detailLabels) {
        detailLabel.text = @"Loading";
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self refreshAction:self.refreshControl];
}

#pragma mark - Logic

- (NSTimeInterval)timeDurationForStrength:(DOMApproachTestStrength)strength {
    switch (strength) {
        case DOMApproachTestStrengthSoft:
            return kSoftDuration;
            break;

        case DOMApproachTestStrengthNormal:
            return kNormakDuration;
            break;

        case DOMApproachTestStrengthHard:
            return kHardDuration;
            break;
    }
}

- (void)updateLabelWithValue:(NSUInteger)value
                 forStrength:(DOMApproachTestStrength)strength
                   algorithm:(DOMAproachAlgorithm)algorithm {
    NSUInteger originIdx = (algorithm == DOMAproachAlgorithmActive) ? 3 : 0;
    NSUInteger detailLabelIdx = strength + originIdx;
    UILabel *detailLabel = self.detailLabels[detailLabelIdx];
    detailLabel.text = [[NSString alloc] initWithFormat:@"%lu objects", (unsigned long)value];
    detailLabel.textColor = [UIColor domatiColor];
    [detailLabel sizeToFit];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
      detailLabel.textColor = [UIColor detailTextColor];
    });
}

#pragma mark - Active Approach

- (void)activeApproachSimulationForStrength:(DOMApproachTestStrength)strength
                              motionManager:(DOMActiveMotionManager *)motionManager
                                 completion:(void (^)(void))completionBlock {
    if (strength > DOMApproachTestStrengthHard && completionBlock) {
        completionBlock();
        return;
    }

    NSError *error = nil;
    [motionManager startListening:&error];
    if (error) {
        [error handle];
    }

    NSUInteger startIdx = [motionManager currentMotionIndexWithTouchPhase:UITouchPhaseBegan];

    NSTimeInterval delay = [self timeDurationForStrength:strength];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

      NSUInteger endIdx = [motionManager currentMotionIndexWithTouchPhase:UITouchPhaseEnded];

      NSUInteger count = endIdx - startIdx;

      [motionManager stopListening];

      [self updateLabelWithValue:count
                     forStrength:strength
                       algorithm:DOMAproachAlgorithmActive];

      DOMApproachTestStrength nextStrength = strength + 1;
      NSTimeInterval strengthDelay = (nextStrength > DOMApproachTestStrengthHard) ? 0.0 : kBetweenDelay;

      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(strengthDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self activeApproachSimulationForStrength:nextStrength motionManager:motionManager completion:completionBlock];
      });
    });
}

- (void)runActiveApproachSimulation:(void (^)(void))completionBlock {
    self.motionManager = [[DOMActiveMotionManager alloc] init];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kBetweenDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
      [self activeApproachSimulationForStrength:DOMApproachTestStrengthSoft
                                  motionManager:self.motionManager
                                     completion:^{
                                       if (completionBlock) {
                                           completionBlock();
                                       }
                                     }];
    });
}

#pragma mark - Passive Approach

- (void)passiveApproachSimulationForStrength:(DOMApproachTestStrength)strength
                               motionManager:(DOMPassiveMotionManager *)motionManager
                                  completion:(void (^)(void))completionBlock {
    if (strength > DOMApproachTestStrengthHard && completionBlock) {
        completionBlock();
        return;
    }

    DOMMotionItem *headMotionItem = [motionManager lastMotionItemWithTouchPhase:UITouchPhaseBegan];

    NSTimeInterval delay = [self timeDurationForStrength:strength];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
      DOMMotionItem *currentMotionItem = headMotionItem;
      DOMMotionItem *tailMotionItem = [motionManager lastMotionItemWithTouchPhase:UITouchPhaseEnded];

      NSUInteger count = 0;
      while (currentMotionItem != tailMotionItem) {
          count++;

          // Iterate the pointer to the next linked list item.
          currentMotionItem = [currentMotionItem nextObject];
      }

      [self updateLabelWithValue:count
                     forStrength:strength
                       algorithm:DOMAproachAlgorithmPassive];

      DOMApproachTestStrength nextStrength = strength + 1;
      NSTimeInterval strengthDelay = (nextStrength > DOMApproachTestStrengthHard) ? 0.0 : kBetweenDelay;

      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(strengthDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self passiveApproachSimulationForStrength:nextStrength motionManager:motionManager completion:completionBlock];
      });
    });
}

- (void)runPassiveApproachSimulation:(void (^)(void))completionBlock {
    self.motionManager = [[DOMPassiveMotionManager alloc] init];

    NSError *error = nil;
    [self.motionManager startListening:&error];
    if (error) {
        [error handle];
    }

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kBetweenDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
      [self passiveApproachSimulationForStrength:DOMApproachTestStrengthSoft
                                   motionManager:self.motionManager
                                      completion:^{
                                        [self.motionManager stopListening];

                                        if (completionBlock) {
                                            completionBlock();
                                        }
                                      }];
    });
}

#pragma mark - Simulation

- (void)runSimulationCompletion:(void (^)(void))completionBlock {
    [self runPassiveApproachSimulation:^{
      [self runActiveApproachSimulation:^{
        if (completionBlock) {
            completionBlock();
        }
        self.motionManager = nil;
      }];
    }];
}

#pragma mark - Actions

- (void)refreshAction:(UIRefreshControl *)refreshControl {
    [refreshControl beginRefreshing];

    [self runSimulationCompletion:^{
      [refreshControl endRefreshing];
    }];
}

@end
