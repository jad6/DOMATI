//
//  DOMSegmentCell.h
//  DOMATI
//
//  Created by Jad Osseiran on 17/11/2013.
//  Copyright (c) 2013 Jad. All rights reserved.
//

#import "DOMTableViewCell.h"

@interface DOMSegmentCell : DOMTableViewCell

@property (nonatomic, weak) IBOutlet UILabel * textLabel;
@property (nonatomic, weak) IBOutlet UISegmentedControl * segmentedControl;

@end
