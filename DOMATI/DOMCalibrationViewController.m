//
//  DOMCalibrationViewController.m
//  DOMATI
//
//  Created by Jad Osseiran on 1/02/2014.
//  Copyright (c) 2014 Jad. All rights reserved.
//

#import "DOMCalibrationViewController.h"

#import "DOMStrengthGestureRecognizer.h"

#import "DOMCircleTouchView.h"

#import "DOMRequestOperationManager.h"
#import "DOMLocalNotificationHelper.h"

#define MIN_TOUCH_SETS_WANTED 3
#define ANIMATION_DURATION 0.3

// The state in which the view controller is currently in.
typedef NS_ENUM(NSInteger, DOMCalibrationState) {
    DOMCalibrationStateInitial,
    DOMCalibrationStateModerateTouch,
    DOMCalibrationStateSoftTouch,
    DOMCalibrationStateHardTouch,
    DOMCalibrationStateFinal
};

@interface DOMCalibrationViewController () 

// The views which have been setup in the storyboard.
@property (nonatomic, weak) IBOutlet DOMCircleTouchView *circleTouchView;
@property (nonatomic, weak) IBOutlet UILabel *topLabel, *bottomLabel;

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
    DOMStrengthGestureRecognizer *strengthGR = [[DOMStrengthGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
    [self.circleTouchView addGestureRecognizer:strengthGR];
    
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
    if (self->_state != state) {
        self->_state = state;
    }
    
    [self setViewForState:state
                 animated:(state != DOMCalibrationStateInitial)];
}

- (BOOL)canBecomeFirstResponder
{
    // To allow shaking events.
    return YES;
}

#pragma mark - Actions

/**
 *  When a tap is detected move along a state.
 *
 *  @param strengthGR The strength gesture recogniser.
 */
- (void)tapDetected:(DOMStrengthGestureRecognizer *)strengthGR
{
    // Only move states when in the appropriate current state.
    if (self.state > DOMCalibrationStateInitial &&
        self.state < DOMCalibrationStateFinal) {
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
    if (animated) {
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
    if (animated) {
        [UIView animateWithDuration:ANIMATION_DURATION animations:^{
            view.alpha = alpha;
        }];
    } else {
        view.alpha = alpha;
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
    
    [self setAlpha:circleTouchAlpha
            onView:self.circleTouchView
          animated:animated];
    
    [self setText:topText
          onLabel:self.topLabel
         animated:animated];
    [self setText:bottomText
          onLabel:self.bottomLabel
         animated:animated];
    
    // If the apha on the circle touch view is not 100%, disable it.
    self.circleTouchView.userInteractionEnabled = (circleTouchAlpha == 1.0);
    
    // Handle the final state.
    if (state == DOMCalibrationStateFinal) {
        // Increment the saved number of calibration the user has made
        // on the device.
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSInteger numTouchSets = [[defaults objectForKey:DEFAULTS_TOUCH_SETS_RECORDED] integerValue];
        numTouchSets++;
        
        // If the user has not done enough calibrations setup a local notification.
        if (numTouchSets < MIN_TOUCH_SETS_WANTED) {
            [DOMLocalNotificationHelper schedualLocalNotification];
        }
        
        // Save the new calibration number value.
        [defaults setObject:@(numTouchSets) forKey:DEFAULTS_TOUCH_SETS_RECORDED];
        [defaults synchronize];
        
        // Attempt to upload the new (and possibly old data).
        [[DOMRequestOperationManager sharedManager] uploadDataWhenPossible];
    }
}

#pragma mark - Shaking

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    // If the shake was detected and the user is in the initial state
    // move to the next state.
    if (self.state == DOMCalibrationStateInitial &&
        motion == UIEventSubtypeMotionShake) {
        self.state = DOMCalibrationStateModerateTouch;
    }
}

@end
