//
//  ChatsTableViewController.h
//  Marshmallow
//
//  Created by Brandon Borders on 10/16/15.
//  Copyright © 2015 Cantilevered Marshmallow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MagicalRecord/MagicalRecord.h>

#import "Chats.h"

#import "FBSDKCoreKit.h"
#import "FBSDKLoginKit.h"

#import "HDNotificationView.h"

#import "CMNetworkRequest.h"

#import "ChatViewController.h"
#import "User.h"

#import "NSString+ChatTitle.h"

@interface ChatsTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>

# pragma mark - Facebook Properties

// The OAuth token returned from Facebook
@property FBSDKAccessToken *facebookToken;

// The profile of the signed in user from Facebook
@property FBSDKProfile *facebookProfile;

@property User *user;

@property CMNetworkRequest *request;

@property (strong, nonatomic) NSArray<Chats *> *chats;

@property NSTimer *fetchChatsTimer;

- (void)fetchChats:(id)sender;

- (void)createChat:(id)sender;

- (void)fetchMessagesSinceLast;

@end
