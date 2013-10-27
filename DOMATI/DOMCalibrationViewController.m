//
//  DOMCalibrationViewController.m
//  DOMATI
//
//  Created by Jad Osseiran on 13/08/13.
//  Copyright (c) 2013 Jad. All rights reserved.
//

#import "DOMCalibrationViewController.h"

#import "DOMFingerCell.h"

#import "UIImage+ImageEffects.h"

@interface DOMCalibrationViewController ()

@property (strong, nonatomic) NSArray *fingerSizesData;

@end

@implementation DOMCalibrationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.fingerSizesData = [[NSArray alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"FingerSizes" withExtension:@"plist"]];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (IBAction)dissmiss:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Setter & Getters

- (void)setBackgroundImage:(UIImage *)backgroundImage
{
    if (_backgroundImage != backgroundImage) {
        _backgroundImage = backgroundImage;
    }
    
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    backgroundImageView.image = [backgroundImage applyDarkEffect];
    self.collectionView.backgroundView = backgroundImageView;
}

#pragma mark - Collection View

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.fingerSizesData count];
}

- (DOMFingerCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DOMFingerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Finger Cell" forIndexPath:indexPath];
    
    NSDictionary *fingerData = self.fingerSizesData[indexPath.row];
    
    cell.titleLabel.text = fingerData[@"title"];
    cell.imageView.backgroundColor = DOMATI_COLOR;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self dissmiss:nil];
}

@end
