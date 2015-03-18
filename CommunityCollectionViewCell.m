//
//  TopCollectionViewCell.m
//  BinFenV10
//
//  Created by Wang Long on 2/1/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import "CommunityCollectionViewCell.h"
//#import "LAAnimatedGrid.h"
#import "LTransitionImageView.h"

static AnimationDirection directions[4];

@implementation CommunityCollectionViewCell

- (void)awakeFromNib
{
    directions[0] = AnimationDirectionLeftToRight;
    directions[1] = AnimationDirectionRightToLeft;
    directions[2] = AnimationDirectionTopToBottom;
    directions[3] = AnimationDirectionBottomToTop;
    
    // Array of images
    self.images = [NSMutableArray array];
    

    /*
    [self.images addObject:[UIImage imageNamed:@"Default_120x160"]];
    [self.images addObject:[UIImage imageNamed:@"Default_120x160_1"]];
    [self.images addObject:[UIImage imageNamed:@"E1"]];
    [self.images addObject:[UIImage imageNamed:@"E2"]];
     */
    
    // 使用LTransitionImageView
    self.transitionView = [[LTransitionImageView alloc] initWithFrame:self.contentView.bounds];
    self.transitionView.animationDuration = 1;
    int r = [self loadRandomNumberInRange:4];
    self.transitionView.animationDirection = directions[r];
    //NSLog(@"Direction: %d", self.transitionView.animationDirection);
    //self.transitionView.image = [self.images objectAtIndex:[self loadRandomNumberInRange:(int)[self.images count]]];
    [self.contentView addSubview:self.transitionView];
    
    
    //[self transitionAnimations];
    
    
    self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.contentView.bounds.origin.x,
                                                              self.contentView.bounds.origin.y + 49,
                                                              self.contentView.bounds.size.width,
                                                               100)];
    
    //self.textLabel = [[UILabel alloc] initWithFrame:self.contentView.bounds];
    self.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.textLabel.numberOfLines = 0;

    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.textLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:18];
    self.textLabel.textColor = [UIColor whiteColor];
    [self.contentView addSubview:self.textLabel];
    
}

- (void)transitionAnimations
{
    int temp = [self loadRandomNumberInRange:4] + 1; // [1, 4]
    CGFloat delay = 4.0f / (CGFloat)temp;
    [NSTimer scheduledTimerWithTimeInterval:self.transitionView.animationDuration + delay
                                     target:self
                                   selector:@selector(animateImage)
                                   userInfo:nil
                                    repeats:YES];
}

- (void)animateImage
{
    UIImage *image;
    AnimationDirection newDirection;
    
    int r = [self loadRandomNumberInRange:4];
    newDirection = directions[r];
    if(self.transitionView.animationDirection != newDirection)
        self.transitionView.animationDirection = newDirection;
    
    image = [self.images objectAtIndex:[self loadRandomNumberInRange:(int)[self.images count]]];
    
    self.transitionView.image = image;
}

- (int)loadRandomNumberInRange:(int)range
{
    return arc4random() % range;
}

- (void)setText:(NSString *)text
{
    if(![_text isEqualToString:text])
    {
        //NSLog(@"Setting text");
        _text = [text copy];
        _textLabel.text = _text;
    }
}


- (void)setImageNamesArray:(NSMutableArray *)imageNamesArray
{
    _imageNamesArray = [NSMutableArray arrayWithArray:imageNamesArray];
 
    //NSLog(@"%s: %@", __func__, self.imageNamesArray);
    
    self.images = [[NSMutableArray alloc] init];
    
    for(NSString *s in self.imageNamesArray)
    {
        if([s length] != 0)
            [self.images addObject:[UIImage imageNamed:s]];
    }
    
    if([self.images count] == 0)
    {
        [self.images addObject:[UIImage imageNamed:@"Default_120x160"]];
        [self.images addObject:[UIImage imageNamed:@"Default_120x160_1"]];
        [self.images addObject:[UIImage imageNamed:@"E1"]];
        [self.images addObject:[UIImage imageNamed:@"E2"]];
    }
    
    self.transitionView.image = [self.images objectAtIndex:[self loadRandomNumberInRange:(int)[self.images count]]];
    //[self.contentView addSubview:self.transitionView];
    
    
    [self transitionAnimations];
}


@end
