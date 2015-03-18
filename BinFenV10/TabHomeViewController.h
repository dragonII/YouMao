//
//  TabHomeViewController.h
//  BinFenV10
//
//  Created by Wang Long on 2/2/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DataModel;

@interface TabHomeViewController : UIViewController

@property (strong, nonatomic) DataModel *dataModel;

- (IBAction)unwindToTabHome:(UIStoryboardSegue *)segue;

@end
