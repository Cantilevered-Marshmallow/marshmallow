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
#import <UITextView_Placeholder/UITextView+Placeholder.h>
#import <ZWEmoji/ZWEmoji.h>
#import <Socket_IO_Client_Swift/Socket_IO_Client_Swift-Swift.h>

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
#import "CMTrendMessageCell.h"

#import "CMGImageSearch.h"
#import "CMYoutubeSearch.h"

#import "CMTrendsPopup.h"

#import "CMFormattedTextView.h"

@interface ChatViewController : UIViewController <CMGImageSearchDelegate, CMYoutubeSearchDelegate, CMTrendsDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet CMFormattedTextView *messageInput;
@property (weak, nonatomic) IBOutlet UIView *chatControls;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *sendMessageButton;
@property (weak, nonatomic) IBOutlet UIButton *attachmentButton;
@property (weak, nonatomic) IBOutlet UIButton *clearAttachmentButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *trendsButton;

@property (strong, nonatomic) Chats *chat;

@property (strong, nonatomic) User *user;

@property (strong, nonatomic) NSMutableArray<Message *> *messages;

@property (nonatomic) CMNetworkRequest *request;

@property (strong, nonatomic) CMGImageResult *gImageResult;

@property (strong, nonatomic) CMYoutubeSearchResult *videoResult;

@property (strong, nonatomic) NSDictionary *trendResult;

@property (nonatomic) BOOL firstLoad;

@property (strong, nonatomic) SocketIOClient *socket;

- (void)sendMessage:(id)sender;

- (void)showAttachments:(id)sender;

- (void)clearAttachment:(id)sender;

- (void)trendsClicked:(id)sender;

- (void)toggleAttachmentAction;

- (void)resetMessageInput;

@end
