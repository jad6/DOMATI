//
//  DOMPreviewItem.h
//  DOMATI
//
//  Created by Jad Osseiran on 11/08/13.
//  Copyright (c) 2013 Jad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuickLook/QuickLook.h>

@interface DOMPreviewItem : NSObject <QLPreviewItem>

@property (strong, nonatomic) NSString * documentTitle;
@property (strong, nonatomic) NSURL * localURL;

@end
