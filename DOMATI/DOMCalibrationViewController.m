//
//  DOMCalibrationViewController.m
//  DOMATI
//
//  Created by Jad Osseiran on 1/02/2014.
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

#import "DOMCalibrationViewController.h"

#import "DOMDataRecordingStrengthGestureRecognizer.h"

#import "DOMCircleTouchView.h"

#import "DOMRequestOperationManager.h"
#import "DOMLocalNotificationHelper.h"

#define MIN_TOUCH_SETS_WANTED 3
#define ANIMATION_DURATION    0.3

@interface DOMCalibrationViewController ()

// The views which have been setup in the storyboard.
@property (nonatomic, weak) IBOutlet DOMCircleTouchView *circleTouchView;
@property (nonatomic, weak) IBOutlet UILabel *topLabel, *bottomLabel;

@property (nonatomic, strong) DOMDataRecordingStrengthGestureRecognizer *strengthGR;

// An array to store information about wach states.
@property (nonatomic, strong) NSArray *statesInformation;

// The current state in which the controller is.
@property (nonatomic) DOMCalibrationState state;

@end

@implementation DOMCalibrationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];

    // Add the strength gesture recognizer to the circle view.
    DOMDataRecordingStrengthGestureRecognizer *strengthGR = [[DOMDataRecordingStrengthGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
    [self.circleTouchView addGestureRecognizer:strengthGR];
    self.strengthGR = strengthGR;

    __weak __typeof(self) weakSelf = self;
    [strengthGR setCoreDataSaveCompletionBlock:^{
         __strong __typeof(weakSelf) strongSelf = weakSelf;

         if (strongSelf.state >= DOMCalibrationStateFinal &&
             !strongSelf.strengthGR.saving)
         {

             // Attempt to upload the new (and possibly old data).
             [[DOMRequestOperationManager sharedManager] uploadDataWhenPossibleWithCompletion:^(BOOL success) {
                  NSDictionary *stateInfo = self.statesInformation[DOMCalibrationStateFinal];

                  if (success)
                  {
                      self.topLabel.text = stateInfo[@"topText"];
                  }
                  else
                  {
                      self.topLabel.text = @"Thank you, your touch & device motion data will be uploaded when you are next connected to the Internet and re-launch the app.";
                  }

                  self.bottomLabel.text = stateInfo[@"bottomText"];
              } showHudInView:strongSelf.view];
         }
     }];

    self.statesInformation = [[NSArray alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"CalibrationStates" withExtension:@"plist"]];

    // Set the initial states.
    self.circleTouchView.circleTouchStrength = DOMCircleTouchStrengthModerate;
    self.state = DOMCalibrationStateInitial;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    // Used so the view controller responds to the device shakes.
    [self becomeFirstResponder];
}

- (void)setState:(DOMCalibrationState)state
{
    if (self->_state != state)
    {
        self->_state = state;
    }

    [self setViewForState:state
                 animated:(state != DOMCalibrationStateInitial)];

    // Handle the final state.
    if (state == DOMCalibrationStateFinal)
    {
        // Increment the saved number of calibration the user has made
        // on the device.
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSInteger numTouchSets = [[defaults objectForKey:DEFAULTS_TOUCH_SETS_RECORDED] integerValue];
        numTouchSets++;

        // If the user has not done enough calibrations setup a local notification.
        if (numTouchSets < MIN_TOUCH_SETS_WANTED)
        {
            [DOMLocalNotificationHelper schedualLocalNotification];
        }

        // Save the new calibration number value.
        [defaults setObject:@(numTouchSets) forKey:DEFAULTS_TOUCH_SETS_RECORDED];
        [defaults synchronize];
    }
}

- (BOOL)canBecomeFirstResponder
{
    // To allow shaking events.
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [self.strengthGR resetMotionCache];
}

#pragma mark - Actions

/**
 *  When a tap is detected move along a state.
 *
 *  @param strengthGR The strength gesture recogniser.
 */
- (void)tapDetected:(DOMStrengthGestureRecognizer *)strengthGR
{
    NSNotification *stateNotif = [[NSNotification alloc] initWithName:kCalibrationStateChangeNotificationName object:self userInfo:@{ @"state" : @(self.state) }];

    [[NSNotificationCenter defaultCenter] postNotification:stateNotif];

    // Only move states when in the appropriate current state.
    if (self.state > DOMCalibrationStateInitial &&
        self.state < DOMCalibrationStateFinal)
    {
        self.state++;
    }
}

#pragma mark - Logic

/**
 *  Sets text on a pass label.
 *
 *  @param text     The text to be on the label.
 *  @param label    The label to modify.
 *  @param animated Wether the change is animated.
 */
- (void)setText:(NSString *)text
        onLabel:(UILabel *)label
       animated:(BOOL)animated
{
    if (animated)
    {
        CATransition *animation = [CATransition animation];
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.type = kCATransitionFade;
        animation.duration = ANIMATION_DURATION;

        [label.layer addAnimation:animation forKey:@"kCATransitionFade"];
    }

    label.text = text;
}

/**
 *  Sets the alpha of a view.
 *
 *  @param alpha    The alpha to set.
 *  @param view     The view to modify.
 *  @param animated Wether the change is animated.
 */
- (void)setAlpha:(CGFloat)alpha
          onView:(UIView *)view
        animated:(BOOL)animated
{
    if (animated)
    {
        [UIView animateWithDuration:ANIMATION_DURATION animations:^{
             view.alpha = alpha;
         }];
    }
    else
    {
        view.alpha = alpha;
    }
}

- (void)setTitleOnCircleView:(DOMCircleTouchView *)circleView
                    forState:(DOMCalibrationState)state
{
    switch (state)
    {
        case DOMCalibrationStateModerateTouch:
            circleView.circleTouchStrength = DOMCircleTouchStrengthModerate;
            break;

        case DOMCalibrationStateSoftTouch:
            circleView.circleTouchStrength = DOMCircleTouchStrengthSoft;
            break;

        case DOMCalibrationStateHardTouch:
            circleView.circleTouchStrength = DOMCircleTouchStrengthHard;
            break;

        default:
            circleView.circleTouchStrength = DOMCircleTouchStrengthNone;
            break;
    }
}

/**
 *  Changes the view according to the state.
 *
 *  @param state    The state to change the view for.
 *  @param animated Wether the chage is animated.
 */
- (void)setViewForState:(DOMCalibrationState)state animated:(BOOL)animated
{
    // Get the new state info.
    NSDictionary *stateInfo = self.statesInformation[state];

    CGFloat circleTouchAlpha = [stateInfo[@"circleViewAlpha"] floatValue];
    NSString *topText = stateInfo[@"topText"];
    NSString *bottomText = stateInfo[@"bottomText"];

    if (state == DOMCalibrationStateFinal)
    {
        topText = @"Thank you, touch & device motion data is being uploaded.";
        bottomText = nil;
    }

    [self setAlpha:circleTouchAlpha
            onView:self.circleTouchView
          animated:animated];

    [self setText:topText
          onLabel:self.topLabel
         animated:animated];
    [self setText:bottomText
          onLabel:self.bottomLabel
         animated:animated];

    [self setTitleOnCircleView:self.circleTouchView
                      forState:self.state];

    // If the apha on the circle touch view is not 100%, disable it.
    self.circleTouchView.userInteractionEnabled = (circleTouchAlpha == 1.0);
}

#pragma mark - Shaking

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    // If the shake was detected and the user is in the initial state
    // move to the next state.
    if (self.state == DOMCalibrationStateInitial &&
        motion == UIEventSubtypeMotionShake)
    {
        self.state = DOMCalibrationStateModerateTouch;
    }
}

@end
