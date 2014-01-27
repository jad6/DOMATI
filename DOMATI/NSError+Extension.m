//
//  NSError+Extension.m
//  DOMATI
//
//  Created by Jad Osseiran on 13/01/2014.
//  Copyright (c) 2014 Jad. All rights reserved.
//

#import "NSError+Extension.h"

@implementation NSError (Extension)

- (void)handle
{
#if DEBUG
    NSString *title = [[NSString alloc] initWithFormat:@"Error %li", (long)[self code]];
    NSString *message = [[NSString alloc] initWithFormat:@"%@ %@ %@", [self localizedDescription], [self localizedFailureReason], [self localizedRecoverySuggestion]];
    
    UIAlertView *errorAV = [[UIAlertView alloc] initWithTitle:title
                                                      message:message
                                                     delegate:nil
                                            cancelButtonTitle:@"Dismiss"
                                            otherButtonTitles:nil];
    [errorAV show];
#else
    NSLog(@"Error %li - %@ %@. %@", (long)[self code], [self localizedDescription], [self localizedFailureReason], [self localizedRecoverySuggestion]);
#endif
}

@end
