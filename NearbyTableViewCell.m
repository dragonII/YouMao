//
//  NearbyTableViewCell.m
//  BinFenV10
//
//  Created by Wang Long on 2/10/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import "NearbyTableViewCell.h"

@interface NearbyTableViewCell()

@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation NearbyTableViewCell

- (void)awakeFromNib
{
    [self.bgView.layer setCornerRadius:7.0f];
    [self.bgView.layer setMasksToBounds:YES];
    [self.bgView.layer setShouldRasterize:YES];
    [self.bgView.layer setRasterizationScale:[UIScreen mainScreen].scale];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
