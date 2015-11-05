//
//  ChatsTableViewController.m
//  Marshmallow
//
//  Created by Brandon Borders on 10/16/15.
//  Copyright © 2015 Cantilevered Marshmallow. All rights reserved.
//

#import "ChatsTableViewController.h"

@implementation ChatsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Initialize data
    _request = [[CMNetworkRequest alloc] init];
    self.chats = [Chats MR_findAllInContext:[NSManagedObjectContext MR_defaultContext]];
    
    [HDNotificationView showNotificationViewWithImage:[UIImage imageNamed:@"Icon"] title:@"Loading..." message:@"Retrieving chats" isAutoHide:NO];
    
    // Fetch the chats first
    [self fetchChats:self];
    
    // Setup long polling of chats
    self.fetchChatsTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(fetchChats:) userInfo:nil repeats:true];
    
    // Bind teh create chat button
    self.navigationItem.rightBarButtonItem.target = self;
    self.navigationItem.rightBarButtonItem.action = @selector(createChat:);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Handle possible change in a chat title
    self.chats = [Chats MR_findAllInContext:[NSManagedObjectContext MR_defaultContext]];
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // Setup long polling again if it was invalidated
    if (!self.fetchChatsTimer) {
        self.fetchChatsTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(fetchChats:) userInfo:nil repeats:true];
    }
    
    [self fetchMessagesSinceLast];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // Invalidate the long polling
    [self.fetchChatsTimer invalidate];
    self.fetchChatsTimer = nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    Chats *chats = self.chats[indexPath.row];
    
    cell.textLabel.text = chats.chatTitle; // Static cell text
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.chats count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"showChat" sender:self.chats[indexPath.row]];
}

- (void)fetchChats:(id)sender {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [_request requestWithHttpVerb:@"GET" url:@"/chat" data:nil jwt:self.user.jwt response:^(NSError *error, NSDictionary *response) {
            if (!error) {
                for (NSDictionary *fetchedChat in response[@"chats"]) {
                    NSString *chatId = [NSString stringWithFormat:@"%@", fetchedChat[@"chatId"]];
                    
                    // Does the chat already exist?
                    if (![Chats MR_findFirstByAttribute:@"chatId" withValue:chatId inContext:[NSManagedObjectContext MR_defaultContext]]) {
                        // Filter contacts with the ones participating in the chat
                        NSMutableArray<Contact *> *contacts = [NSMutableArray arrayWithArray:[Contact MR_findAllInContext:[NSManagedObjectContext MR_defaultContext]]];

                        NSArray *friendIds = fetchedChat[@"users"];
                        
                        NSMutableArray<Contact *> *friends = [[NSMutableArray alloc] init];
                        
                        for (Contact *contact in contacts) {
                            if ([friendIds containsObject:contact.contactId]) {
                                [friends addObject:contact];
                            }
                        }
                        
                        // Save the new chat
                        [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
                            Chats *chats = [Chats MR_createEntityInContext:localContext];
                            
                            chats.chatId = chatId;
                            chats.chatTitle = [NSString titleForFriends:friends];
                        }];
                    }
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    // Reload the data
                    self.chats = [Chats MR_findAllInContext:[NSManagedObjectContext MR_defaultContext]];
                    
                    [self.tableView reloadData];
                    
                    [HDNotificationView hideNotificationView];
                });
            }
        }];
    });
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showChat"]) {
        ChatViewController *vc = segue.destinationViewController;
        
        // Pass the appropiate data to the chat view controller
        vc.chat = sender;
        vc.user = self.user;
    }
}

- (void)createChat:(id)sender {
    [self performSegueWithIdentifier:@"startAChat" sender:self];
}

- (void)fetchMessagesSinceLast {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *date = [[NSDate date] formattedDateWithFormat:@"YYYY-MM-dd\'T\'HH:mm:ss.000\'Z\'"];
        [_request requestWithHttpVerb:@"GET" url:[NSString stringWithFormat:@"/messages?timestamp=%@", date] data:nil jwt:self.user.jwt response:^(NSError *error, NSDictionary *response) {
            if (!error) {
                NSArray *fetchedMessages = response[@"messages"];
                for (NSDictionary *fetchedMessage in fetchedMessages) {
                    NSString *chatId = [NSString stringWithFormat:@"%@", fetchedMessage[@"chatId"]];
                    
                    // Does the message already exist?
                    if (![Message MR_findFirstByAttribute:@"chatsId" withValue:chatId inContext:[NSManagedObjectContext MR_defaultContext]]) {
                        // Save the new message
                        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
                            Message *message = [Message MR_createEntityInContext:localContext];
                            message.body = fetchedMessage[@"text"];
                            
                            if (fetchedMessage[@"youtubeVideoId"] != (id)[NSNull null]) {
                                message.youtubeVideoId = fetchedMessage[@"youtubeVideoId"];
                            } else {
                                message.youtubeVideoId = @"";
                            }
                            
                            if (fetchedMessage[@"googleImageId"] != (id)[NSNull null]) {
                                message.googleImageId = fetchedMessage[@"googleImageId"];
                            } else {
                                message.googleImageId = @"";
                            }
                            message.chatsId = [fetchedMessage[@"chatId"] stringValue];
                            message.userId = fetchedMessage[@"userFacebookId"];
                            message.timestamp = [NSDate dateWithISO8601String:fetchedMessage[@"createdAt"]];
                        }];
                    }
                }
            }
        }];
    });

}

@end
