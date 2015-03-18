//
//  EditUserInfoViewController.h
//  BinFenV10
//
//  Created by Wang Long on 2/11/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    EditUserNameInfo = 0,
    EditUserPhoneNum,
    EditUserPassword
} EditUserInfoType;

@interface EditUserInfoViewController : UIViewController

@property (assign, nonatomic) EditUserInfoType editUserInfoType;

@end
