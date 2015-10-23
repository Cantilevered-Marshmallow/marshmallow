//
//  CreateChatViewController.h
//  Marshmallow
//
//  Created by Brandon Borders on 10/22/15.
//  Copyright © 2015 Cantilevered Marshmallow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MagicalRecord/MagicalRecord.h>
#import <Haneke/Haneke.h>
#import "FBSDKCoreKit.h"
#import <FontAwesomeKit/FontAwesomeKit.h>

#import "Contact.h"
#import "UIColor+ColorFromHexString.h"
#import "CMNetworkRequest.h"
#import "Chats.h"

@interface CreateChatViewController : UITableViewController <UISearchResultsUpdating, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UISearchController *searchController;

@property (strong, nonatomic) NSMutableArray<Contact *> *contacts;

@property (strong, nonatomic) NSMutableArray<Contact *> *filteredContacts;

@property (strong, nonatomic) NSMutableArray<NSIndexPath *> *selectedPaths;

- (void)fetchContacts;

- (void)createChat:(id)sender;

@end
