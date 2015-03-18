//
//  MessageListCell.m
//  BinFenV10
//
//  Created by Wang Long on 2/13/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import "ConversationListCell.h"

@implementation ConversationListCell

- (void)setImageRadius:(CGFloat)radius ImageView:(UIImageView *)imageView
{
    // Performance
    imageView.layer.cornerRadius = radius;
    imageView.layer.masksToBounds = NO;
    imageView.layer.shouldRasterize = YES;
    imageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    /////
    imageView.layer.borderWidth = 1.0f;
    imageView.layer.borderColor = [UIColor whiteColor].CGColor;
    imageView.clipsToBounds = YES;
    imageView.alpha = 0.8f;
}

- (void)awakeFromNib
{
    [self setImageRadius:3.0f ImageView:self.userImage];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
