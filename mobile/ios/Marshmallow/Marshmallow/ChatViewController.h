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

#import "FBSDKCoreKit.h"
#import "FBSDKLoginKit.h"

#import "Chats.h"
#import "Message.h"
#import "User.h"
#import "Contact.h"

#import "CMNetworkRequest.h"
#import "CMMessageCell.h"

@interface ChatViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *messageInput;
@property (weak, nonatomic) IBOutlet UIView *chatControls;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) Chats *chat;

@property (strong, nonatomic) NSMutableArray<Message *> *messages;

@property (nonatomic) CMNetworkRequest *request;

@property NSTimer *fetchMessagesTimer;

- (void)fetchMessages:(id)sender;

@end
