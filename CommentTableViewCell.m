//
//  CommentTableViewCell.m
//  BinFenV10
//
//  Created by Wang Long on 2/9/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import "CommentTableViewCell.h"

static CGFloat WrapWidth = 280.0f;
static CGFloat TextTopMargin = 10.0f;
static CGFloat TextBottomMargin = 10.0f;

@interface CommentTableViewCell()

@property (strong, nonatomic) UIImageView *userImageView;
@property (strong, nonatomic) UILabel *usernameLabel;
@property (strong, nonatomic) UITextView *commentTextView;

@end

@implementation CommentTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]))
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.userImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 8, 20, 20)];
        self.userImageView.image = [UIImage imageNamed:@"20x20"];
        
        // Performance
        self.userImageView.layer.cornerRadius = 10.0f;
        self.userImageView.layer.masksToBounds = NO;
        self.userImageView.layer.shouldRasterize = YES;
        self.userImageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        
        /////
        self.userImageView.layer.borderWidth = 1.0f;
        self.userImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        self.userImageView.clipsToBounds = YES;
        
        
        self.usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(54, 14,
                                                                       self.contentView.bounds.size.width - 54,
                                                                       20)];
        self.usernameLabel.text = @"Test用户";
        self.commentTextView = [[UITextView alloc] initWithFrame:CGRectMake(20, 35, WrapWidth, 0)];
        self.commentTextView.scrollEnabled = NO;
        
        [self.contentView addSubview:self.userImageView];
        [self.contentView addSubview:self.usernameLabel];
        [self.contentView addSubview:self.commentTextView];
    }
    return self;
}

- (void)awakeFromNib
{
}

+ (CGSize)sizeOfTextViewForText:(NSString *)text
{
    UIFont *font = [UIFont fontWithName:@"STHeitiSC-Light" size:13];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    /*
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:text
                                                                         attributes:@{NSFontAttributeName :font, NSParagraphStyleAttributeName: paragraphStyle}];
    CGRect rect = [attributedText boundingRectWithSize:(CGSize){WrapWidth, 9999}
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    CGSize textSize = rect.size;
     */
    
    NSDictionary *attributes = @{NSFontAttributeName:font,
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    CGRect textRect = [text boundingRectWithSize:CGSizeMake(WrapWidth, 99999.0f)
                                         options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading
                                      attributes:attributes
                                         context:nil];
    
    CGSize textSize = textRect.size;
    
    CGSize textViewSize;
    //textViewSize.width = textSize.width + TextLeftMargin + TextRightMargin;
    textViewSize.width = WrapWidth;
    textViewSize.height = textSize.height + TextTopMargin + TextBottomMargin;
    
    return textViewSize;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCommentText:(NSString *)text
{
    CGSize textViewSize = [CommentTableViewCell sizeOfTextViewForText:text];
    [self.commentTextView setFrame:CGRectMake(20, 35, textViewSize.width - 40, textViewSize.height)];
    [self.commentTextView setText:text];
}

- (void)setCommentUser:(NSString *)user
{
    self.usernameLabel.text = user;
}

@end
