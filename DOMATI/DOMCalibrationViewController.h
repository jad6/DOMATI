//
//  DOMCalibrationViewController.h
//  DOMATI
//
//  Created by Jad Osseiran on 1/02/2014.
//  Copyright (c) 2014 Jad. All rights reserved.
//

#import <UIKit/UIKit.h>

// The state in which the view controller is currently in.
typedef NS_ENUM(NSInteger, DOMCalibrationState) {
    DOMCalibrationStateNone = -1,
    DOMCalibrationStateInitial,
    DOMCalibrationStateModerateTouch,
    DOMCalibrationStateSoftTouch,
    DOMCalibrationStateHardTouch,
    DOMCalibrationStateFinal
};

static NSString *kCalibrationStateChangeNotificationName = @"DOMCalibrationSateChangeNotification";

@interface DOMCalibrationViewController : UIViewController

@end
