//
//  DOMGenderSegmentCell.h
//  DOMATI
//
//  Created by Jad Osseiran on 17/11/2013.
//  Copyright (c) 2013 Jad. All rights reserved.
//

#import "DOMSegmentCell.h"

typedef NS_ENUM(NSInteger, DOMGender) {
    DOMGenderUndisclosed,
    DOMGenderMale,
    DOMGenderFemale
};

@interface DOMGenderSegmentCell : DOMSegmentCell

@property (nonatomic) DOMGender selectedGender;

@end
