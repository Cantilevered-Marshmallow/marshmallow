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
    
    [self fetchContacts];
    
    [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(checkForNewFriends:) userInfo:nil repeats:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"contactCell"];
    
    Contact *contact = self.contacts[indexPath.row];
    
    NSArray *subviews = [cell subviews];
    // Ewww, why so many nested statements?
    // Because the API forced me
    for (UIView *view in subviews) {
        if ([[[view class] description] isEqualToString:@"UITableViewCellContentView"]) {
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
            NSMutableArray *friends = [[NSMutableArray alloc] initWithArray:result[@"data"]];
            NSMutableArray *friendIds = [[NSMutableArray alloc] initWithCapacity:friends.count];
            for (NSDictionary *friend in friends) {
                [friendIds addObject:friend[@"id"]];
            }
            
            CMNetworkRequest *networkRequest = [[CMNetworkRequest alloc] init];
            
            [networkRequest requestWithHttpVerb:@"POST" url:@"/userlist" data:@{@"users": friendIds} response:^(NSError *error, NSDictionary *response) {
                if (!error) {
                    NSArray *filteredFriends = response[@"users"];
                    
                    NSMutableArray *discardedFriends = [NSMutableArray array];
                    for (NSDictionary *friend in friends) {
                        if (![filteredFriends containsObject:friend[@"id"]]) {
                            [discardedFriends addObject:friend];
                        }
                    }
                    
                    [friends removeObjectsInArray:discardedFriends];
                    
                    for (NSDictionary *friend in friends) {
                        if (![Contact MR_findFirstByAttribute:@"contactId" withValue:friend[@"id"] inContext:[NSManagedObjectContext MR_defaultContext]]) {
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
