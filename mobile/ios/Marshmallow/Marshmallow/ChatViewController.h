//
//  ChatViewController.h
//  Marshmallow
//
//  Created by Brandon Borders on 10/16/15.
//  Copyright © 2015 Cantilevered Marshmallow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DateTools/NSDate+DateTools.h>
#import <Haneke/Haneke.h>
#import <MagicalRecord/MagicalRecord.h>
#import <ISO8601/ISO8601.h>
#import <Haneke/Haneke.h>

#import "FBSDKCoreKit.h"
#import "FBSDKLoginKit.h"

#import "Chats.h"
#import "Message.h"
#import "User.h"
#import "Contact.h"

#import "CMNetworkRequest.h"
#import "CMMessageCell.h"
#import "CMGImageMessageCell.h"
#import "CMYoutubeVideoMessageCell.h"

#import "CMGImageSearch.h"
#import "CMYoutubeSearch.h"

@interface ChatViewController : UIViewController <CMGImageSearchDelegate, CMYoutubeSearchDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *messageInput;
@property (weak, nonatomic) IBOutlet UIView *chatControls;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *sendMessageButton;
@property (weak, nonatomic) IBOutlet UIButton *attachmentButton;

@property (strong, nonatomic) Chats *chat;

@property (strong, nonatomic) User *user;

@property (strong, nonatomic) NSMutableArray<Message *> *messages;

@property (nonatomic) CMNetworkRequest *request;

@property NSTimer *fetchMessagesTimer;

@property (strong, nonatomic) CMGImageResult *gImageResult;

@property (strong, nonatomic) CMYoutubeSearchResult *videoResult;

- (void)fetchMessages:(id)sender;

- (void)sendMessage:(id)sender;

- (void)showAttachments:(id)sender;

@end
