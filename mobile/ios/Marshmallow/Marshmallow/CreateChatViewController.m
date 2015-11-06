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
    
    // Initialize search bar
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    
    self.searchController.searchResultsUpdater = self;
    
    // Make the search bar the header of the table view
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    self.definesPresentationContext = YES;
    
    // Initialize data
    self.filteredContacts = [[NSMutableArray alloc] init];
    self.selectedPaths = [[NSMutableArray alloc] init];
    
    [self fetchContacts];
    
    // Initialize table
    self.tableView.allowsMultipleSelection = YES;
    
    // Bind create button
    self.navigationItem.rightBarButtonItem.target = self;
    self.navigationItem.rightBarButtonItem.action = @selector(createChat:);
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *input = searchController.searchBar.text;
    
    // Do we have any search context?
    if ([input length] > 0) {
        [self.contacts addObjectsFromArray:self.filteredContacts];
        [self.filteredContacts removeAllObjects];
        
        // Sorts the contacts in alphabetical order by their name property
        [self.contacts sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
        
        // A predicate that sees if the is like the input. [c] being case-insensitive and [d] ignoring accent marks in case
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name contains[cd] %@", input];
        
        for (int i = 0; i < self.contacts.count; i++) {
            Contact *contact = self.contacts[i];
            if (![predicate evaluateWithObject:contact]) {
                [self.filteredContacts addObject:contact];
                [self.contacts removeObject:contact];
            }
        }
        
        [self.tableView reloadData];
    } else if (self.filteredContacts.count > 0) { // Then reset the table
        [self.contacts addObjectsFromArray:self.filteredContacts];
        [self.filteredContacts removeAllObjects];
        
        // Sorts the contacts in alphabetical order by their name property
        [self.contacts sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
        
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
                if ([[[subview class] description] isEqualToString:@"UIImageView"]) {
                    UIImageView *iv = ((UIImageView *)subview);
                    [iv hnk_setImageFromURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=150&height=150", contact.contactId]
                                          ]];
                }
                
                if ([[[subview class] description] isEqualToString:@"UILabel"]) {
                    UILabel *label = ((UILabel *)subview);
                    
                    label.text = contact.name;
                }
            }
        }
    }

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell.accessoryView == nil) { // Has the cell been selected yet?
        NSError *error;
        UIImage *checkbox = [[FAKIonIcons iconWithIdentifier:@"ion-ios-checkmark-outline" size:50 error:&error] imageWithSize:CGSizeMake(50, 50)];
        checkbox = [checkbox imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        UIImageView *iv = [[UIImageView alloc] initWithImage:checkbox];
        [iv setTintColor:[UIColor colorFromHexString:@"#006400"]];
        cell.accessoryView = iv;
        
        [self.selectedPaths addObject:indexPath];
    } else {
        // Uncheck the cell
        cell.accessoryView = nil;
        [self.selectedPaths removeObject:indexPath];
    }
    
    [cell setSelected:NO animated:YES];
}

- (void)fetchContacts {
    self.contacts = [[NSMutableArray alloc] initWithArray:[Contact MR_findAllInContext:[NSManagedObjectContext MR_defaultContext]]];
    
    [self.tableView reloadData];
}

- (void)createChat:(id)sender {
    NSMutableArray<NSString *> *facebookIds = [[NSMutableArray alloc] init];
    NSMutableArray<Contact *> *friends = [[NSMutableArray alloc] init];
    
    for (NSIndexPath *indexPath in self.selectedPaths) { // Get the facebookIds for each contact that was selected
        [facebookIds addObject:self.contacts[indexPath.row].contactId];
    }
    
    for (NSString *facebookId in facebookIds) { // Geat each Contact object for facebookId
        [friends addObject:[Contact MR_findFirstByAttribute:@"contactId" withValue:facebookId inContext:[NSManagedObjectContext MR_defaultContext]]];
    }
    
    [facebookIds addObject:[[FBSDKAccessToken currentAccessToken] userID]]; // You are also partaking in this chat
    
    if (facebookIds.count >= 2) { // Must have selected at least one person
        CMNetworkRequest *request = [[CMNetworkRequest alloc] init];
        
        [request requestWithHttpVerb:@"POST" url:@"/chat" data:@{@"users": facebookIds} jwt:self.user.jwt response:^(NSError *error, NSDictionary *response) {
            if (!error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // Save the new chat
                        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
                            Chats *chats = [Chats MR_createEntityInContext:localContext];
                            chats.chatId = response[@"chatId"];
                            chats.chatTitle = [NSString titleForFriends:friends];
                        }
                        completion:^(BOOL contextDidSave, NSError *error) {
                            if (contextDidSave) {
                                // Change the back button to point to the chats list and not create chat view
                                UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Chats" style:UIBarButtonItemStylePlain target:nil action:nil];
                                self.navigationItem.backBarButtonItem = backButton;
                                
                                UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                
                                // Pass data to the chat view controller
                                ChatViewController *chatViewController = [sb instantiateViewControllerWithIdentifier:@"ChatViewController"];
                                chatViewController.chat = [Chats MR_findFirstByAttribute:@"chatId" withValue:response[@"chatId"] inContext:[NSManagedObjectContext MR_defaultContext]];
                                chatViewController.user = self.user;
                                
                                // Mangle the navigation controller's stack to not have this view controller in it
                                NSArray *viewControllers = [[NSArray alloc] initWithObjects:[self.navigationController.viewControllers objectAtIndex:0], chatViewController, nil];
                                
                                [self.navigationController pushViewController:chatViewController animated:YES];
                                
                                [self.navigationController setViewControllers:viewControllers animated:YES];
                            }
                        }];
                    });
            } else {
                
            }
        }];
    } else {
        [HDNotificationView showNotificationViewWithImage:[UIImage imageNamed:@"Icon"] title:@"You must select some friends to chat with first" message:nil];
    }
}

@end
