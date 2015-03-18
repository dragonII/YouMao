//
//  RegisterViewController.m
//  BinFenV10
//
//  Created by Wang Long on 3/2/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *agreeStatusImage;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;

@end

@implementation RegisterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.registerButton.layer.cornerRadius = 5.0f;
    self.registerButton.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"ButtonBGOrange"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)cancelClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
