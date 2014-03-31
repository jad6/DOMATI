//
//  DOMCalibrationPresenter.m
//  DOMATI
//
//  Created by Jad Osseiran on 11/11/2013.
//  Copyright (c) 2013 Jad. All rights reserved.
//

#import "DOMCalibrationPresenter.h"

#import "DOMCalibrationViewController.h"

@implementation DOMCalibrationPresenter

+ (void)showCalibrationFromController:(UIViewController *)controller
    withTransitionStyle:(UIModalTransitionStyle)style
    completion:(void (^)())completionBlock
{
    UINavigationController *calibrationNC = [controller.storyboard instantiateViewControllerWithIdentifier:@"DOMCalibrationNavController"];

    calibrationNC.modalTransitionStyle = style;
    calibrationNC.modalPresentationStyle = UIModalPresentationFormSheet;

    [controller presentViewController:calibrationNC animated:YES completion:completionBlock];
}

+ (void)showCalibrationFromController:(UIViewController *)controller
    completion:(void (^)())completionBlock
{
    [self showCalibrationFromController:controller
                    withTransitionStyle:UIModalTransitionStyleCoverVertical
                             completion:completionBlock];
}

+ (void)pushCalibrationFromController:(UIViewController *)controller
{
    DOMCalibrationViewController *calibrationVC = [controller.storyboard instantiateViewControllerWithIdentifier:@"DOMCalibrationViewController"];

    [controller.navigationController pushViewController:calibrationVC animated:YES];
}

@end
