//
//  MessageViewController.m
//  BinFenV10
//
//  Created by Wang Long on 2/10/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import "MessageViewController.h"
#import "ConversationListCell.h"
#import "ChatViewController.h"

static NSString *ConversationCellIdentifier = @"ConversationCell";

@interface MessageViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *conversationList;

@end

@implementation MessageViewController

- (void)initNavigationItem
{
    UIColor *backgroundColor = [UIColor colorWithRed:70/255.0f green:159/255.0f blue:183/255.0f alpha:1.0f];
    self.navigationItem.title = @"消息";
    [self.navigationController.navigationBar setBarTintColor:backgroundColor];
    [self.navigationController.navigationBar setTranslucent:NO];
}

- (void)loadConversations
{
    self.conversationList = [[NSMutableArray alloc] init];
    
    for(int i = 0; i < 13; i++)
    {
        [self.conversationList addObject:[NSString stringWithFormat:@"对话%d", i + 1]];
    }
}

- (void)showLoginViewController
{
    [self performSegueWithIdentifier:@"FromMessageToLoginSegue" sender:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initNavigationItem];
    
    //[self showLoginViewController];
    
    [self loadConversations];
    
    [self initTableView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)initTableView
{
    CGFloat navigationBarHeight = self.navigationController.navigationBar.frame.size.height;
    CGFloat tabBarHeight = self.tabBarController.tabBar.frame.size.height;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,
                                                                   self.view.frame.size.width,
                                                                   self.view.frame.size.height - navigationBarHeight - tabBarHeight - 20)];
    
    UINib *nib = [UINib nibWithNibName:@"ConversationListCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:ConversationCellIdentifier];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
}

#pragma DataSource, Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.conversationList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 68.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ConversationListCell *cell = (ConversationListCell *)[tableView dequeueReusableCellWithIdentifier:ConversationCellIdentifier];
    if(cell == nil)
        cell = [[ConversationListCell alloc] init];
    cell.usernameLabel.text = [self.conversationList objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self performSegueWithIdentifier:@"ShowChatViewSegue" sender:self];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSLog(@"CommitEdit: %d", editingStyle);
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:indexPath.row];
        [self.conversationList removeObjectsAtIndexes:indexSet];
        //ConversationListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        //[tableView reloadData];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ChatViewController *chatVC = (ChatViewController *)segue.destinationViewController;
    chatVC.hidesBottomBarWhenPushed = YES;
}

@end
