//
//  TopCollectionViewCell.h
//  BinFenV10
//
//  Created by Wang Long on 2/1/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LTransitionImageView;

@interface CommunityCollectionViewCell : UICollectionViewCell <UIGestureRecognizerDelegate>

@property (strong, nonatomic) LTransitionImageView *transitionView;

@property (strong, nonatomic) NSMutableArray *images;
@property (strong, nonatomic) NSMutableArray *imageNamesArray;

@property (strong, nonatomic) UILabel *textLabel;

@property (copy, nonatomic) NSString *text;

@end
