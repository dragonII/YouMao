//
//  FavoriteCollectionViewCell_New.m
//  BinFenV10
//
//  Created by Wang Long on 3/17/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import "FavoriteCollectionViewCell.h"
#import "DeviceHardware.h"

@implementation FavoriteCollectionViewCell

- (CGSize)getImageViewSizeByDevice
{
    DeviceHardwareGeneralPlatform generalPlatform = [DeviceHardware generalPlatform];
    
    CGSize size;
    
    switch (generalPlatform)
    {
        case DeviceHardwareGeneralPlatform_iPhone_4:
        case DeviceHardwareGeneralPlatform_iPhone_4S:
        case DeviceHardwareGeneralPlatform_iPhone_5:
        case DeviceHardwareGeneralPlatform_iPhone_5C:
        case DeviceHardwareGeneralPlatform_iPhone_5S:
        {
            size = CGSizeMake(142.0f, 142.0f);
            break;
        }
            
        case DeviceHardwareGeneralPlatform_iPhone_6:
        {
            size = CGSizeMake(168.0f, 168.0f);
            break;
        }
            
        case DeviceHardwareGeneralPlatform_iPhone_6_Plus:
        default:
            size = CGSizeMake(188.0f, 188.0f);
            break;
    }
    return size;
}

- (CGSize)getTextViewSizeByDevice
{
    DeviceHardwareGeneralPlatform generalPlatform = [DeviceHardware generalPlatform];
    
    CGSize size;
    
    switch (generalPlatform)
    {
        case DeviceHardwareGeneralPlatform_iPhone_4:
        case DeviceHardwareGeneralPlatform_iPhone_4S:
        case DeviceHardwareGeneralPlatform_iPhone_5:
        case DeviceHardwareGeneralPlatform_iPhone_5C:
        case DeviceHardwareGeneralPlatform_iPhone_5S:
        {
            size = CGSizeMake(142.0f, 68.0f);
            break;
        }
            
        case DeviceHardwareGeneralPlatform_iPhone_6:
        {
            size = CGSizeMake(168.0f, 76.0f);
            break;
        }
            
        case DeviceHardwareGeneralPlatform_iPhone_6_Plus:
        default:
            size = CGSizeMake(188.0f, 84.0f);
            break;
    }
    return size;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        CGRect imageViewFrame = CGRectMake(1, 1, [self getImageViewSizeByDevice].width, [self getImageViewSizeByDevice].height);
        CGRect textViewFrame = CGRectMake(1, [self getImageViewSizeByDevice].height + 1,
                                          [self getTextViewSizeByDevice].width,
                                          [self getTextViewSizeByDevice].height);
        self.imageView = [[UIImageView alloc] initWithFrame:imageViewFrame];
        self.imageView.image = [UIImage imageNamed:@"Default_142x142"];
        self.descriptionTextView = [[UITextView alloc] initWithFrame:textViewFrame];
        
        [self addSubview:self.imageView];
        [self addSubview:self.descriptionTextView];
    }
    return self;
}

@end
