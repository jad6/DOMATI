//
//  DOMCalibrationPresenter.h
//  DOMATI
//
//  Created by Jad Osseiran on 11/11/2013.
//  Copyright (c) 2013 Jad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DOMCalibrationPresenter : NSObject

+ (void)showCalibrationFromController:(UIViewController *)controller
                  withTransitionStyle:(UIModalTransitionStyle)style
                           completion:(void (^)())completionBlock;

+ (void)showCalibrationFromController:(UIViewController *)controller
                           completion:(void (^)())completionBlock;

+ (void)pushCalibrationFromController:(UIViewController *)controller;

@end
