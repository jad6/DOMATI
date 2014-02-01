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

- (void)segmentedControl:(UISegmentedControl *)segmentedControl
         didChangeGender:(DOMGender)gender;

@end

@interface DOMGenderSegmentCell : DOMSegmentCell

@property (nonatomic, weak) id<DOMGenderSegmentCellDelegate> delegate;

@property (nonatomic) DOMGender selectedGender;

@end
