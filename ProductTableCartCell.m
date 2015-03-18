//
//  ProductTableCartCell.m
//  BinFenV10
//
//  Created by Wang Long on 3/2/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import "ProductTableCartCell.h"

@implementation ProductTableCartCell

- (void)itemTapped
{
    if([self.itemCheckedDelegate respondsToSelector:@selector(productItemChecked:)])
    {
        [self.itemCheckedDelegate performSelector:@selector(productItemChecked:) withObject:self];
    }
}

- (void)awakeFromNib
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemTapped)];
    [self.itemCheckImage setUserInteractionEnabled:YES];
    [self.itemCheckImage addGestureRecognizer:tapGesture];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)decreaseClicked:(id)sender
{
    NSLog(@"Decrease");
}

- (IBAction)increaseClicked:(id)sender
{
    NSLog(@"Increase");
}
@end
