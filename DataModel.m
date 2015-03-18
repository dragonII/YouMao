//
//  DataModel.m
//  BinFenV10
//
//  Created by Wang Long on 3/3/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import "DataModel.h"
#import "AppDelegate.h"
#import "AFNetworking.h"

static NSString *GarbageString = @"Thread was being aborted.";

static NSString *CommunityArrayKey = @"Communities";
static NSString *ShopArrayKey = @"Shops";
static NSString *CategoryArrayKey = @"Categories";
static NSString *ProductArrayKey = @"Products";

@interface DataModel ()

@property dispatch_group_t retrieveGroup;

@end

@implementation DataModel

- (id)init
{
    self = [super init];
    if (self)
    {
        self.loadShopsFinished = NO;
        self.loadCommunitiesFinished = NO;
        self.loadProductsFinished = NO;
        self.httpSessionManager = [AppDelegate sharedHttpSessionManager];
    }
    return self;
}

// Returns the path to DataModel.plist file in the app's Documents directory
- (NSString *)dataModelPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = paths[0];
    return [documentDirectory stringByAppendingPathComponent:@"DataModel.plist"];
}

- (NSString *)stringByRemovingControlCharacters: (NSString *)inputString
{
    NSCharacterSet *controlChars = [NSCharacterSet controlCharacterSet];
    NSRange range = [inputString rangeOfCharacterFromSet:controlChars];
    if (range.location != NSNotFound) {
        NSMutableString *mutable = [NSMutableString stringWithString:inputString];
        while (range.location != NSNotFound) {
            [mutable deleteCharactersInRange:range];
            range = [mutable rangeOfCharacterFromSet:controlChars];
        }
        return mutable;
    }
    return inputString;
}

- (NSArray *)prepareForParse:(id)responseObject
{
    NSString *rawString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
    
    NSString *noEscapedString = [self stringByRemovingControlCharacters:rawString];
    
    NSString *cleanString = [noEscapedString stringByReplacingOccurrencesOfString:GarbageString withString:@""];
    cleanString = [cleanString stringByReplacingOccurrencesOfString:@"\'" withString:@"\""];
    //NSLog(@"cleanString: %@", cleanString);
    
    NSData *data = [cleanString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    
    if(error)
    {
        NSLog(@"Error: %@", error);
        return nil;
    }
    
    NSArray *outerArray = [json objectForKey:@"data"];
    return outerArray;
}

- (void)parseShopJson:(id)responseObject
{
    NSArray *outerArray = [self prepareForParse:responseObject];
    if(outerArray == nil)
    {
        _loadShopsFailed = YES;
        return;
    } else {
        _loadShopsFailed = NO;
    }
    self.shops = [[NSMutableArray alloc] init];
    NSMutableDictionary *shopDict;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"URLs" ofType:@"plist"];
    NSArray *urlArray = [NSArray arrayWithContentsOfFile:path];
    NSString *baseURLString = (NSString *)[[urlArray objectAtIndex:0] objectForKey:@"url"];
    
    for(NSArray *innerArray in outerArray)
    {
        shopDict = [[NSMutableDictionary alloc] init];
        
        //[storeDict setObject:[innerArray objectAtIndex:0] forKey:StoreImageKey];
        [shopDict setObject:[baseURLString stringByAppendingPathComponent:[innerArray objectAtIndex:0]] forKey:StoreImageKey];
        [shopDict setObject:[innerArray objectAtIndex:1] forKey:StoreIDKey];
        [shopDict setObject:[innerArray objectAtIndex:2] forKey:StoreNameKey];
        [shopDict setObject:[innerArray objectAtIndex:3] forKey:StoreSNameKey];
        [shopDict setObject:[innerArray objectAtIndex:4] forKey:StoreTypeKey];
        [shopDict setObject:[innerArray objectAtIndex:5] forKey:StoreOfCommunityKey];
        [shopDict setObject:[innerArray objectAtIndex:6] forKey:StoreAddrCountryKey];
        [shopDict setObject:[innerArray objectAtIndex:7] forKey:StoreAddrProviceKey];
        [shopDict setObject:[innerArray objectAtIndex:8] forKey:StoreAddrCityKey];
        [shopDict setObject:[innerArray objectAtIndex:9] forKey:StoreAddrStreetKey];
        [shopDict setObject:[innerArray objectAtIndex:10] forKey:StoreStatusKey];
        
        [self.shops addObject:shopDict];
    }
    
    [self saveDataModel];
}

- (void)parseCommunityJson:(id)responseObject
{
    NSArray *outerArray = [self prepareForParse:responseObject];
    if(outerArray == nil)
    {
        _loadCommunitiesFailed = YES;
        return;
    } else {
        _loadCommunitiesFailed = NO;
    }
    self.communities = [[NSMutableArray alloc] init];
    NSMutableDictionary *communityDict;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"URLs" ofType:@"plist"];
    NSArray *urlArray = [NSArray arrayWithContentsOfFile:path];
    NSString *baseURLString = (NSString *)[[urlArray objectAtIndex:0] objectForKey:@"url"];
    
    for(NSArray *innerArray in outerArray)
    {
        communityDict = [[NSMutableDictionary alloc] init];
        
        //[communityDict setObject:[baseURLString stringByAppendingPathComponent:[innerArray objectAtIndex:0]] forKey:StoreImageKey];
        [communityDict setObject:[innerArray objectAtIndex:0] forKey:CommunityIDKey];
        [communityDict setObject:[innerArray objectAtIndex:1] forKey:CommunityNameKey];
        [communityDict setObject:[innerArray objectAtIndex:2] forKey:CommunityAreaKey];
        [communityDict setObject:[innerArray objectAtIndex:3] forKey:CommunityDescKey];
        [communityDict setObject:[innerArray objectAtIndex:4] forKey:CommunityImageKey];
        
        [self.communities addObject:communityDict];
    }
    
    [self saveDataModel];
}

- (void)parseProductJson:(id)responseObject
{
    NSArray *outerArray = [self prepareForParse:responseObject];
    
    if(outerArray == nil)
    {
        _loadProductsFailed = YES;
        return;
    } else {
        _loadProductsFailed = NO;
    }
    
    self.products = [[NSMutableArray alloc] init];
    NSMutableDictionary *productDict;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"URLs" ofType:@"plist"];
    NSArray *urlArray = [NSArray arrayWithContentsOfFile:path];
    NSString *baseURLString = (NSString *)[[urlArray objectAtIndex:0] objectForKey:@"url"];
    
    for(NSArray *innerArray in outerArray)
    {
        productDict = [[NSMutableDictionary alloc] init];
        
        //[productDict setObject:[baseURLString stringByAppendingPathComponent:[innerArray objectAtIndex:0]] forKey:StoreImageKey];
        [productDict setObject:[innerArray objectAtIndex:0] forKey:ProductIDKey];
        [productDict setObject:[innerArray objectAtIndex:1] forKey:ProductNameKey];
        [productDict setObject:[baseURLString stringByAppendingPathComponent:[innerArray objectAtIndex:2]] forKey:ProductImageKey];
        [productDict setObject:[innerArray objectAtIndex:3] forKey:ProductBrandKey];
        [productDict setObject:[innerArray objectAtIndex:4] forKey:ProductCategoryKey];
        [productDict setObject:[innerArray objectAtIndex:5] forKey:ProductRefencePriceKey];
        [productDict setObject:[innerArray objectAtIndex:6] forKey:ProductSalePrice];
        [productDict setObject:[innerArray objectAtIndex:7] forKey:ProductShopKey];
        
        [self.products addObject:productDict];
    }
    
    [self saveDataModel];
}

- (void)parseCommentsJson:(id)responseObject
{
    NSArray *outerArray = [self prepareForParse:responseObject];
    
    if(outerArray == nil)
    {
        return;
    }
    
    self.comments = [[NSMutableArray alloc] init];
    NSMutableDictionary *commentsDict;
    
    
    for(NSArray *innerArray in outerArray)
    {
        commentsDict = [[NSMutableDictionary alloc] init];
        
        [commentsDict setObject:[innerArray objectAtIndex:0] forKey:CommentProductIDKey];
        [commentsDict setObject:[innerArray objectAtIndex:1] forKey:CommentContentKey];
        [commentsDict setObject:[innerArray objectAtIndex:2] forKey:CommentTimeKey];
        [commentsDict setObject:[innerArray objectAtIndex:3] forKey:CommentUserKey];
        
        [self.comments addObject:commentsDict];
    }
}

- (void)parseCategoryJson:(id)responseObject
{
    NSArray *outerArray = [self prepareForParse:responseObject];
    
    if(outerArray == nil)
    {
        _loadCategoriesFailed = YES;
        return;
    } else {
        _loadCategoriesFailed = NO;
    }
    
    self.categories = [[NSMutableArray alloc] init];
    
    /*
    NSMutableDictionary *commentsDict;
    
    
    for(NSArray *innerArray in outerArray)
    {
        commentsDict = [[NSMutableDictionary alloc] init];
        
        [commentsDict setObject:[innerArray objectAtIndex:0] forKey:CommentProductIDKey];
        [commentsDict setObject:[innerArray objectAtIndex:1] forKey:CommentContentKey];
        [commentsDict setObject:[innerArray objectAtIndex:2] forKey:CommentTimeKey];
        [commentsDict setObject:[innerArray objectAtIndex:3] forKey:CommentUserKey];
        
        [self.comments addObject:commentsDict];
    }
     */
}


- (void)loadDataModelRemotely
{
    _retrieveGroup = dispatch_group_create();
    
    self.loadCommunitiesFailed = YES;
    self.loadShopsFailed = YES;
    self.loadProductsFailed = YES;
    self.loadCategoriesFailed = YES;
    
    [self loadShopsData];
    [self loadCommunitiesData];
    [self loadProductsData];
    [self loadCategoriesData];
    
    //[self saveDataModel];
}

- (void)loadCategoriesData
{
    {
        dispatch_group_notify(_retrieveGroup, dispatch_get_main_queue(), ^{
            [self.httpSessionManager GET:@"productcatalog/cataloglist_json.ds"
                              parameters:nil
                                 success:^(NSURLSessionDataTask *task, id responseObject) {
                                     [self parseCategoryJson:responseObject];
                                     //dispatch_group_leave(_retrieveGroup);
                                     _loadCategoriesFinished = YES;
                                 }failure:^(NSURLSessionDataTask *task, NSError *error) {
                                     NSLog(@"Error: %@", [error localizedDescription]);
                                     //dispatch_group_leave(_retrieveGroup);
                                 }];
        });
    }
}

- (void)loadProductsData
{
    {
        dispatch_group_notify(_retrieveGroup, dispatch_get_main_queue(), ^{
            [self.httpSessionManager GET:@"lsproduct/product_json.ds"
                              parameters:nil
                                 success:^(NSURLSessionDataTask *task, id responseObject) {
                                     [self parseProductJson:responseObject];
                                     //dispatch_group_leave(_retrieveGroup);
                                     _loadProductsFinished = YES;
                                 }failure:^(NSURLSessionDataTask *task, NSError *error) {
                                     NSLog(@"Error: %@", [error localizedDescription]);
                                     //dispatch_group_leave(_retrieveGroup);
                                 }];
        });
    }
}


- (void)loadShopsData
{
    dispatch_group_notify(_retrieveGroup, dispatch_get_main_queue(), ^{
        [self.httpSessionManager GET:@"myinfo/shopinfolist_json.ds"
                          parameters:nil
                             success:^(NSURLSessionDataTask *task, id responseObject) {
                                 [self parseShopJson:responseObject];
                                 //dispatch_group_leave(_retrieveGroup);
                                 _loadShopsFinished = YES;
                             }failure:^(NSURLSessionDataTask *task, NSError *error) {
                                 NSLog(@"Error: %@", [error localizedDescription]);
                                 //dispatch_group_leave(_retrieveGroup);
                             }];
    });
}

- (void)loadCommunitiesData
{
    dispatch_group_notify(_retrieveGroup, dispatch_get_main_queue(), ^{
        [self.httpSessionManager GET:@"community/communitylist_json.ds"
                          parameters:nil
                             success:^(NSURLSessionDataTask *task, id responseObject) {
                                 [self parseCommunityJson:responseObject];
                                 //dispatch_group_leave(_retrieveGroup);
                                 _loadCommunitiesFinished = YES;
                             }failure:^(NSURLSessionDataTask *task, NSError *error) {
                                 NSLog(@"Error: %@", [error localizedDescription]);
                                 //dispatch_group_leave(_retrieveGroup);
                             }];
    });
}



- (void)loadDataModelLocally
{
    NSString *path = [self dataModelPath];
    if([[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        // We store the DataModel in a plist file inside the app's Documents
        // directory. The Data object conforms to the NSCoding protocol,
        // which means that it can "freeze" itself into a data structure that
        // can be saved into a plist file. So can the NSMutableArray that holds
        // these Data objects. We we load the plist back in, the array and
        // its Data "unfreeze" and are restored to their old state.
        
        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        
        self.communities = [unarchiver decodeObjectForKey:CommunityArrayKey];
        self.shops = [unarchiver decodeObjectForKey:ShopArrayKey];
        self.categories = [unarchiver decodeObjectForKey:CategoryArrayKey];
        self.products = [unarchiver decodeObjectForKey:ProductArrayKey];
        
        [unarchiver finishDecoding];
    } else {
        self.communities = [[NSMutableArray alloc] init];
        self.shops = [[NSMutableArray alloc] init];
        self.categories = [[NSMutableArray alloc] init];
        self.products = [[NSMutableArray alloc] init];
    }
}

- (void)saveDataModel
{
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    
    [archiver encodeObject:self.communities forKey:CommunityArrayKey];
    [archiver encodeObject:self.shops forKey:ShopArrayKey];
    [archiver encodeObject:self.categories forKey:CategoryArrayKey];
    [archiver encodeObject:self.products forKey:ProductArrayKey];
    
    [archiver finishEncoding];
    
    [data writeToFile:[self dataModelPath] atomically:YES];
}

- (void)loadCommentsByProductID:(NSString *)productID
{
    //plsp_value=00000001
    NSDictionary *params = @{@"plsp_value":productID};
    _loadCommentsFinished = NO;
    
        [self.httpSessionManager GET:@"comment/commentlist_json.ds"
                          parameters:params
                             success:^(NSURLSessionDataTask *task, id responseObject) {
                                 [self parseCommentsJson:responseObject];
                                 //dispatch_group_leave(_retrieveGroup);
                                 _loadCommentsFinished = YES;
                             }failure:^(NSURLSessionDataTask *task, NSError *error) {
                                 NSLog(@"Error: %@", [error localizedDescription]);
                                 //dispatch_group_leave(_retrieveGroup);
                             }];
}

- (void)loadingTestData
{
    NSMutableDictionary *dict;
    self.products = [[NSMutableArray alloc] init];
    
    NSArray *array3 = @[@"波士顿观鲸巡航",
                       @"曼哈顿直升机观光",
                       @"帝国大厦实体票",
                        @"太阳剧团《O》演出门票",
                        @"豪华双体船巡航",
                        @"拉斯维加斯性感上空秀",
                        @"哈佛大学校园漫步",
                        @"卡帕莱水屋度假村",
                        @"马来西亚兰卡威一日游",
                        @"迪士尼门票"];
    for(NSString *s in array3)
    {
        dict = [[NSMutableDictionary alloc] init];
        
        [dict setObject:s forKey:@"name"];
        [dict setObject:@"" forKey:@"image1"];
        [dict setObject:@"" forKey:@"image2"];
        
        [self.products addObject:dict];
    }
    
    self.communities = [[NSMutableArray alloc] init];
    
    NSArray *array1 = @[@"全球旅行目的地，\n172个国家和地区，\n536个城市",
                       @"北美洲",
                       @"欧洲",
                       @"亚洲",
                       @"大洋洲",
                       @"南美洲",
                       @"非洲",
                       @"中东"];

    for(NSString *s in array1)
    {
        dict = [[NSMutableDictionary alloc] init];
        
        [dict setObject:s forKey:CommunityIDKey];
        [dict setObject:s forKey:CommunityNameKey];
        [dict setObject:@"" forKey:CommunityAreaKey];
        [dict setObject:@"" forKey:CommunityDescKey];
        [dict setObject:@"" forKey:CommunityImageKey];
        
        [self.communities addObject:dict];
    }
    
    self.categories = [[NSMutableArray alloc] init];
    
    NSArray *array2 = @[@"特色体验",
                        @"户外探险",
                        @"当地参团",
                        @"自驾租车",
                        @"门票",
                        @"演出表演",
                        @"体育赛事",
                        @"美食",
                        @"体验课程",
                        @"购物折扣券",
                        @"当地导游",
                        @"当地商务翻译",
                        @"酒店客栈",
                        @"接送服务",
                        @"电话卡",
                        @"移动wifi网卡",
                        @"交通卡",
                        @"旅行保险",
                        @"签证"];
    
    for(NSString *s in array2)
    {
        dict = [[NSMutableDictionary alloc] init];
        
        [dict setObject:s forKey:@"name"];
        [dict setObject:@"" forKey:@"image"];
        
        [self.categories addObject:dict];
    }
    
    [self saveDataModel];
}

@end
