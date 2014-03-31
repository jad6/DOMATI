//
//  DOMGroupSelectionViewController.m
//  DOMATI
//
//  Created by Jad Osseiran on 13/08/13.
//  Copyright (c) 2013 Jad. All rights reserved.
//

#import "DOMGroupSelectionViewController.h"

#import "DOMCalibrationPresenter.h"

#import "DOMFingerCell.h"

@interface DOMGroupSelectionViewController ()

@property (strong, nonatomic) NSArray *fingerSizesData;

@end

@implementation DOMGroupSelectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.collectionView.backgroundColor = BACKGROUND_COLOR;
    self.fingerSizesData = [[NSArray alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"Groups" withExtension:@"plist"]];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - Actions

- (IBAction)dissmiss:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)calibrate:(id)sender
{
    [DOMCalibrationPresenter pushCalibrationFromController:self];
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
