//
//  OTCover.h
//  OTMediumCover
//
//  Created by yechunxiao on 14-9-21.
//  Copyright (c) 2014年 yechunxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OTCover;

@protocol OTCoverSegueDelegate <NSObject>

- (void)searchClickedInView:(OTCover *)view;

@end

@interface OTCover : UIView

@property (nonatomic, strong) UIView* scrollContentView;
@property (nonatomic, strong) UIImageView* headerImageView;
@property (nonatomic, strong) UITableView* tableView;

@property (weak, nonatomic) id<OTCoverSegueDelegate> segueDelegate;

- (OTCover*)initWithTableViewWithHeaderImage:(UIImage*)headerImage withOTCoverHeight:(CGFloat)height;
- (void)setHeaderImage:(UIImage *)headerImage;


@end

@interface UIImage (Blur)
-(UIImage *)boxblurImageWithBlur:(CGFloat)blur;
@end

