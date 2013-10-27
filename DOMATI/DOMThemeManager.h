//
//  DOMThemeManager.h
//  DOMATI
//
//  Created by Jad Osseiran on 27/10/2013.
//  Copyright (c) 2013 Jad. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DOMTheme <NSObject>


@end

@interface DOMThemeManager : NSObject

+ (id<DOMTheme>)sharedTheme;
+ (void)customiseAppAppearance;

@end
