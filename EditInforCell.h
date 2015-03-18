//
//  EditInforCell.h
//  BinFenV10
//
//  Created by Wang Long on 2/11/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    UnknownType = -1,
    AddressInAddr = 0,
    PhoneInAddr,
    UsernameInAccout,
    PhoneInAccount,
    PasswordInAccount
} EditInfoCellType;

@interface EditInforCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
//@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIImageView *symbolImage;
@property (weak, nonatomic) IBOutlet UITextField *detailEdit;

@property (nonatomic) EditInfoCellType cellType;

@end
