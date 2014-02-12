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
#define BACKGROUND_COLOR [UIColor colorWithRed:30.0/255.0 green:30.0/255.0 blue:30.0/255.0 alpha:1.0]
#define SELECTION_COLOR [UIColor darkGrayColor]
#define TEXT_COLOR [UIColor whiteColor]
#define DETAIL_TEXT_COLOR [UIColor lightGrayColor]

#define KEYSTORE_CALI_EXPR_DURATION_DATA @"DOMCalibrationExipryDurationData"
#define KEYSTORE_CALI_EXPR_INDEX @"DOMCalibrationExipryIndex"
#define KEYSTORE_CALI_EXPR_TEXT @"DOMCalibrationExipryText"

#define DEFAULTS_SKIP_TO_CALI @"DOMSkipToCalibration"
#define DEFAULTS_TOUCH_SETS_RECORDED @"DOMNumTouchSetsRecorded"
#define DEFAULTS_NEGATIVE_IDENTIFIER @"DOMNegativeIdentifierKey"

#endif
