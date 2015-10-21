//
//  ContactsTableViewController.h
//  Marshmallow
//
//  Created by Brandon Borders on 10/20/15.
//  Copyright © 2015 Cantilevered Marshmallow. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CMDataAccessor.h"
#import "CMRemoteImageView.h"

#import "Contact.h"

@interface ContactsTableViewController : UITableViewController <UITabBarControllerDelegate, UITableViewDataSource>

@property NSMutableArray<Contact *> *contacts;

@property CMDataAccessor *accessor;

- (void)saveContactImage:(NSTimer *)timer;

@end
