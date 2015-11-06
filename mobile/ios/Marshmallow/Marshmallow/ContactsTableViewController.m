//
//  ContactsTableViewController.m
//  Marshmallow
//
//  Created by Brandon Borders on 10/20/15.
//  Copyright © 2015 Cantilevered Marshmallow. All rights reserved.
//

#import "ContactsTableViewController.h"

@implementation ContactsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _contacts = [[NSMutableArray alloc] init];
    
    // Load the contacts data
    [self fetchContacts];
    
    // Setup for long polling of contacts
    self.fetchContactsTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(checkForNewFriends:) userInfo:nil repeats:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    // Invalidate long polling
    [self.fetchContactsTimer invalidate];
    self.fetchContactsTimer = nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"contactCell"];
    
    Contact *contact = self.contacts[indexPath.row];
    
    NSArray *subviews = [cell subviews];
    
    // Loop to find the content view of the cell
    for (UIView *view in subviews) {
        if ([[[view class] description] isEqualToString:@"UITableViewCellContentView"]) {
            // Loop through each subview of the content view
            for (UIView *subview in [view subviews]) {
                if ([[[subview class] description] isEqualToString:@"UIImageView"]) {
                    UIImageView *iv = ((UIImageView *)subview);
                    [iv hnk_setImageFromURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=150&height=150", contact.contactId]]];
                }
                
                if ([[[subview class] description] isEqualToString:@"UILabel"]) {
                    UILabel *label = ((UILabel *)subview);
                    
                    if ([[label text] isEqualToString:@"John Appleseed"]) {
                        label.text = contact.name;
                    }
                }
            }
        }
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.contacts count];
}

- (void)fetchContacts {
    self.contacts = [NSMutableArray arrayWithArray:[Contact MR_findAllInContext:[NSManagedObjectContext MR_defaultContext]]];
    
    // Sorts the contacts in alphabetical order by their name property
    [self.contacts sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
    
    [self.tableView reloadData];
}

- (void)checkForNewFriends:(NSTimer *)timer {
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                  initWithGraphPath:@"/me/friends"
                                  parameters:@{}
                                  HTTPMethod:@"GET"];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                          id result,
                                          NSError *error) {
        if (!error) {
            // Capture the ids into an array
            NSMutableArray *friends = [[NSMutableArray alloc] initWithArray:result[@"data"]];
            NSMutableArray *friendIds = [[NSMutableArray alloc] initWithCapacity:friends.count];
            for (NSDictionary *friend in friends) {
                [friendIds addObject:friend[@"id"]];
            }
            
            CMNetworkRequest *networkRequest = [[CMNetworkRequest alloc] init];
            
            User *user = [User MR_findFirstByAttribute:@"oauthToken" withValue:[[FBSDKAccessToken currentAccessToken] tokenString] inContext:[NSManagedObjectContext MR_defaultContext]];
            [networkRequest requestWithHttpVerb:@"POST" url:@"/userlist" data:@{@"users": friendIds} jwt:user.jwt response:^(NSError *error, NSDictionary *response) {
                if (!error) {
                    // Filter the respone to only have the contacts that are using our service
                    NSArray *filteredFriends = response[@"users"];
                    
                    NSMutableArray *discardedFriends = [NSMutableArray array];
                    for (NSDictionary *friend in friends) {
                        if (![filteredFriends containsObject:friend[@"id"]]) {
                            [discardedFriends addObject:friend];
                        }
                    }
                    
                    [friends removeObjectsInArray:discardedFriends];
                    
                    for (NSDictionary *friend in friends) {
                        // Has the contact been saved yet?
                        if (![Contact MR_findFirstByAttribute:@"contactId" withValue:friend[@"id"] inContext:[NSManagedObjectContext MR_defaultContext]]) {
                            // Save the contact
                            [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
                                Contact *contact = [Contact MR_createEntityInContext:localContext];
                                contact.name = friend[@"name"];
                                contact.contactId = friend[@"id"];
                            }];
                        }
                    }
                    
                    [self fetchContacts];
                }
            }];
        } else {
            NSLog(@"%@", error);
        }
    }];
}

@end
