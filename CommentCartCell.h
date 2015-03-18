//
//  CommentCartCell.h
//  BinFenV10
//
//  Created by Wang Long on 3/2/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CommentCartCell;

@protocol CommentEditDelegate <NSObject>

- (void)editClicked:(CommentCartCell *)cell;

@end

@interface CommentCartCell : UITableViewCell <UITextFieldDelegate>

@property (weak, nonatomic) id<CommentEditDelegate> editDelegate;

@property (weak, nonatomic) IBOutlet UITextField *commentTextField;

@end
