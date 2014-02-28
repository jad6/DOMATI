//
//  UIDevice+Extension.m
//  DOMATI
//
//  Created by Jad Osseiran on 27/02/2014.
//  Copyright (c) 2014 Jad. All rights reserved.
//

#import "UIDevice+Extension.h"

#import <sys/utsname.h>

@implementation UIDevice (Extension)

- (NSString *)modelDetailed
{
    struct utsname systemInfo;
    uname(&systemInfo);
    
    return [NSString stringWithCString:systemInfo.machine
                              encoding:NSUTF8StringEncoding];
}

@end
