//
//  DOMCalibrationPresenter.m
//  DOMATI
//
//  Created by Jad Osseiran on 11/11/2013.
//  Copyright (c) 2013 Jad. All rights reserved.
//

#import "DOMCalibrationPresenter.h"

#import "DOMUserInfoViewController.h"

@implementation DOMCalibrationPresenter

+ (void)showCalibrationFromController:(UIViewController *)controller
                withTransitionStyle:(UIModalTransitionStyle)style
                           completion:(void (^)())completionBlock
{
    UINavigationController *calibrationNC = [controller.storyboard instantiateViewControllerWithIdentifier:@"DOMCalibrationNavController"];
    
    calibrationNC.modalTransitionStyle = style;
    calibrationNC.modalPresentationStyle = UIModalPresentationFormSheet;
    
    DOMUserInfoViewController *calibrationVC = (DOMUserInfoViewController *)calibrationNC.topViewController;
    calibrationVC.showDoneBarButton = YES;
    
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
                 showingDoneBarButton:(BOOL)showDoneBarButton
{
    DOMUserInfoViewController *calibrationVC = [controller.storyboard instantiateViewControllerWithIdentifier:@"DOMCalibrationViewController"];
    calibrationVC.showDoneBarButton = showDoneBarButton;
    
    [controller.navigationController pushViewController:calibrationVC animated:YES];
}

+ (void)pushCalibrationFromController:(UIViewController *)controller
{
    [self pushCalibrationFromController:controller showingDoneBarButton:NO];
}

@end
