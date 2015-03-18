//
//  AddrsTableViewCell.h
//  BinFenV10
//
//  Created by Wang Long on 2/11/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddrsTableViewCell;
@protocol EditDeleteDelegate <NSObject>

- (void)editClicked:(AddrsTableViewCell *)cell;
- (void)deleteClicked:(AddrsTableViewCell *)cell;

@end

@interface AddrsTableViewCell : UITableViewCell

@property (weak, nonatomic) id<EditDeleteDelegate> editDeleteDelegate;

@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *addrLabel;

@property (weak, nonatomic) IBOutlet UIImageView *deleteImage;
@property (weak, nonatomic) IBOutlet UIImageView *editImage;


@end
