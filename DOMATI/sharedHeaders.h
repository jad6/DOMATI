//
//  sharedHeaders.h
//  DOMATI
//
//  Created by Jad Osseiran on 29/10/2013.
//  Copyright (c) 2013 Jad. All rights reserved.
//

#ifndef DOMATI_sharedHeaders_h
#define DOMATI_sharedHeaders_h

#define IPAD ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
#define FIRST_LAUNCH ![[NSUserDefaults standardUserDefaults] boolForKey:@"DOMAlreadyLaunched"]

#define DOMATI_COLOR [UIColor orangeColor]
#define BACKGROUND_COLOR [UIColor colorWithRed:30.0f/255.0f green:30.0f/255.0f blue:30.0f/255.0f alpha:1.0f]
#define SELECTION_COLOR [UIColor darkGrayColor]
#define TEXT_COLOR [UIColor whiteColor]
#define DETAIL_TEXT_COLOR [UIColor lightGrayColor]

#define MALE_SWITCH_COLOR [UIColor blueColor]
#define FEMALE_SWITCH_COLOR [UIColor redColor]

#define DEFAULTS_CALI_EXPR_DURATION_DATA @"DOMCalibrationExipryDurationData"
#define DEFAULTS_CALI_EXPR_INDEX @"DOMCalibrationExipryIndex"
#define DEFAULTS_CALI_EXPR_TEXT @"DOMCalibrationExipryText"

#define DEFAULTS_UDID_TOUCH_DATA_VALUE_KEY @"DOMTouchDataUDIDKey"

#endif
