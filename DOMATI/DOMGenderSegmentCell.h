//
//  DOMGenderSegmentCell.h
//  DOMATI
//
//  Created by Jad Osseiran on 17/11/2013.
//  Copyright (c) 2013 Jad. All rights reserved.
//

#import "DOMSegmentCell.h"

#import "DOMUser.h"

@protocol DOMGenderSegmentCellDelegate <NSObject>

/**
 *  The segment control did select a new gender.
 *
 *  @param segmentedControl The gender segmented control
 *  @param gender           The newly selected gender.
 */
- (void)segmentedControl:(UISegmentedControl *)segmentedControl
    didChangeGender:(DOMGender)gender;

@end

@interface DOMGenderSegmentCell : DOMSegmentCell

@property (nonatomic, weak) id<DOMGenderSegmentCellDelegate> delegate;

@property (nonatomic, weak) IBOutlet UILabel * titleLabel;

@property (nonatomic) DOMGender selectedGender;

@end
