//
//  OTCover.m
//  OTMediumCover
//
//  Created by yechunxiao on 14-9-21.
//  Copyright (c) 2014年 yechunxiao. All rights reserved.
//

#import "OTCover.h"
#import <QuartzCore/QuartzCore.h>
#import <Accelerate/Accelerate.h>

#import "defs.h"

#import "DeviceHardware.h"

@interface OTCover()

@property (nonatomic, strong) NSMutableArray *blurImages;
@property (nonatomic, assign) CGFloat OTCoverHeight;
@property (nonatomic, strong) UIView* scrollHeaderView;
//@property (nonatomic, strong) UIImageView *searchView;
@property (nonatomic, strong) UIView *searchView;

@property BOOL searchViewHideDone;
@property BOOL searchViewShowDone;
@property BOOL searchViewContentsInsetsDone;

@end

@implementation OTCover

- (NSString *)getImageNameByDevice
{
    DeviceHardwareGeneralPlatform generalPlatform = [DeviceHardware generalPlatform];
    
    NSString *imageName;
    
    switch (generalPlatform)
    {
        case DeviceHardwareGeneralPlatform_iPhone_4:
        case DeviceHardwareGeneralPlatform_iPhone_4S:
        case DeviceHardwareGeneralPlatform_iPhone_5:
        case DeviceHardwareGeneralPlatform_iPhone_5C:
        case DeviceHardwareGeneralPlatform_iPhone_5S:
            imageName = @"SearchBarInHome320";
            break;
        

        case DeviceHardwareGeneralPlatform_iPhone_6:
            imageName = @"SearchBarInHome375";
            break;

        case DeviceHardwareGeneralPlatform_iPhone_6_Plus:           
        default:
            imageName = @"SearchBarInHome413";
            break;
    }
    return imageName;
}

- (void)tapDetected
{
    NSLog(@"single Tap on imageview");
    if([self.segueDelegate respondsToSelector:@selector(searchClickedInView:)])
    {
        [self.segueDelegate performSelector:@selector(searchClickedInView:) withObject:self];
    }
}

- (void)initSearchView
{
    self.searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64)];
    self.searchView.backgroundColor = [UIColor colorWithRed:70/255.0f green:159/255.0f blue:183/255.0f alpha:1.0f];
    //self.searchView.image = [UIImage imageNamed:@"SearchBarInHome"];
    //self.searchView.image = [UIImage imageNamed:[self getImageNameByDevice]];
    //self.searchView.contentMode = UIViewContentModeScaleAspectFit;
    //self.searchView.image = [UIImage imageNamed:@"SearchBox6P.png"];
    CGFloat labelWidth = 200;
    CGFloat labelHeight = 44;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.searchView.bounds) - 100,
                                                               20, labelWidth, labelHeight)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"游猫";
    [self.searchView addSubview:label];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected)];
    singleTap.numberOfTapsRequired = 1;
    [self.searchView setUserInteractionEnabled:YES];
    [self.searchView addGestureRecognizer:singleTap];
    
    [self.searchView setHidden:YES];
    self.searchViewHideDone = YES;
    self.searchViewShowDone = NO;
    self.searchViewContentsInsetsDone = NO;
    
    [self addSubview:self.searchView];
}

- (OTCover*)initWithTableViewWithHeaderImage:(UIImage*)headerImage withOTCoverHeight:(CGFloat)height
{
    CGRect originBounds = [[UIScreen mainScreen] bounds];
    CGRect bounds = CGRectMake(originBounds.origin.x, originBounds.origin.y, originBounds.size.width, originBounds.size.height - 49);
    self = [[OTCover alloc] initWithFrame:bounds];
    
    self.headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, bounds.size.width, height)];
    [self.headerImageView setImage:headerImage];
    
     
    [self addSubview:self.headerImageView];
    
    self.OTCoverHeight = height;
    
    self.tableView = [[UITableView alloc] initWithFrame:self.frame];
    self.tableView.bounces = YES;
    self.tableView.tableHeaderView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, bounds.size.width, height)];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    
    
    CGFloat searchWidth = 320;
    CGFloat searchHeight = 40;
    
    UIImageView *searchImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.bounds) - searchWidth / 2, 100, searchWidth, searchHeight)];
    searchImageView.image = [UIImage imageNamed:@"Searchbar6P.png"];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected)];
    singleTap.numberOfTapsRequired = 1;
    [searchImageView setUserInteractionEnabled:YES];
    [searchImageView addGestureRecognizer:singleTap];
    
    [self.tableView addSubview:searchImageView];
    
    
    [self addSubview:self.tableView];
    
    [self.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    
    self.blurImages = [[NSMutableArray alloc] init];
    [self prepareForBlurImages];
    
    [self initSearchView];
    
    return self;
}


- (void)setHeaderImage:(UIImage *)headerImage{
    [self.headerImageView setImage:headerImage];
    [self.blurImages removeAllObjects];
    [self prepareForBlurImages];
}

- (void)prepareForBlurImages
{
    CGFloat factor = 0.1;
    [self.blurImages addObject:self.headerImageView.image];
    for (NSUInteger i = 0; i < self.OTCoverHeight/10; i++)
    {
        [self.blurImages addObject:[self.headerImageView.image boxblurImageWithBlur:factor]];
        factor+=0.04;
    }
}

- (void)hideSearchView
{
    if(self.searchViewHideDone == NO)
    {
        self.searchViewHideDone = YES;
        self.searchViewShowDone = NO;
        
        self.searchView.alpha = 0.0f;
        [self.searchView setHidden:YES];
        
        self.searchViewContentsInsetsDone = NO;
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
}

- (void)showSearchView
{
    if(self.searchViewShowDone == NO)
    {
        self.searchViewShowDone = YES;
        self.searchViewHideDone = NO;
        
        [self.searchView setHidden:NO];
    }
}

- (void)setTableContentsInsets
{
    self.searchView.alpha = 1.0f;
    
    if(self.searchViewContentsInsetsDone == NO)
    {
        self.searchViewContentsInsetsDone = YES;
        
        //self.searchView.frame = CGRectMake(0, 0, self.bounds.size.width, 64);
        self.searchView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64);
        
        UIEdgeInsets insets = self.tableView.contentInset;
        insets.top = self.searchView.bounds.size.height;
        [self.tableView setContentInset:insets];
    }
}

- (void)animationForTableView
{
    CGFloat offset = self.tableView.contentOffset.y;    
    //NSLog(@"Y offset: %f", offset);
    
    if(offset < 0)
    {
        // 拉伸效果
        self.headerImageView.frame = CGRectMake(offset,0, self.frame.size.width+ (-offset) * 2, self.OTCoverHeight + (-offset));
    }
    if(offset > 0)
    {
        // 将headerImageView向屏幕上方推出
        self.headerImageView.frame = CGRectMake(0, -offset, self.headerImageView.frame.size.width, self.headerImageView.frame.size.height);
        
        if(offset < 64)
        {
            [self hideSearchView];
        }
        if(offset >= 64 && offset <= 114)
        {
            [self showSearchView];
            
            CGFloat delta = offset - 64; // 0 <= delta <= 50
            self.searchView.frame = CGRectMake((delta - 50) / 2.0f, 0, [UIScreen mainScreen].bounds.size.width + (50 - delta), 64);
            self.searchView.alpha = delta / 50;
        }
        if(offset > 114)
        {
            [self setTableContentsInsets];
        }
    }
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (self.tableView) {
        [self animationForTableView];
    }
}

- (void)removeFromSuperview
{
    if (self.tableView) {
        [self.tableView removeObserver:self forKeyPath:@"contentOffset"];
    }
    [super removeFromSuperview];
}

- (void)dealloc
{
    if (self.tableView) {
        [self.tableView removeObserver:self forKeyPath:@"contentOffset"];
    }
}

@end


@implementation UIImage (Blur)

-(UIImage *)boxblurImageWithBlur:(CGFloat)blur {
    
    NSData *imageData = UIImageJPEGRepresentation(self, 1); // convert to jpeg
    UIImage* destImage = [UIImage imageWithData:imageData];
    
    
    if (blur < 0.f || blur > 1.f) {
        blur = 0.5f;
    }
    int boxSize = (int)(blur * 40);
    boxSize = boxSize - (boxSize % 2) + 1;
    
    CGImageRef img = destImage.CGImage;
    
    vImage_Buffer inBuffer, outBuffer;
    
    vImage_Error error;
    
    void *pixelBuffer;
    
    
    //create vImage_Buffer with data from CGImageRef
    
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    //create vImage_Buffer for output
    
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    
    if(pixelBuffer == NULL)
        NSLog(@"No pixelbuffer");
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    // Create a third buffer for intermediate processing
    void *pixelBuffer2 = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    vImage_Buffer outBuffer2;
    outBuffer2.data = pixelBuffer2;
    outBuffer2.width = CGImageGetWidth(img);
    outBuffer2.height = CGImageGetHeight(img);
    outBuffer2.rowBytes = CGImageGetBytesPerRow(img);
    
    //perform convolution
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer2, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    error = vImageBoxConvolve_ARGB8888(&outBuffer2, &inBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             (CGBitmapInfo)kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    free(pixelBuffer2);
    CFRelease(inBitmapData);
    
    CGImageRelease(imageRef);
    
    return returnImage;
}


@end
