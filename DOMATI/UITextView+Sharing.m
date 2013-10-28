//
//  UITextView+Sharing.m
//  DOMATI
//
//  Created by Jad Osseiran on 28/10/2013.
//  Copyright (c) 2013 Jad. All rights reserved.
//

#import "UITextView+Sharing.h"

@implementation UITextView (Sharing)

- (void)shareContentInController:(id)controller
{
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:@[self.text] applicationActivities:nil];
    
    activityVC.excludedActivityTypes = @[UIActivityTypePostToWeibo, UIActivityTypeAssignToContact, UIActivityTypeAddToReadingList, UIActivityTypeSaveToCameraRoll, UIActivityTypePostToFacebook,  UIActivityTypePostToTwitter, UIActivityTypeMessage, UIActivityTypePostToFlickr, UIActivityTypePostToVimeo, UIActivityTypePostToTencentWeibo];
    
    activityVC.completionHandler = ^(NSString *activityType, BOOL completed) {
        NSLog(@" activityType: %@", activityType);
        NSLog(@" completed: %i", completed);
    };
    
    [controller presentViewController:activityVC animated:YES completion:nil];
}

@end
