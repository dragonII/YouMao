//
//  CommunityForSelectionCell.m
//  BinFenV10
//
//  Created by Wang Long on 2/9/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import "CommunityForSelectionCell.h"

@interface CommunityForSelectionCell()

@end

@implementation CommunityForSelectionCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)tapDetected
{
    NSLog(@"single Tap on imageview");
    if([self.deleteHistoryDelegate respondsToSelector:@selector(deleteClickedInCell:)])
    {
        [self.deleteHistoryDelegate performSelector:@selector(deleteClickedInCell:) withObject:self];
    }
}

- (void)setCellType:(CommunityCellType)cellType
{
    if(_cellType != cellType)
    {
        _cellType = cellType;
        [_sourceLabel setHidden:_cellType == CommunityCellTypeHistory ];
    }
    if(_cellType == CommunityCellTypeHistory)
    {
        [_operationImage setImage:[UIImage imageNamed:@"DeleteInCell"]];
        [_operationImage setUserInteractionEnabled:YES];
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected)];
        singleTap.numberOfTapsRequired = 1;
        //[self.searchView setUserInteractionEnabled:YES];
        [_operationImage addGestureRecognizer:singleTap];
    }
    if(_cellType == CommunityCellTypeCurrent)
    {
        [_operationImage setImage:[UIImage imageNamed:@"Location"]];
    }
}

@end
