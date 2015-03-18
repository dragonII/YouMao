//
//  CommentTableViewCell.h
//  BinFenV10
//
//  Created by Wang Long on 2/9/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentTableViewCell : UITableViewCell

+ (CGSize)sizeOfTextViewForText:(NSString *)text;

- (void)setCommentText:(NSString *)text;
- (void)setCommentUser:(NSString *)user;

@end
