//
//  ComposeCommentViewController.m
//  BinFenV10
//
//  Created by Wang Long on 3/5/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import "ComposeCommentViewController.h"

static const NSInteger GoodImageTag = 51;
static const NSInteger MiddleImageTag = 52;
static const NSInteger BadImageTag = 53;

typedef enum
{
    CommentLevelGood = 0,
    CommentLevelMiddle,
    CommentLevelBad
} CommentLevelType;

@interface ComposeCommentViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *goodImageView;
@property (weak, nonatomic) IBOutlet UIImageView *middleImageView;
@property (weak, nonatomic) IBOutlet UIImageView *badImageView;

@property (weak, nonatomic) IBOutlet UILabel *goodLabel;
@property (weak, nonatomic) IBOutlet UILabel *middleLabel;
@property (weak, nonatomic) IBOutlet UILabel *badLabel;

@property (weak, nonatomic) IBOutlet UITextField *commentTextField;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@property (assign, nonatomic) CommentLevelType selectedCommentLevel;

@end

@implementation ComposeCommentViewController

- (void)imageTapped:(UIGestureRecognizer *)gestureRecognizer
{
    UIImageView *imageView = (UIImageView *)gestureRecognizer.view;
    switch (imageView.tag)
    {
        case GoodImageTag:
            NSLog(@"Good");
            self.selectedCommentLevel = CommentLevelGood;
            [self setLabelHightlightedColor:self.goodLabel];
            break;
            
        case MiddleImageTag:
            NSLog(@"Middle");
            self.selectedCommentLevel = CommentLevelMiddle;
            [self setLabelHightlightedColor:self.middleLabel];
            break;
            
        case BadImageTag:
            NSLog(@"Bad");
            self.selectedCommentLevel = CommentLevelBad;
            [self setLabelHightlightedColor:self.badLabel];
            break;
            
        default:
            break;
    }
}

- (void)setLabelHightlightedColor:(UILabel *)label
{
    self.goodLabel.textColor = [UIColor blackColor];
    self.middleLabel.textColor = [UIColor blackColor];
    self.badLabel.textColor = [UIColor blackColor];
    
    label.textColor = [UIColor colorWithRed:253/255.0f green:155/255.0f blue:90/255.0f alpha:1.0f];
}

- (void)initImageViewActions
{
    [self addActionInView:self.goodImageView Tag:GoodImageTag];
    [self addActionInView:self.middleImageView Tag:MiddleImageTag];
    [self addActionInView:self.badImageView Tag:BadImageTag];
    
    //default
    [self setLabelHightlightedColor:self.goodLabel];
}

- (void)addActionInView:(UIImageView *)imageView Tag:(NSInteger)tag
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.numberOfTouchesRequired = 1;
    
    imageView.tag = tag;
    imageView.userInteractionEnabled = YES;
    [imageView addGestureRecognizer:tapGesture];
    
    // Performance
    imageView.layer.cornerRadius = 22.0f;
    imageView.layer.masksToBounds = NO;
    imageView.layer.shouldRasterize = YES;
    imageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    /////
    //imageView.layer.borderWidth = 1.0f;
    //imageView.layer.borderColor = [UIColor whiteColor].CGColor;
    imageView.clipsToBounds = YES;
    imageView.alpha = 1.0f;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.selectedCommentLevel = CommentLevelGood;
    
    [self initImageViewActions];
    self.commentTextField.delegate = self;
    
    self.submitButton.layer.cornerRadius = 5.0f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    //[textField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)submitClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
