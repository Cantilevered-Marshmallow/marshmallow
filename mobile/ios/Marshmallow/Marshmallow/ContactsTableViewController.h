//
//  ContactsTableViewController.h
//  Marshmallow
//
//  Created by Brandon Borders on 10/20/15.
//  Copyright © 2015 Cantilevered Marshmallow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MagicalRecord/MagicalRecord.h>

#import "FBSDKCoreKit/FBSDKCoreKit.h"

#import "CMRemoteImageView.h"

#import "Contact.h"

@interface ContactsTableViewController : UITableViewController <UITabBarControllerDelegate, UITableViewDataSource>

@property NSMutableArray<Contact *> *contacts;

- (void)checkForNewFriends:(NSTimer *)timer;

- (void)fetchContacts;

@end
