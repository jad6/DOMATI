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

#define DOMATI_COLOR [UIColor colorWithRed:181.0f/255.0f green:189.0f/255.0f blue:104.0f/255.0f alpha:1.0f]
#define BACKGROUND_COLOR [UIColor colorWithRed:29.0f/255.0f green:31.0f/255.0f blue:33.0f/255.0f alpha:1.0f]
#define TEXT_COLOR [UIColor colorWithRed:196.0f/255.0f green:200.0f/255.0f blue:198.0f/255.0f alpha:1.0f]
#define SELECTION_COLOR [UIColor colorWithRed:150.0f/255.0f green:152.0f/255.0f blue:150.0f/255.0f alpha:1.0f]

#define DEFAULTS_CALI_EXPR_DURATION_DATA @"DOMCalibrationExipryDurationData"
#define DEFAULTS_CALI_EXPR_INDEX @"DOMCalibrationExipryIndex"
#define DEFAULTS_CALI_EXPR_TEXT @"DOMCalibrationExipryText"

#endif
