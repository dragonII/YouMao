//
//  UserInforTableViewCell.h
//  BinFenV10
//
//  Created by Wang Long on 2/11/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UserInforTableViewCell;
@protocol AvatarChangeDelegate <NSObject>

- (void)editClicked:(UserInforTableViewCell *)cell;

@end

@interface UserInforTableViewCell : UITableViewCell

@property (weak, nonatomic) id<AvatarChangeDelegate> editDelegate;

@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@end
