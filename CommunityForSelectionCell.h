//
//  CommunityForSelectionCell.h
//  BinFenV10
//
//  Created by Wang Long on 2/9/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    CommunityCellTypeCurrent = 0,
    CommunityCellTypeHistory
} CommunityCellType;

@class CommunityForSelectionCell;
@protocol DeleteHistoryCommunityDelegate <NSObject>

- (void)deleteClickedInCell:(CommunityForSelectionCell *)cell;

@end

@interface CommunityForSelectionCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sourceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *operationImage;

@property (weak, nonatomic) id<DeleteHistoryCommunityDelegate> deleteHistoryDelegate;

@property (nonatomic) CommunityCellType cellType;

- (void)setCellType:(CommunityCellType)cellType;

@end
