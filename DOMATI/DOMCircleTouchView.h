//
//  DOMCircleTouchView.h
//  DOMATI
//
//  Created by Jad Osseiran on 18/11/2013.
//  Copyright (c) 2013 Jad. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM (NSInteger, DOMCircleTouchStrength) {
    DOMCircleTouchStrengthNone          = 0,
    DOMCircleTouchStrengthHard          = 1,
    DOMCircleTouchStrengthModerate      = 2,
    DOMCircleTouchStrengthSoft          = 3
};

@interface DOMCircleTouchView : UIView

@property (nonatomic, strong) NSString *title;

@property (nonatomic) DOMCircleTouchStrength circleTouchStrength;

- (id)    initWithFrame:(CGRect)frame
    circleTouchStrength:(DOMCircleTouchStrength)circleTouchStrength;

@end
