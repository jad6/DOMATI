//
//  DOMThemeManager.m
//  DOMATI
//
//  Created by Jad Osseiran on 27/10/2013.
//  Copyright (c) 2013 Jad. All rights reserved.
//

#import "DOMThemeManager.h"

#import "DOMThemeResources.h"

#import "DOMTableViewCell.h"
#import "DOMTableView.h"
#import "DOMNavigationBar.h"

@implementation DOMThemeManager

+ (id<DOMTheme>)sharedTheme
{
    static __DISPATCH_ONCE__ id singletonObject = nil;

    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
                      // Create and return the theme: (This line should change in the future to change the theme)
                      singletonObject = [[DOMThemeResources alloc] init];
                  });

    return singletonObject;
}

+ (void)customiseAppAppearance
{
    [[UIToolbar appearance] setBarTintColor:BACKGROUND_COLOR];
    [[DOMNavigationBar appearance] setBarTintColor:BACKGROUND_COLOR];
    NSDictionary * navAttributes = @{ NSForegroundColorAttributeName : TEXT_COLOR };
    [[DOMNavigationBar appearance] setTitleTextAttributes:navAttributes];

    [[DOMTableView appearance] setBackgroundColor:BACKGROUND_COLOR];
    [[DOMTableViewCell appearance] setBackgroundColor:BACKGROUND_COLOR];

    [[UIPickerView appearance] setBackgroundColor:BACKGROUND_COLOR];

    [[UITextField appearance] setKeyboardAppearance:UIKeyboardAppearanceDark];
}

@end
