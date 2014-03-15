//
//  DOMDataRecordingStrengthGestureRecognizer.h
//  DOMATI
//
//  Created by Jad Osseiran on 27/02/2014.
//  Copyright (c) 2014 Jad. All rights reserved.
//

#import "DOMStrengthGestureRecognizer.h"

// Define the saving post block format.
typedef void (^DOMCoreDataSave)(void);

@interface DOMDataRecordingStrengthGestureRecognizer : DOMStrengthGestureRecognizer

/// Flag determining if there is a current save operation happening.
@property (nonatomic, readonly) BOOL saving;

/**
 *  Method to set the completion block code to be executed once
 *  every threaded Core Data context has been saved.
 *
 *  @param block The code to be executed after the save.
 */
- (void)setCoreDataSaveCompletionBlock:(DOMCoreDataSave)block;

@end
