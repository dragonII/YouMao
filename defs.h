//
//  defs.h
//  BinFenV10
//
//  Created by Wang Long on 2/1/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#ifndef BinFenV10_defs_h
#define BinFenV10_defs_h

static NSInteger SearchViewTag = 4000;

static NSString *LoadContentBatchIndexKey = @"loadBatchIndex";
static NSString *CanBeRefreshedKey = @"refresh";

static int TotalItemsPerBatch = 20;
static int TotalRowsPerBatch = 10;


static const CGFloat HeightOfItemInShopsTableCell = 208 + 10; //item + spacing

// 因为HomeTab中含有隐藏和显示NavigationBar的操作，此操作会使得后续的View中Frame产生变化，所以需要在此标示出从哪里进入，
// 用来决定Frame的值
typedef enum
{
    ShowViewFromHome,
    ShowViewFromOthers
} ShowViewBySourceType;


#endif
