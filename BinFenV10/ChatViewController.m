//
//  ChatViewController.m
//  BinFenV10
//
//  Created by Wang Long on 2/13/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import "ChatViewController.h"
#import "MessageData.h"

@interface ChatViewController () <JSMessagesViewDelegate, JSMessagesViewDataSource, UIActionSheetDelegate>

@property (strong, nonatomic) NSMutableArray *messageArray;

@end

@implementation ChatViewController

- (void)initNavigationItem
{
    self.navigationItem.title = @"对话";
}

- (void)testData{
    MessageData *message1 = [[MessageData alloc] initWithMsgId:@"0001" text:@"Test message in English" date:[NSDate date] msgType:JSBubbleMessageTypeIncoming mediaType:JSBubbleMediaTypeText img:nil];
    
    [self.messageArray addObject:message1];
    
    MessageData *message2 = [[MessageData alloc] initWithMsgId:@"0002" text:nil date:[NSDate date] msgType:JSBubbleMessageTypeOutgoing mediaType:JSBubbleMediaTypeImage img:@"demo.jpg"];
    
    [self.messageArray addObject:message2];
    
    MessageData *message3 = [[MessageData alloc] initWithMsgId:@"0003" text:@"中文消息测试" date:[NSDate date] msgType:JSBubbleMessageTypeOutgoing mediaType:JSBubbleMediaTypeText img:nil];
    
    [self.messageArray addObject:message3];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initNavigationItem];
    
    self.delegate = self;
    self.dataSource = self;
    
    self.messageArray = [[NSMutableArray alloc] init];
    
    [self testData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.messageArray count];
}

- (void)sendPressed:(UIButton *)sender withText:(NSString *)text
{
    int value = arc4random() % 1000;
    NSString *msgId = [NSString stringWithFormat:@"%d", value];
    
    JSBubbleMessageType msgType;
    if((self.messageArray.count - 1) % 2)
    {
        msgType = JSBubbleMessageTypeOutgoing;
        [JSMessageSoundEffect playMessageSentSound];
    } else {
        msgType = JSBubbleMessageTypeIncoming;
        [JSMessageSoundEffect playMessageReceivedSound];
    }
    
    MessageData *message = [[MessageData alloc]
                            initWithMsgId:msgId
                            text:text
                            date:[NSDate date]
                            msgType:msgType
                            mediaType:JSBubbleMediaTypeText
                            img:nil];

    [self.messageArray addObject:message];
    
    [self finishSend:NO];
                            
}

- (void)cameraPressed:(id)sender
{
    [self.inputToolBarView.textView resignFirstResponder];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"拍照", @"相册", nil];
    [actionSheet showInView:self.view];
}

#pragma mark -- UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
        case 1:
        {
            int value = arc4random() % 1000;
            NSString *msgId = [NSString stringWithFormat:@"%d", value];
            
            JSBubbleMessageType msgType;
            if((self.messageArray.count - 1) % 2)
            {
                msgType = JSBubbleMessageTypeOutgoing;
                [JSMessageSoundEffect playMessageSentSound];
            } else {
                msgType = JSBubbleMessageTypeIncoming;
                [JSMessageSoundEffect playMessageReceivedSound];
            }
            
            MessageData *message = [[MessageData alloc]
                                    initWithMsgId:msgId
                                    text:nil
                                    date:[NSDate date]
                                    msgType:msgType
                                    mediaType:JSBubbleMediaTypeImage
                                    img:@"demo.jpg"];
            
            [self.messageArray addObject:message];
            
            [self finishSend:YES];
        }
            break;
            
        default:
            break;
    }
}

- (JSBubbleMessageType)messageTypeForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageData *message = [self.messageArray objectAtIndex:indexPath.row];
    //NSLog(@"Row(%d):Type(%d)", indexPath.row, message.messageType);
    return message.messageType;
}

- (JSBubbleMessageStyle)messageStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return JSBubbleMessageStyleFlat;
}

- (JSBubbleMediaType)messageMediaTypeForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageData *message = [self.messageArray objectAtIndex:indexPath.row];
    return message.mediaType;
}

- (UIButton *)sendButton
{
    return [UIButton defaultSendButton];
}

- (JSMessagesViewTimestampPolicy)timestampPolicy
{
    
     //JSMessagesViewTimestampPolicyAll = 0,
     //JSMessagesViewTimestampPolicyAlternating,
     //JSMessagesViewTimestampPolicyEveryThree,
     //JSMessagesViewTimestampPolicyEveryFive,
     //JSMessagesViewTimestampPolicyCustom
    
    return JSMessagesViewTimestampPolicyEveryThree;
}

- (JSMessagesViewAvatarPolicy)avatarPolicy
{
    
     //JSMessagesViewAvatarPolicyIncomingOnly = 0,
     //JSMessagesViewAvatarPolicyBoth,
     //JSMessagesViewAvatarPolicyNone
    
    return JSMessagesViewAvatarPolicyBoth;
}

// 用户头像类型
- (JSAvatarStyle)avatarStyle
{
    
     //JSAvatarStyleCircle = 0,
     //JSAvatarStyleSquare,
     //JSAvatarStyleNone
    
    return JSAvatarStyleCircle;
}

- (JSInputBarStyle)inputBarStyle
{
    
    // JSInputBarStyleDefault,
    // JSInputBarStyleFlat
    
    return JSInputBarStyleFlat;
}

#pragma mark -- Messages view data source

- (NSString *)textForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageData *message = [self.messageArray objectAtIndex:indexPath.row];
    return message.text;
}

- (NSDate *)timestampForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageData *message = [self.messageArray objectAtIndex:indexPath.row];
    return message.date;
}

- (UIImage *)avatarImageForIncomingMessage
{
    return [UIImage imageNamed:@"AboutLogo"];
}

- (SEL)avatarImageForIncomingMessageAction
{
    return @selector(onInComingAvatarImageClick);
}

- (void)onInComingAvatarImageClick
{
    NSLog(@"__%s__", __func__);
}

- (SEL)avatarImageForOutgoingMessageAction
{
    return @selector(onOutGoingAvatarImageClick);
}

- (void)onOutGoingAvatarImageClick
{
    NSLog(@"__%s__", __func__);
}

- (UIImage *)avatarImageForOutgoingMessage
{
    return [UIImage imageNamed:@"Default_142x142"];
}

- (id)dataForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageData *message = [self.messageArray objectAtIndex:indexPath.row];
    return [UIImage imageNamed:[NSString stringWithFormat:@"%@", message.img]];
}

@end

