//
//  ChatViewController.m
//  Marshmallow
//
//  Created by Brandon Borders on 10/16/15.
//  Copyright © 2015 Cantilevered Marshmallow. All rights reserved.
//

#import "ChatViewController.h"

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Add logout button to navigation bar
    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(logout:)];
    [[self navigationItem] setRightBarButtonItem:logoutButton animated:YES];
    
    _messageInput.layer.borderColor = [[UIColor grayColor] CGColor];
    _messageInput.layer.borderWidth = 0.25;
    _messageInput.layer.cornerRadius = 5;
    
    CALayer *upperBorder = [CALayer layer];
    upperBorder.backgroundColor = [[UIColor grayColor] CGColor];
    upperBorder.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 0.5f);
    [_chatControls.layer addSublayer:upperBorder];
}

- (void)logout:(id)sender {
    [[[FBSDKLoginManager alloc] init] logOut];
    
    [self performSegueWithIdentifier:@"moveToWelcome" sender:self];
}

@end
