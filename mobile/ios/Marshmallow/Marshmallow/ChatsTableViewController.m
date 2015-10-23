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
    
    _request = [[CMNetworkRequest alloc] init];
    _chats = @[];
    
    [HDNotificationView showNotificationViewWithImage:[UIImage imageNamed:@"Icon"] title:@"Loading..." message:@"Retrieving chats" isAutoHide:NO];
    
    [self fetchChats:self];
    
    self.fetchChatsTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(fetchChats:) userInfo:nil repeats:true];
    
    self.navigationItem.rightBarButtonItem.target = self;
    self.navigationItem.rightBarButtonItem.action = @selector(createChat:);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (!self.fetchChatsTimer) {
        self.fetchChatsTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(fetchChats:) userInfo:nil repeats:true];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.fetchChatsTimer invalidate];
    self.fetchChatsTimer = nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    cell.textLabel.text = _chats[indexPath.row][@"chatTitle"]; // Static cell text
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_chats count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"showChat" sender:self];
}

- (void)fetchChats:(id)sender {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [_request requestWithHttpVerb:@"GET" url:@"/chat" data:nil response:^(NSError *error, NSDictionary *response) {
            if (!error) {
                _chats = response[@"chats"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                    
                    [HDNotificationView hideNotificationView];
                });
            } else {
                // Try to log back in
                [_request requestWithHttpVerb:@"POST" url:@"/login" data:@{@"oauthToken": [[FBSDKAccessToken currentAccessToken] tokenString], @"email": self.user.email, @"facebookId": [[FBSDKAccessToken currentAccessToken] userID]} response:^(NSError *error, NSDictionary *response) {
                    if (!error) {
                        [self fetchChats:self];
                    }
                }];
            }
        }];
    });
}

- (void)createChat:(id)sender {
    [self performSegueWithIdentifier:@"startAChat" sender:self];
}

@end
