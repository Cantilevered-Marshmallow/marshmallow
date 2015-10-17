//
//  ChatsTableViewController.h
//  Marshmallow
//
//  Created by Brandon Borders on 10/16/15.
//  Copyright © 2015 Cantilevered Marshmallow. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FBSDKCoreKit.h"
#import "FBSDKLoginKit.h"

#import "ChatViewController.h"

@interface ChatsTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>

# pragma mark - Facebook Properties

// The OAuth token returned from Facebook
@property FBSDKAccessToken *facebookToken;

// The profile of the signed in user from Facebook
@property FBSDKProfile *facebookProfile;

- (void)logout:(id)sender;

@end
