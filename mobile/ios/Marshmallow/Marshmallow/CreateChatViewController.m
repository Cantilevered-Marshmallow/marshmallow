//
//  CreateChatViewController.m
//  Marshmallow
//
//  Created by Brandon Borders on 10/22/15.
//  Copyright © 2015 Cantilevered Marshmallow. All rights reserved.
//

#import "CreateChatViewController.h"

@implementation CreateChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    
    self.searchController.searchResultsUpdater = self;
    
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    self.definesPresentationContext = YES;
    
    self.filteredContacts = [[NSMutableArray alloc] init];
    
    [self fetchContacts];
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *input = searchController.searchBar.text;
    
    if ([input length] > 0) {
        [self.contacts addObjectsFromArray:self.filteredContacts];
        [self.filteredContacts removeAllObjects];
        
        for (int i = 0; i < self.contacts.count; i++) {
            Contact *contact = self.contacts[i];
            if (![contact.name containsString:input]) {
                [self.filteredContacts addObject:contact];
                [self.contacts removeObject:contact];
            }
        }
        
        [self.tableView reloadData];
    } else if (self.filteredContacts.count > 0) {
        [self.contacts addObjectsFromArray:self.filteredContacts];
        [self.filteredContacts removeAllObjects];
        
        [self.tableView reloadData];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.contacts count];
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
                if ([[[subview class] description] isEqualToString:@"CMRemoteImageView"]) {
                    CMRemoteImageView *iv = ((CMRemoteImageView *)subview);
                    if (!contact.profileImage) {
                        [iv setRemoteUrl:[NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=150&height=150", contact.contactId]
                                          ]
                                 success:^(UIImage *image) {
                                     if (iv.image != nil) {
                                         NSData *imageData = UIImagePNGRepresentation(image);
                                         [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
                                             Contact *contact = [Contact MR_findFirstByAttribute:@"name" withValue:contact.name inContext:localContext];
                                             contact.profileImage = imageData;
                                         }];
                                     }
                                 }];
                    } else {
                        iv.image = [UIImage imageWithData:contact.profileImage];
                    }
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

- (void)fetchContacts {
    self.contacts = [[NSMutableArray alloc] initWithArray:[Contact MR_findAllInContext:[NSManagedObjectContext MR_defaultContext]]];
    
    [self.tableView reloadData];
}

@end
