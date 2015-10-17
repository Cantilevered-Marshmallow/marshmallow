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
    
    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(logout:)];
    [[self navigationItem] setRightBarButtonItem:logoutButton animated:YES];
}

- (void)logout:(id)sender {
    [[[FBSDKLoginManager alloc] init] logOut];
    
    [self performSegueWithIdentifier:@"moveToWelcome" sender:self];
}

@end
