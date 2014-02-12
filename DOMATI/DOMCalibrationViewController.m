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

#import "DOMLocalNotificationHelper.h"

#define MIN_TOUCH_SETS_WANTED 3
#define ANIMATION_DURATION 0.3

typedef NS_ENUM(NSInteger, DOMCalibrationState) {
    DOMCalibrationStateInitial,
    DOMCalibrationStateModerateTouch,
    DOMCalibrationStateSoftTouch,
    DOMCalibrationStateHardTouch,
    DOMCalibrationStateFinal
};

@interface DOMCalibrationViewController () 

@property (nonatomic, weak) IBOutlet DOMCircleTouchView *circleTouchView;

@property (nonatomic, weak) IBOutlet UILabel *topLabel, *bottomLabel;

@property (nonatomic, strong) NSArray *statesInformation;

@property (nonatomic) DOMCalibrationState state;

@end

@implementation DOMCalibrationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
        
    self.view.backgroundColor = [UIColor blackColor];
    
    DOMStrengthGestureRecognizer *strengthGR = [[DOMStrengthGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
    [self.circleTouchView addGestureRecognizer:strengthGR];
    
    self.circleTouchView.circleTouchStrength = DOMCircleTouchStrengthModerate;
    self.state = DOMCalibrationStateInitial;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
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

- (NSArray *)statesInformation
{
    if (!self->_statesInformation) {
        self->_statesInformation = [[NSArray alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"CalibrationStates" withExtension:@"plist"]];
    }
    
    return self->_statesInformation;
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

#pragma mark - Actions

- (void)tapDetected:(DOMStrengthGestureRecognizer *)strengthGR
{
    if (self.state > DOMCalibrationStateInitial &&
        self.state < DOMCalibrationStateFinal) {
        self.state++;
    }
}

#pragma mark - Logic

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

- (void)setViewForState:(DOMCalibrationState)state animated:(BOOL)animated
{
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
    
    self.circleTouchView.userInteractionEnabled = (circleTouchAlpha == 1.0);
    
    if (state == DOMCalibrationStateFinal) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSInteger numTouchSets = [[defaults objectForKey:DEFAULTS_TOUCH_SETS_RECORDED] integerValue];
        
        numTouchSets++;
        
        if (numTouchSets < MIN_TOUCH_SETS_WANTED) {
            [DOMLocalNotificationHelper schedualLocalNotification];
        }
        
        [defaults setObject:@(numTouchSets) forKey:DEFAULTS_TOUCH_SETS_RECORDED];
        [defaults synchronize];
    }
}

#pragma mark - Shaking

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (self.state == DOMCalibrationStateInitial &&
        motion == UIEventSubtypeMotionShake) {
        self.state = DOMCalibrationStateModerateTouch;
    }
}

@end
