//
//  DOMStrengthGestureRecognizer.h
//  DOMATI
//
//  Created by Jad Osseiran on 2/11/2013.
//  Copyright (c) 2013 Jad. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DOMStrengthGestureRecognizer : UIGestureRecognizer

@property (nonatomic, readonly) CGFloat strength;

#ifdef DEBUG
@property (nonatomic, readonly) CGFloat averageAcceleration;
@property (nonatomic, readonly) CGFloat averageRotation;
@property (nonatomic, readonly) CGFloat touchRadius;
@property (nonatomic, readonly) NSTimeInterval duration;
#endif

@end
