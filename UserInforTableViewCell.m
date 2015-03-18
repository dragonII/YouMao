//
//  UserInforTableViewCell.m
//  BinFenV10
//
//  Created by Wang Long on 2/11/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import "UserInforTableViewCell.h"

@interface UserInforTableViewCell()


@end

@implementation UserInforTableViewCell

-(void)editDetected
{
    if([self.editDelegate respondsToSelector:@selector(editClicked:)])
    {
        [self.editDelegate performSelector:@selector(editClicked:) withObject:self];
    }
}

- (void)addEditActionToUserImage
{
    UITapGestureRecognizer *avatarTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editDetected)];
    
    [self.userImage addGestureRecognizer:avatarTap];
}

- (void)awakeFromNib
{
    [self addEditActionToUserImage];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
