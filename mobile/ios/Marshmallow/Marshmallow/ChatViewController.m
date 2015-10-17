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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"messageCell" forIndexPath:indexPath];
    FBSDKProfile *userProfile = [FBSDKProfile currentProfile];
    
    NSArray *subviews = [cell subviews];
    // Ewww, why so many nested statements?
    // Because the API forced me
    for (UIView *view in subviews) {
        if ([[[view class] description] isEqualToString:@"UITableViewCellContentView"]) {
            for (UIView *subview in [view subviews]) {
                if ([[[subview class] description] isEqualToString:@"CMRemoteImageView"]) {
                    // Hah, found you.
                    // Set the image in the cell to be the profile image of the user from facebook
                    [((CMRemoteImageView *)subview) setRemoteUrl:[NSURL URLWithString:
                                                                  [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=150&height=150", [userProfile userID]]
                                                                  ]];
                }
                
                if ([[[subview class] description] isEqualToString:@"UILabel"]) {
                    UILabel *label = ((UILabel *)subview);
                    
                    if ([label.text isEqualToString:@"John Appleseed"]) {
                        // Username label
                        
                        label.text = [NSString stringWithFormat:@"%@ %@", [userProfile firstName], [userProfile lastName]];
                    }
                }
            }
        }
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

@end
