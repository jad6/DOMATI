//
//  sharedHeaders.h
//  DOMATI
//
//  Created by Jad Osseiran on 29/10/2013.
//  Copyright (c) 2013 Jad. All rights reserved.
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

#ifndef DOMATI_sharedHeaders_h
#define DOMATI_sharedHeaders_h

#define IPAD                             ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
#define FIRST_LAUNCH                     ![[NSUserDefaults standardUserDefaults] boolForKey:@"DOMAlreadyLaunched"]

#define DOMATI_COLOR                     [UIColor orangeColor]
#define BACKGROUND_COLOR                 [UIColor colorWithRed:30.0 / 255.0 green:30.0 / 255.0 blue:30.0 / 255.0 alpha:1.0]
#define SELECTION_COLOR                  [UIColor darkGrayColor]
#define TEXT_COLOR                       [UIColor whiteColor]
#define DETAIL_TEXT_COLOR                [UIColor lightGrayColor]

#define KEYSTORE_CALI_EXPR_DURATION_DATA @"DOMCalibrationExipryDurationData"
#define KEYSTORE_CALI_EXPR_INDEX         @"DOMCalibrationExipryIndex"
#define KEYSTORE_CALI_EXPR_TEXT          @"DOMCalibrationExipryText"

#define DEFAULTS_SKIP_TO_CALI            @"DOMSkipToCalibration"
#define DEFAULTS_TOUCH_SETS_RECORDED     @"DOMNumTouchSetsRecorded"
#define DEFAULTS_NEGATIVE_IDENTIFIER     @"DOMNegativeIdentifierKey"

#endif
