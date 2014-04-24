//  DOMMainViewController.m
//  DOMATI
// 
//  Created by Jad on 22/04/2014.
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

#import "DOMMainViewController.h"

#import "DOMCircleView.h"

static NSString *const kBottomCollisionBoundaryIdentifer = @"Bottom Boundary";

@interface DOMMainViewController () <DOMCircleViewDelegate, UICollisionBehaviorDelegate>

@property (nonatomic, weak) IBOutlet UIButton *infoButton;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) UIDynamicAnimator *animator;

@end

@implementation DOMMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.75
                                                  target:self
                                                selector:@selector(dropNewCircleAction:)
                                                userInfo:nil
                                                 repeats:YES];
    
    UIDynamicAnimator *animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];

    UIGravityBehavior *gravityBehavior = [[UIGravityBehavior alloc] init];
    gravityBehavior.magnitude = 0.2f;
    [animator addBehavior:gravityBehavior];
    
    UICollisionBehavior *collisionBehavior = [[UICollisionBehavior alloc] init];
    [collisionBehavior addBoundaryWithIdentifier:kBottomCollisionBoundaryIdentifer fromPoint:CGPointMake(0.0, CGRectGetMaxY(self.view.frame)) toPoint:CGPointMake(CGRectGetMaxX(self.view.frame), CGRectGetMaxY(self.view.frame))];
    [animator addBehavior:collisionBehavior];
    
    UIDynamicItemBehavior *itemBehavior = [[UIDynamicItemBehavior alloc] init];
    [itemBehavior setElasticity:0.0];
    [animator addBehavior:itemBehavior];
    [collisionBehavior setCollisionDelegate:self];
    
    self.animator = animator;
}

#pragma mark - Status Bar

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - Actions

- (void)dropNewCircleAction:(id)sender
{
    CGRect circleFrame = [self frameForNewCircleView];
    DOMCircleViewType randomType = [self randomCircleType];
    DOMCircleView *circleView = [[DOMCircleView alloc] initWithFrame:circleFrame andType:randomType delegate:self];
    
    [self.view insertSubview:circleView belowSubview:self.infoButton];
    
    UIDynamicAnimator *animator = self.animator;
    
    for (id behaviour in animator.behaviors)
    {
        if ([behaviour respondsToSelector:@selector(addItem:)])
            [(UIGravityBehavior *)behaviour addItem:circleView];
    }
}

#pragma mark - Logic

- (DOMCircleViewType)randomCircleType
{
    return arc4random_uniform(3);
}

- (CGRect)frameForNewCircleView
{
    CGSize size = CGSizeMake(80.0f, 80.0f);
    NSUInteger randomX = arc4random_uniform(self.view.frame.size.width - size.width);
    
    return CGRectMake(randomX, 20.0f, size.width, size.height);
}

- (void)removeCircleView:(DOMCircleView *)circleView
{
    __block DOMCircleView *subview = circleView;
    [UIView animateWithDuration:0.3 animations:^{
        
        subview.alpha = 0.0;
    } completion:^(BOOL finished) {
        for (id behaviour in self.animator.behaviors)
        {
            if ([behaviour respondsToSelector:@selector(removeItem:)])
                [(UIGravityBehavior *)behaviour removeItem:subview];
        }
        
        [subview removeFromSuperview];
        subview = nil;
    }];
}

#pragma mark - Circle View

- (void)circleView:(DOMCircleView *)circleView
      didGetTapped:(BOOL)validTap
{
    if (validTap)
        [self removeCircleView:circleView];
}

#pragma mark - Collision

- (void)collisionBehavior:(UICollisionBehavior *)behavior
      endedContactForItem:(id<UIDynamicItem>)item
   withBoundaryIdentifier:(id<NSCopying>)identifier
{
    [self removeCircleView:(DOMCircleView *)item];
}

@end
