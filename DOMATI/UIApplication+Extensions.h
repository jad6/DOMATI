//
//  UIApplication+Extensions.h
//  Fight Rounds
//
//  Created by Jad Osseiran on 6/02/2014.
//  Copyright (c) 2014 Jad Osseiran. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIApplication (Extensions)

+ (NSString *)version;
+ (NSString *)build;

+ (NSString *)versionInformation;

+ (void)showLoading:(BOOL)loading;

@end
