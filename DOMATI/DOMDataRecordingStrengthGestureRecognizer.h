//
//  DOMDataRecordingStrengthGestureRecognizer.h
//  DOMATI
//
//  Created by Jad Osseiran on 27/02/2014.
//  Copyright (c) 2014 Jad. All rights reserved.
//

#import "DOMStrengthGestureRecognizer.h"

typedef void (^DOMCoreDataSave)(void);

@interface DOMDataRecordingStrengthGestureRecognizer : DOMStrengthGestureRecognizer

@property (nonatomic, readonly) BOOL saving;

- (void)setCoreDataSaveCompletionBlock:(DOMCoreDataSave)block;

@end
