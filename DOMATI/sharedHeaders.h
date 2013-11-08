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

#define DOMATI_COLOR [UIColor orangeColor]
#define BACKGROUND_COLOR [UIColor colorWithRed:29.0f/255.0f green:31.0f/255.0f blue:33.0f/255.0f alpha:1.0f]
#define TEXT_COLOR [UIColor whiteColor]
#define SELECTION_COLOR [UIColor darkGrayColor]

#define DEFAULTS_CALI_EXPR_DURATION_DATA @"DOMCalibrationExipryDurationData"
#define DEFAULTS_CALI_EXPR_INDEX @"DOMCalibrationExipryIndex"
#define DEFAULTS_CALI_EXPR_TEXT @"DOMCalibrationExipryText"

#define DEFAULTS_UDID_TOUCH_DATA_VALUE_KEY @"DOMTouchDataUDIDKey"

#endif
