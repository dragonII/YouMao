//
//  AddrsTableViewCell.m
//  BinFenV10
//
//  Created by Wang Long on 2/11/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import "AddrsTableViewCell.h"

@implementation AddrsTableViewCell


-(void)editDetected
{
    //NSLog(@"single Tap on imageview");
    if([self.editDeleteDelegate respondsToSelector:@selector(editClicked:)])
    {
        [self.editDeleteDelegate performSelector:@selector(editClicked:) withObject:self];
    }
}

- (void)deleteDetected
{
    if([self.editDeleteDelegate respondsToSelector:@selector(deleteClicked:)])
    {
        [self.editDeleteDelegate performSelector:@selector(deleteClicked:) withObject:self];
    }
}


- (void)initImageViews
{
    UITapGestureRecognizer *editTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editDetected)];
    UITapGestureRecognizer *deleteTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteDetected)];
    [self.editImage setUserInteractionEnabled:YES];
    [self.deleteImage setUserInteractionEnabled:YES];
    
    [self.editImage addGestureRecognizer:editTap];
    [self.deleteImage addGestureRecognizer:deleteTap];
}

- (void)awakeFromNib
{
    [self initImageViews];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
