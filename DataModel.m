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
        //[communityDict setObject:[innerArray objectAtIndex:4] forKey:CommunityImageKey];
        
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
    NSArray *images3 = @[
                         @[@"boston1.jpg", @"boston2.jpg", @"boston3.jpg", @"boston4.jpg"],
                         @[@"manhattan1.jpg", @"manhattan2.jpg", @"manhattan3.jpg", @""],
                         @[@"EmpireStateBuilding1.jpg", @"EmpireStateBuilding2.jpg", @"EmpireStateBuilding3.jpg", @""],
                         @[@"oticket1.jpg", @"oticket2.jpg", @"oticket3.jpg", @""],
                         @[@"sailing1.jpg", @"sailing2.jpg", @"sailing3.jpg", @"sailing4.jpg"],
                         @[@"Lshow1.jpg", @"Lshow2.jpg", @"Lshow3.jpg", @""],
                         @[@"havel1.jpg", @"havel2.jpg", @"havel3.jpg", @""],
                         @[@"kapalaidive1.jpg", @"kapalaidive2.jpg", @"kapalaidive3.jpg", @""],
                         @[@"langkawi1.jpg", @"langkawi2.jpg", @"langkawi3.jpg", @"langkawi4.jpg"],
                         @[@"disney1.jpg", @"disney2.jpg", @"disney3.jpg", @""]
                         ];
    
    NSArray *descriptions = @[@"产品特色：直升机带您自由翱翔在城市上空，透过超大型窗户将曼哈顿全程全貌尽收眼底，与著名景观和建筑近距离接触。旅程最后，还赠送一张纪念照片哦\n出发地点：航班从市区直升机场（Downtown Heliport）起飞，位于河东（East River）六号码头（Pier 6）\n出发时间：每半小时/1小时起飞\n周一至周五：9am - 5pm, 最后一班航班于5pm起飞\n周六：9am - 6pm, 最后一班航班于5:30pm起飞\n周日、公定假日：9am - 5pm, 最后一班航班于4pm起飞\n抵达纽约后，请尽快致电旅游承运商，确定起飞时间\n特别提示: 受桑迪飓风影响，直升机场受到破坏，日落后航班一律不得降落，因此最后一班航班的起飞时间有可能根据季节而调整。\n周一至周五：9am - 5pm, 最后一班航班于5pm起飞\n周六：9am - 6pm, 最后一班航班于5:30pm起飞\n周日、公定假日：9am - 5pm, 最后一班航班于4pm起飞\n\n抵达纽约后，请尽快致电旅游承运商，确定起飞时间\n\n特别提示: 受桑迪飓风影响，直升机场受到破坏，日落后航班一律不得降落，因此最后一班航班的起飞时间有可能根据季节而调整。 所有的起飞时间均为参考时间，具体起飞时间可能因天气因素和飞机载重的限制而有所调整\n回程信息：返回到原出发地\n营业时间：每天",
                              @"产品特色：直升机带您自由翱翔在城市上空，透过超大型窗户将曼哈顿全程全貌尽收眼底，与著名景观和建筑近距离接触。旅程最后，还赠送一张纪念照片哦！\n出发地点：航班从市区直升机场（Downtown Heliport）起飞，位于河东（East River）六号码头（Pier 6）\n出发时间：每半小时/1小时起飞\n周一至周五：9am - 5pm, 最后一班航班于5pm起飞\n周六：9am - 6pm, 最后一班航班于5:30pm起飞\n周日、公定假日：9am - 5pm, 最后一班航班于4pm起飞\n\n抵达纽约后，请尽快致电旅游承运商，确定起飞时间\n\n特别提示: 受桑迪飓风影响，直升机场受到破坏，日落后航班一律不得降落，因此最后一班航班的起飞时间有可能根据季节而调整。\n\n周一至周五：9am - 5pm, 最后一班航班于5pm起飞\n周六：9am - 6pm, 最后一班航班于5:30pm起飞\n周日、公定假日：9am - 5pm, 最后一班航班于4pm起飞\n\n抵达纽约后，请尽快致电旅游承运商，确定起飞时间\n\n特别提示: 受桑迪飓风影响，直升机场受到破坏，日落后航班一律不得降落，因此最后一班航班的起飞时间有可能根据季节而调整。 所有的起飞时间均为参考时间，具体起飞时间可能因天气因素和飞机载重的限制而有所调整\n回程信息：返回到原出发地\n营业时间：每天",
                              @"产品介绍：帝国大厦实体票将带您前往帝国大厦中的飞行影院和86层观景台，从不同的角度体验纽约。\n【帝国大厦86层观景台】\n帝国大厦已经不再是世界上坐高的摩天大楼，但依然是最为经典的那一个。有着丰富历史的Art Deco建筑风格使102层高的帝国大厦成为游客的必到景点。帝国大厦始建于1931年，约433米高。在晴天，您可以从86层的观景台上看到80英里以外的景色，比如康涅狄格州、新泽西州、宾夕法尼亚州、马萨诸塞州。\n由于帝国大厦游客众多，您通过使用该套票可省掉排队，直接节省1至2小时的等待时间！另外，您在游览帝国大厦期间将获得语音导览器，语音导览器会对您所在的位置进行音频和视频的讲解，里面会标注附近有趣的地点，让您在帝国大厦玩得更开心。\n【飞行影院动感电影体验】\n飞行影院位于帝国大厦2楼，为游客带去激动人心的数码体验。该动感4D电影集模拟飞行和空中历险于一体，6米超大屏幕给您带来最具震撼力的画面冲击力！在整个体验过程中，首先是两个7分钟的热身影片，第一个影片展示了纽约最著名的十大景观；第二个影片介绍了帝国大厦的历史。最后就是为时14分钟名叫“纽约空中之旅”的动感4D体验，让您身临其境的从纽约上空飞过。\n（影院开放时间：8am～10pm)\n\n如果您购买的是观景台和“飞行影院动感电影”的套票，就可以从33街的一个独立入口进入帝国大厦（无需排队）。经过安全检查后，体验完“空中之旅”后便可前往观景电梯口，排在观景台参观等候队伍的最前面。",
                              @"产品介绍：1. 《O》秀的灵感源自天然水的纯净与优雅，并且通过描绘最简朴的街道以及最奢华的歌剧演绎出剧院本身的美；在这里，一切皆有可能；在这里，戏剧般的生活正在你眼前鲜活地上演。\n2. 选择附加信息查看座位图：\n蓝色-B等座\n红色-C等座\n紫色-D等座\n3. 请注意：实际座位及其如何按照类别划分如有变更，恕不另行通知\n4. 演出时间为每周三至周日\n5. 演出时长为90分钟",
                              @"产品特色：直升机带您自由翱翔在城市上空，透过超大型窗户将曼哈顿全程全貌尽收眼底，与著名景观和建筑近距离接触。旅程最后，还赠送一张纪念照片哦\n出发地点：航班从市区直升机场（Downtown Heliport）起飞，位于河东（East River）六号码头（Pier 6）\n出发时间：每半小时/1小时起飞\n周一至周五：9am - 5pm, 最后一班航班于5pm起飞\n周六：9am - 6pm, 最后一班航班于5:30pm起飞\n周日、公定假日：9am - 5pm, 最后一班航班于4pm起飞\n抵达纽约后，请尽快致电旅游承运商，确定起飞时间\n特别提示: 受桑迪飓风影响，直升机场受到破坏，日落后航班一律不得降落，因此最后一班航班的起飞时间有可能根据季节而调整。\n周一至周五：9am - 5pm, 最后一班航班于5pm起飞\n周六：9am - 6pm, 最后一班航班于5:30pm起飞\n周日、公定假日：9am - 5pm, 最后一班航班于4pm起飞\n\n抵达纽约后，请尽快致电旅游承运商，确定起飞时间\n\n特别提示: 受桑迪飓风影响，直升机场受到破坏，日落后航班一律不得降落，因此最后一班航班的起飞时间有可能根据季节而调整。 所有的起飞时间均为参考时间，具体起飞时间可能因天气因素和飞机载重的限制而有所调整\n回程信息：返回到原出发地\n营业时间：每天",
                              @"产品特色：90分钟香艳秀场，近百名魔鬼身材的性感美女上演精彩的“上空秀”，火辣爆表，怎能错过！上空秀自1981年开演以来，口碑一直很好，票房也一支独秀，是这座罪恶之城历史最为悠久的表演秀，并被碧昂斯创意总监设计的新的舞蹈动作和故事情节刷新纪录。曼妙的身材、精致豪华的舞台设计，训练有素的舞台演出、热闹紧凑的内容……都是吸引观众的卖点！还可以重现泰坦尼克等举世有名的场面！",
                              @"产品特色：如果你正在考虑哈佛大学，或者你只是想看看这所常春藤联盟学校的学生生活是怎样的，那这一个小时的“Hahvahd”之旅绝对是为您设计的！可以听到哈佛在校大学生独家爆料大学生活，他将从内幕人员的视角，精彩绝伦的讲解哈佛学生生活的情景。还可以参观历史建筑，游览哈佛校园和哈佛广场，聆听学校历史掌故，了解学校知名人物。您可以选择参观哈佛自然史博物馆去体验哈佛之旅或先去参观哈佛自然史博物馆，然后到任吃到饱的冰火餐厅享用午餐，二选一。",
                              @"产品特色：直升机带您自由翱翔在城市上空，透过超大型窗户将曼哈顿全程全貌尽收眼底，与著名景观和建筑近距离接触。旅程最后，还赠送一张纪念照片哦\n出发地点：航班从市区直升机场（Downtown Heliport）起飞，位于河东（East River）六号码头（Pier 6）\n出发时间：每半小时/1小时起飞\n周一至周五：9am - 5pm, 最后一班航班于5pm起飞\n周六：9am - 6pm, 最后一班航班于5:30pm起飞\n周日、公定假日：9am - 5pm, 最后一班航班于4pm起飞\n抵达纽约后，请尽快致电旅游承运商，确定起飞时间\n特别提示: 受桑迪飓风影响，直升机场受到破坏，日落后航班一律不得降落，因此最后一班航班的起飞时间有可能根据季节而调整。\n周一至周五：9am - 5pm, 最后一班航班于5pm起飞\n周六：9am - 6pm, 最后一班航班于5:30pm起飞\n周日、公定假日：9am - 5pm, 最后一班航班于4pm起飞\n\n抵达纽约后，请尽快致电旅游承运商，确定起飞时间\n\n特别提示: 受桑迪飓风影响，直升机场受到破坏，日落后航班一律不得降落，因此最后一班航班的起飞时间有可能根据季节而调整。 所有的起飞时间均为参考时间，具体起飞时间可能因天气因素和飞机载重的限制而有所调整\n回程信息：返回到原出发地\n营业时间：每天",
                              @"产品特色：直升机带您自由翱翔在城市上空，透过超大型窗户将曼哈顿全程全貌尽收眼底，与著名景观和建筑近距离接触。旅程最后，还赠送一张纪念照片哦\n出发地点：航班从市区直升机场（Downtown Heliport）起飞，位于河东（East River）六号码头（Pier 6）\n出发时间：每半小时/1小时起飞\n周一至周五：9am - 5pm, 最后一班航班于5pm起飞\n周六：9am - 6pm, 最后一班航班于5:30pm起飞\n周日、公定假日：9am - 5pm, 最后一班航班于4pm起飞\n抵达纽约后，请尽快致电旅游承运商，确定起飞时间\n特别提示: 受桑迪飓风影响，直升机场受到破坏，日落后航班一律不得降落，因此最后一班航班的起飞时间有可能根据季节而调整。\n周一至周五：9am - 5pm, 最后一班航班于5pm起飞\n周六：9am - 6pm, 最后一班航班于5:30pm起飞\n周日、公定假日：9am - 5pm, 最后一班航班于4pm起飞\n\n抵达纽约后，请尽快致电旅游承运商，确定起飞时间\n\n特别提示: 受桑迪飓风影响，直升机场受到破坏，日落后航班一律不得降落，因此最后一班航班的起飞时间有可能根据季节而调整。 所有的起飞时间均为参考时间，具体起飞时间可能因天气因素和飞机载重的限制而有所调整\n回程信息：返回到原出发地\n营业时间：每天",
                              @"产品特色：这是华特迪士尼创建的第一座原创主题公园，是地球上最欢乐的地方。进入其中的每一个园区，熟悉的电影画面也就随之栩栩如生地展现您的面前，您会不断发掘这个神奇、幻想世界里的奥妙。加州冒险乐园以您从未想象过的方式，发掘您喜爱的迪士尼故事和卡通人物。和各个熟悉的卡通人物一起参加丰富多彩的冒险活动，开启新鲜有趣的体验活动。"
                              ];
    
    //for(NSString *s in array3)
    for(int i = 0; i < [array3 count]; i++)
    {
        NSString *s = [array3 objectAtIndex:i];
        dict = [[NSMutableDictionary alloc] init];
        
        [dict setObject:s forKey:@"name"];
        
        NSArray *innerArray = [images3 objectAtIndex:i];
        [dict setObject:[innerArray objectAtIndex:0] forKey:@"image1"];
        [dict setObject:[innerArray objectAtIndex:1] forKey:@"image2"];
        [dict setObject:[innerArray objectAtIndex:2] forKey:@"image3"];
        [dict setObject:[innerArray objectAtIndex:3] forKey:@"image4"];
        
        [dict setObject:[descriptions objectAtIndex:i] forKey:@"description"];
        
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
                        @"中东",
                       @"加勒比"];
    
    NSArray *images = @[@[@"Menu1.jpg", @"Menu2.jpg", @"Menu3.jpg", @"Menu4.jpg"],
                        @[@"NorthAmerica1.jpg", @"NorthAmerica2.jpg", @"NorthAmerica3.jpg", @"NorthAmerica4.jpg"],
                        @[@"Europe1.jpg", @"Europe2.jpg", @"Europe3.jpg", @"Europe4.jpg"],
                        @[@"Asia1.jpg", @"Asia2.jpg", @"Asia3.jpg", @"Asia4.jpg"],
                        @[@"Oceania1.jpg", @"Oceania2.jpg", @"Oceania3.jpg", @"Oceania4.jpg"],
                        @[@"SouthAmerica1.jpg", @"SouthAmerica2.jpg", @"SouthAmerica3.jpg", @"SouthAmerica4.jpg"],
                        @[@"Africa1.jpg", @"Africa2.jpg", @"Africa3.jpg", @"Africa4.jpg"],
                        @[@"MiddleEast1.jpg", @"MiddleEast2.jpg", @"MiddleEast3.jpg", @"MiddleEast4.jpg"],
                        @[@"Carribbean1.jpg", @"Carribbean2.jpg", @"Carribbean3.jpg", @"Carribbean4.jpg"]];

    //int i = 0;
    for(int i = 0; i < [array1 count]; i++)
    //for(NSString *s in array1)
    {
        NSString *s = [array1 objectAtIndex:i];
        dict = [[NSMutableDictionary alloc] init];
        
        [dict setObject:s forKey:CommunityIDKey];
        [dict setObject:s forKey:CommunityNameKey];
        [dict setObject:@"" forKey:CommunityAreaKey];
        [dict setObject:@"" forKey:CommunityDescKey];
        
        NSArray *innerArray = [images objectAtIndex:i];
        if([innerArray count] > 0)
        {
            [dict setObject:[[images objectAtIndex:i] objectAtIndex:0] forKey:CommunityImage1Key];
            [dict setObject:[[images objectAtIndex:i] objectAtIndex:1] forKey:CommunityImage2Key];
            [dict setObject:[[images objectAtIndex:i] objectAtIndex:2] forKey:CommunityImage3Key];
            [dict setObject:[[images objectAtIndex:i] objectAtIndex:3] forKey:CommunityImage4Key];
        } else {
            [dict setObject:@"" forKey:CommunityImage1Key];
            [dict setObject:@"" forKey:CommunityImage2Key];
            [dict setObject:@"" forKey:CommunityImage3Key];
            [dict setObject:@"" forKey:CommunityImage4Key];
        }
        
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
    
    NSArray *images2 = @[@"special.png",
                         @"outdoor.png",
                         @"team.jpg",
                         @"car.png",
                         @"ticket.png",
                         @"show.png",
                         @"game.png",
                         @"food.png",
                         @"special.png",
                         @"ticket.png",
                         @"team.jpg",
                         @"show.png",
                         @"hostel.png",
                         @"car.png",
                         @"ticket.png",
                         @"wifi.png",
                         @"car.png",
                         @"picture.png",
                         @"visa.png",
                         ];
    
    //for(NSString *s in array2)
    for(int i = 0; i < [array2 count]; i++)
    {
        NSString *s = [array2 objectAtIndex:i];
        dict = [[NSMutableDictionary alloc] init];
        
        [dict setObject:s forKey:@"name"];
        [dict setObject:[images2 objectAtIndex:i] forKey:@"image"];
        
        [self.categories addObject:dict];
    }
    
    [self saveDataModel];
}

@end
