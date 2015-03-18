//
//  EditInforCell.m
//  BinFenV10
//
//  Created by Wang Long on 2/11/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import "EditInforCell.h"

@implementation EditInforCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)enableDetailEditWithText:(NSString *)text
{
    self.detailEdit.enabled = YES;
    self.detailEdit.text = @"";
    self.detailEdit.placeholder = text;
    self.symbolImage.hidden = YES;
}

- (void)disableDetailEditWithText:(NSString *)text
{
    self.detailEdit.enabled = NO;
    self.detailEdit.placeholder = @"";
    self.detailEdit.text = text;
    self.symbolImage.hidden = NO;
}

- (void)setCellType:(EditInfoCellType)cellType
{
    switch (cellType)
    {
        case PhoneInAddr:
        {
            self.titleLabel.text = @"电话：";
            [self enableDetailEditWithText:@"配送员联系您的电话"];
            break;
        }
        
        case AddressInAddr:
        {
            self.titleLabel.text = @"地址：";
            [self enableDetailEditWithText:@"请填写详细的送货地址"];
            break;
        }
            
        case UsernameInAccout:
        {
            self.titleLabel.text = @"用户名";
            [self disableDetailEditWithText:@"AH1221414"];
            break;
        }
            
        case PhoneInAccount:
        {
            self.titleLabel.text = @"手机号码";
            [self disableDetailEditWithText:@"135****1234"];
            break;
        }
            
        case PasswordInAccount:
        {
            self.titleLabel.text = @"修改密码";
            [self disableDetailEditWithText:@"xxxxxx"];
            break;
        }
            
        default:
            break;
    }
}

@end
