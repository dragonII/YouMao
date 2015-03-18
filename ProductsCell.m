//
//  ProductsCell.m
//  BinFenV10
//
//  Created by Wang Long on 3/12/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import "ProductsCell.h"
#import "BFPreferenceData.h"
#import "DataModel.h"
#import "AppDelegate.h"
#import "UIKit+AFNetworking.h"

#import "DeviceHardware.h"

#import "defs.h"

typedef struct
{
    CGSize itemSize;
    CGSize imageSize;
} ItemSizeStruct;

@interface ProductsCell () <UIGestureRecognizerDelegate>

@end

@implementation ProductsCell

- (void)awakeFromNib
{
    //self.dataModel = [[DataModel alloc] init];
    //[self.dataModel loadDataModelLocally];
    
    //NSLog(@"XYZ %@", self.dataModel.shops);
    
    //[self initItems];
}


- (void)productItemClicked:(UITapGestureRecognizer*)sender
{
    UIView *view = (UIView *)sender.view;
    
    NSInteger productIndex = view.tag - 3000;
    self.productID = [[[self.products objectAtIndex:productIndex] objectForKey:@"ID"] copy];
    //NSLog(@"productItemClicked xx%@", self.productID);
    if([self.segueDelegate respondsToSelector:@selector(productItemClickedInCell:)])
    {
        [self.segueDelegate performSelector:@selector(productItemClickedInCell:) withObject:self];
    }
}



- (ItemSizeStruct)getItemSizeByDevice
{
    DeviceHardwareGeneralPlatform generalPlatform = [DeviceHardware generalPlatform];
    
    CGFloat itemWidth;
    CGFloat itemHeight;
    CGFloat imageWidth;
    CGFloat imageHeight;
    
    ItemSizeStruct itemStruct;
    
    switch (generalPlatform)
    {
        case DeviceHardwareGeneralPlatform_iPhone_4:
        case DeviceHardwareGeneralPlatform_iPhone_4S:
        case DeviceHardwareGeneralPlatform_iPhone_5:
        case DeviceHardwareGeneralPlatform_iPhone_5C:
        case DeviceHardwareGeneralPlatform_iPhone_5S:
        {
            NSLog(@"iphone 4, 4S");
            //return 106.0f;
            itemWidth = 142.0f;
            itemHeight = 208.0f;
            imageWidth = 142.0f;
            imageHeight = 142.0f;
            
            itemStruct.itemSize = CGSizeMake(itemWidth, itemHeight);
            itemStruct.imageSize = CGSizeMake(imageWidth, imageHeight);
            
            return itemStruct;
            break;
        }
            
        case DeviceHardwareGeneralPlatform_iPhone_6:
        {
            itemWidth = 170.0f;
            itemHeight = 246.0f;
            imageWidth = 170.0f;
            imageHeight = 170.0f;
            
            itemStruct.itemSize = CGSizeMake(itemWidth, itemHeight);
            itemStruct.imageSize = CGSizeMake(imageWidth, imageHeight);
            
            return itemStruct;
            break;
        }
        case DeviceHardwareGeneralPlatform_iPhone_6_Plus:
        default:
            itemWidth = 190.0f;
            itemHeight = 274.0f;
            imageWidth = 188.0f;
            imageHeight = 188.0f;
            
            itemStruct.itemSize = CGSizeMake(itemWidth, itemHeight);
            itemStruct.imageSize = CGSizeMake(imageWidth, imageHeight);
            
            return itemStruct;
            break;
    }
}


- (void)initProductItemsByShopIndex:(NSInteger)shopIndex
{
    if(shopIndex < 0)
    {
        [self loadAllProducts];
    } else {
        [self loadProductsByShopIndex:shopIndex];
    }
    
    [self showingProductsInView];
}

- (void)loadAllProducts
{
    self.dataModel = [[DataModel alloc] init];
    [self.dataModel loadDataModelLocally];
    
    self.products = [NSMutableArray arrayWithArray:self.dataModel.products];
}

- (void)loadProductsByShopIndex:(NSInteger)shopIndex
{
    self.dataModel = [[DataModel alloc] init];
    [self.dataModel loadDataModelLocally];
    
    NSString *shopID = [[self.dataModel.shops objectAtIndex:shopIndex] objectForKey:@"ID"];
    self.products = [[NSMutableArray alloc] init];
    
    for(int i = 0; i < [self.dataModel.products count]; i++)
    {
        NSString *shopIDInProducts = [[self.dataModel.products objectAtIndex:i] objectForKey:@"shop"];
        if([shopIDInProducts isEqualToString:shopID])
        {
            [self.products addObject:[self.dataModel.products objectAtIndex:i]];
        }
    }
}

- (void)showingProductsInView
{
    //self.dataModel = [[DataModel alloc] init];
    //[self.dataModel loadDataModelLocally];
    
    ItemSizeStruct itemSizeStruct = [self getItemSizeByDevice];
    
    NSInteger batchIndex = [[NSUserDefaults standardUserDefaults] integerForKey:LoadContentBatchIndexKey];
    NSLog(@"batchIndex#: %ld", (long)batchIndex);
    
    CGFloat itemWidth = itemSizeStruct.itemSize.width;
    CGFloat itemHeight = itemSizeStruct.itemSize.height;
    
    CGFloat y = 10;
    //CGFloat extraSpace = 0.0f;
    
    CGFloat imageViewWidth = itemSizeStruct.imageSize.width;
    CGFloat imageViewHeight = itemSizeStruct.imageSize.height;
    
    int index = 3000;
    NSInteger maxIndex = 0;
    int row = 0;
    int column = 0;
    
    if([self.products count] >= batchIndex * TotalItemsPerBatch)
        maxIndex = batchIndex * TotalItemsPerBatch;
    else
        maxIndex = [self.products count];
    
    for(int i = 0; i < maxIndex; i++)
    {
        UIView *itemView = [[UIView alloc] init];
        itemView.frame = CGRectMake(column * (itemWidth + 12) + 12, y, itemWidth, itemHeight);
        itemView.layer.borderColor = [UIColor blackColor].CGColor;
        itemView.layer.borderWidth = 0.5;
        
        
        itemView.tag = index;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(productItemClicked:)];
        tapGesture.delegate = self;
        tapGesture.numberOfTapsRequired = 1;
        tapGesture.numberOfTouchesRequired = 1;
        [itemView setUserInteractionEnabled:YES];
        [itemView addGestureRecognizer:tapGesture];
        
        UIImageView *imageView = [[UIImageView alloc] init];
        UILabel *label = [[UILabel alloc] init];
        
        imageView.frame = CGRectMake(itemView.bounds.origin.x, itemView.bounds.origin.y, imageViewWidth, imageViewHeight);
        label.frame = CGRectMake(itemView.bounds.origin.x, itemView.bounds.origin.y + imageViewHeight, itemView.bounds.size.width, itemHeight - imageViewHeight);
        
        label.text = [[self.products objectAtIndex:i] objectForKey:@"name"];
        label.textAlignment = NSTextAlignmentCenter;
        
        //http://stackoverflow.com/questions/9907100/issues-with-setting-some-different-font-for-uilabel
        label.font = [UIFont fontWithName:@"STHeitiSC-Light" size:10];
        
        //NSString *imageURLString = [[self.dataModel.shops objectAtIndex:i] objectForKey:@"image"];
        NSString *imageURLString = [[self.products objectAtIndex:i] objectForKey:@"image"];
        [imageView setImageWithURL:[NSURL URLWithString:imageURLString] placeholderImage:[UIImage imageNamed:@"Default_142x142"]];
        
        
        [itemView addSubview:imageView];
        [itemView addSubview:label];
         
        
        [self.contentView addSubview:itemView];
        
        index++;
        column++;
        if(column == 2)
        {
            column = 0;
            row++;
            y += itemHeight + 10;
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}



@end
