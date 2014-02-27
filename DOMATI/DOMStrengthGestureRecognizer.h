//
//  DOMStrengthGestureRecognizer.h
//  DOMATI
//
//  Created by Jad Osseiran on 2/11/2013.
//  Copyright (c) 2013 Jad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CMDeviceMotion.h>

@interface DOMStrengthGestureRecognizer : UIGestureRecognizer

@property (nonatomic, readonly) CGFloat strength;

- (NSArray *)allPhasesInfoForTouch:(UITouch *)touch;
- (NSDictionary *)motionsInfoForTouch:(UITouch *)touch;

@end
