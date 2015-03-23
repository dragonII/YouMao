//
//  ProductImageCell.m
//  BinFenV10
//
//  Created by Wang Long on 2/8/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import "ProductImageCell.h"
#import "UIKit+AFNetworking.h"

@interface ProductImageCell() <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@end

@implementation ProductImageCell


- (void)awakeFromNib
{
    self.scrollView.delegate = self;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.bounces = YES;
    self.pageControl.currentPageIndicatorTintColor = [UIColor blueColor];
    self.pageControl.pageIndicatorTintColor = [UIColor colorWithRed:191/255.0f green:191/255.0f blue:191/255.0f alpha:0.8f];
    [self.pageControl setHidesForSinglePage:YES];
    
    //[self setImages];
    [self initItems];
}

/*
- (void)setImages
{
    self.imageNamesArray = @[@"Default_320x200"];
}
 */

- (void)setImageNamesArray:(NSArray *)imageNamesArray
{
    _imageNamesArray = [NSArray arrayWithArray:imageNamesArray];
    
    [self loadImages];
}

- (void)loadImages
{
    CGFloat scrollViewWidth = self.scrollView.bounds.size.width;
    CGFloat x = 0;
    CGFloat imageViewWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat imageViewHeight = 200.0f;
    int i = 0;
    int j = 0;
    for(i = 0, j = 0; i < [self.imageNamesArray count]; i++)
    {
        NSLog(@"imageName: %@", [self.imageNamesArray objectAtIndex:i]);
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(x + (imageViewWidth * i), 0, imageViewWidth, imageViewHeight);
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        NSString *imageString = [self.imageNamesArray objectAtIndex:i];
        if([imageString length] == 0)
        {
            //[imageView setImage:[UIImage imageNamed:@"Default_320x200"]];
            continue;
        }
        else
        {
            [imageView setImage:[UIImage imageNamed:imageString]];
            j++;
        }
        
        [self.scrollView addSubview:imageView];
    }
    self.scrollView.contentSize = CGSizeMake(j * scrollViewWidth, self.scrollView.frame.size.height);
    
    self.pageControl.numberOfPages = j;
    self.pageControl.currentPage = 0;
}

- (void)initItems
{
    CGFloat x = 0;
    
    //CGFloat scrollViewWidth = self.scrollView.bounds.size.width;
    CGFloat scrollViewWidth = [UIScreen mainScreen].bounds.size.width;
    
    CGFloat imageViewWidth = [UIScreen mainScreen].bounds.size.width;
    
    CGFloat imageViewHeight = 200.0f;
    
    //NSLog(@"Before setting images");
    for(int i = 0; i < [self.imageNamesArray count]; i++)
    {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(x + (imageViewWidth * i), 0, imageViewWidth, imageViewHeight);
        [imageView setImageWithURL:[NSURL URLWithString:[self.imageNamesArray objectAtIndex:i]] placeholderImage:[UIImage imageNamed:@"Default_320x200"]];
        
        [self.scrollView addSubview:imageView];
    }
    
    self.scrollView.contentSize = CGSizeMake([self.imageNamesArray count] * scrollViewWidth, self.scrollView.frame.size.height);
    
    self.pageControl.numberOfPages = [self.imageNamesArray count];
    self.pageControl.currentPage = 0;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //NSLog(@"scrollViewDidScroll");
    CGFloat width = self.scrollView.bounds.size.width;
    int currentPage = (self.scrollView.contentOffset.x + width) / width - 1;
    self.pageControl.currentPage = currentPage;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
