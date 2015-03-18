//
//  DescriptionTableCell.m
//  BinFenV10
//
//  Created by Wang Long on 2/9/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import "DescriptionTableCell.h"

@interface DescriptionTableCell()

@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;

@end

@implementation DescriptionTableCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDescriptionString:(NSString *)descriptionString
{
    if(![_descriptionString isEqualToString:descriptionString])
    {
        _descriptionString = [descriptionString copy];
        
        _descriptionTextView.text = _descriptionString;
    }
}

@end
