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
    
    // Add logout button to navigation bar
    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(logout:)];
    [[self navigationItem] setRightBarButtonItem:logoutButton animated:YES];
    
    _request = [[CMNetworkRequest alloc] init];
    _chats = @[];
    
//    [HDNotificationView showNotificationViewWithImage:[UIImage imageNamed:@"Icon"] title:@"Loading..." message:@"Retrieving chats" isAutoHide:NO];
    
    [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(fetchChats:) userInfo:nil repeats:true];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
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

- (void)logout:(id)sender {
    [[[FBSDKLoginManager alloc] init] logOut];
    
    [self performSegueWithIdentifier:@"moveToWelcome" sender:self];
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
            }
        }];
    });
}

@end
