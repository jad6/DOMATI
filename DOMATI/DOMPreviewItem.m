//
//  DOMPreviewItem.m
//  DOMATI
//
//  Created by Jad Osseiran on 11/08/13.
//  Copyright (c) 2013 Jad. All rights reserved.
//

#import "DOMPreviewItem.h"

@implementation DOMPreviewItem

@synthesize previewItemTitle = _previewItemTitle;
@synthesize previewItemURL = _previewItemURL;

- (NSString *)previewItemTitle
{
    if (!_previewItemTitle) {
        _previewItemTitle = self.documentTitle;
    }
    
    return _previewItemTitle;
}

- (NSURL *)previewItemURL
{
    if (!_previewItemURL) {
        _previewItemURL = self.localURL;
    }
    
    return _previewItemURL;
}

@end
