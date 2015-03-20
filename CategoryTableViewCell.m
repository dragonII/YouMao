//
//  CategoryTableViewCell_New.m
//  BinFenV10
//
//  Created by Wang Long on 3/13/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import "CategoryTableViewCell.h"

#import "DeviceHardware.h"


@interface CategoryTableViewCell () <UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIPageControl *pageControl;

@end

@implementation CategoryTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    UIColor *BGColor = [UIColor colorWithRed:225/255.0f green:225/255.0f blue:225/255.0f alpha:1.0f];
    UIColor *pageControlTintColor = [UIColor colorWithRed:191/255.0f green:191/255.0f blue:191/255.0f alpha:0.8f];
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        UIView *topViewSeparator = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 12)];
        topViewSeparator.backgroundColor = BGColor;
        
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 12, width, 190)];
        self.scrollView.delegate = self;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.bounces = YES;
        self.scrollView.pagingEnabled = YES;
        
        self.pageControl = [[UIPageControl alloc] init];
        self.pageControl.currentPageIndicatorTintColor = [UIColor blueColor];
        self.pageControl.pageIndicatorTintColor = pageControlTintColor;
        
        UIView *bottomViewSeparator = [[UIView alloc] initWithFrame:CGRectMake(0, 12 + 190, width, 12)];
        bottomViewSeparator.backgroundColor = BGColor;
        
        [self.contentView addSubview:topViewSeparator];
        [self.contentView addSubview:self.scrollView];
        [self.contentView addSubview:self.pageControl];
        [self.contentView addSubview:bottomViewSeparator];
        
        __weak UIPageControl *pageControl = self.pageControl;
        [self.pageControl setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [self.contentView addConstraints:[NSLayoutConstraint
                                          constraintsWithVisualFormat:@"H:|-0-[pageControl]-0-|"
                                          options:0
                                          metrics:nil
                                          views:NSDictionaryOfVariableBindings(pageControl)]];
        [self.contentView addConstraints:[NSLayoutConstraint
                                          constraintsWithVisualFormat:@"V:[pageControl]-12-|"
                                          options:0
                                          metrics:nil
                                          views:NSDictionaryOfVariableBindings(pageControl)]];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCategoriesListArray:(NSArray *)categoriesListArray
{
    if(![_categoriesListArray isEqualToArray:categoriesListArray])
    {
        _categoriesListArray = [NSArray arrayWithArray:categoriesListArray];
        [self drawCategoryItems];
    }
}

- (CGSize)getItemSizeByDevice
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
            size = CGSizeMake(80.0f, 80.0f);
            return size;
        }
            
        case DeviceHardwareGeneralPlatform_iPhone_6:
        case DeviceHardwareGeneralPlatform_iPhone_6_Plus:
        {
            size = CGSizeMake(24 + 44 + 24, 80);
            return size;
        }
        
        // iPhone 6 simulator
        default:
            size = CGSizeMake(24 + 44 + 24, 80);
            return size;
    }
}

- (CGFloat)getHorizentalSpace
{
    DeviceHardwareGeneralPlatform generalPlatform = [DeviceHardware generalPlatform];
    
    switch (generalPlatform)
    {
        case DeviceHardwareGeneralPlatform_iPhone_4:
        case DeviceHardwareGeneralPlatform_iPhone_4S:
        case DeviceHardwareGeneralPlatform_iPhone_5:
        case DeviceHardwareGeneralPlatform_iPhone_5C:
        case DeviceHardwareGeneralPlatform_iPhone_5S:
        {
            return 18.0f;
        }
            
        case DeviceHardwareGeneralPlatform_iPhone_6:
        case DeviceHardwareGeneralPlatform_iPhone_6_Plus:
        {
            return 24.0f;
        }
            
            // iPhone 6 simulator
        default:
            return 24.0f;
    }
}

- (CGFloat)getColumnPadding
{
    DeviceHardwareGeneralPlatform generalPlatform = [DeviceHardware generalPlatform];
    
    switch (generalPlatform)
    {
        case DeviceHardwareGeneralPlatform_iPhone_4:
        case DeviceHardwareGeneralPlatform_iPhone_4S:
        case DeviceHardwareGeneralPlatform_iPhone_5:
        case DeviceHardwareGeneralPlatform_iPhone_5C:
        case DeviceHardwareGeneralPlatform_iPhone_5S:
        case DeviceHardwareGeneralPlatform_iPhone_6:
        {
            return 0.0f;
        }
            
        case DeviceHardwareGeneralPlatform_iPhone_6_Plus:
        default:
            return 15.0f;
    }
}


- (void)categoryItemClicked:(UITapGestureRecognizer*)sender
{
    UIView *view = sender.view;
    NSLog(@"%ld", (long)view.tag);
}

- (void)drawCategoryItems
{
    int columnsPerPage = 4;
    CGFloat itemWidth = [self getItemSizeByDevice].width;
    CGFloat itemHeight = [self getItemSizeByDevice].height;
    
    CGFloat x = 0;
    //CGFloat extraSpace = 0.0f;
    
    CGFloat scrollViewWidth = self.scrollView.bounds.size.width;
    
    CGFloat imageViewWidth = 44.0f;
    CGFloat imageViewHeight = 44.0f;
    CGFloat startingPoint = [self getHorizentalSpace];
    CGFloat colPadding = [self getColumnPadding];
    
    int index = 1000;
    int row = 0;
    int column = 0;
    int pages = 0;
    
    //for(NSString *itemString in self.categoriesListArray)
    for(NSDictionary *dict in self.categoriesListArray)
    {
        UIView *itemView = [[UIView alloc] init];
        itemView.tag = index;
        itemView.frame = CGRectMake(x + column * colPadding, row * itemHeight, itemWidth, itemHeight);
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(categoryItemClicked:)];
        tapGesture.numberOfTapsRequired = 1;
        tapGesture.numberOfTouchesRequired = 1;
        [itemView addGestureRecognizer:tapGesture];
        
        
        UIImageView *imageView = [[UIImageView alloc] init];
        UILabel *label = [[UILabel alloc] init];
        
        imageView.frame = CGRectMake(itemView.bounds.origin.x + startingPoint,
                                     itemView.bounds.origin.y + 12,
                                     imageViewWidth, imageViewHeight);
        
        label.frame = CGRectMake(itemView.bounds.origin.x,
                                 itemView.bounds.origin.y + 12 + imageViewHeight,
                                 itemWidth, itemHeight - imageViewHeight);
        //label.text = itemString;
        label.text = [dict objectForKey:@"name"];
        //NSLog(@"%@: %d", label.text, pages);
        label.textAlignment = NSTextAlignmentCenter;
        
        //http://stackoverflow.com/questions/9907100/issues-with-setting-some-different-font-for-uilabel
        label.font = [UIFont fontWithName:@"STHeitiSC-Light" size:10];
        
        //imageView.image = [UIImage imageNamed:@"Default_44x44"];
        imageView.image = [UIImage imageNamed:[dict objectForKey:@"image"]];
        //imageView.contentMode = UIViewContentModeScaleAspectFill;
        /////
        // Performance
        imageView.layer.cornerRadius = 22.0f;
        imageView.layer.masksToBounds = NO;
        imageView.layer.shouldRasterize = YES;
        imageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        
        /////
        imageView.layer.borderWidth = 1.0f;
        imageView.layer.borderColor = [UIColor whiteColor].CGColor;
        imageView.clipsToBounds = YES;
        imageView.alpha = 0.8f;
        
        
        [itemView addSubview:imageView];
        [itemView addSubview:label];
        [self.scrollView addSubview:itemView];
        
        index++;
        row++;
        if(row == 2)
        {
            row = 0;
            column++;
            x += itemWidth;
            
            if(column == columnsPerPage)
            {
                pages++;
                column = 0;
                x = [UIScreen mainScreen].bounds.size.width * pages;
            }
        }
    }
    
    int tilesPerPage = columnsPerPage * 2;
    int numPages = ceilf([self.categoriesListArray count] / (float)tilesPerPage);
    
    self.scrollView.contentSize = CGSizeMake(numPages * scrollViewWidth, self.scrollView.frame.size.height);
    
    self.pageControl.numberOfPages = numPages;
    self.pageControl.currentPage = 0;
    
    //NSLog(@"ContentSize: %f, %f", self.scrollView.contentSize.width, self.scrollView.contentSize.height);
}

#pragma mark - ScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //NSLog(@"scrollViewDidScroll");
    CGFloat width = self.scrollView.bounds.size.width;
    int currentPage = (self.scrollView.contentOffset.x + width) / width - 1;
    self.pageControl.currentPage = currentPage;
}

@end
