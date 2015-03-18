//
//  CommentCartCell.m
//  BinFenV10
//
//  Created by Wang Long on 3/2/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import "CommentCartCell.h"

@implementation CommentCartCell

- (void)awakeFromNib
{
    // Initialization code
    self.commentTextField.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{

}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"Text Return");
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if([self.editDelegate respondsToSelector:@selector(editClicked:)])
    {
        [self.editDelegate performSelector:@selector(editClicked:) withObject:self];
    }
}

@end
