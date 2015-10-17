//
//  ViewController.m
//  Marshmallow
//
//  Created by Brandon Borders on 10/15/15.
//  Copyright © 2015 Cantilevered Marshmallow. All rights reserved.
//

#import "WelcomeViewController.h"

@interface WelcomeViewController ()

@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Create the Facebook signin button
    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    loginButton.center = self.view.center;
    
    // Tell Facebook which permissions we would like to have
    loginButton.readPermissions = @[@"email", @"user_friends"];
    
    // Bind this class as the delegate for the login button
    loginButton.delegate = self;
    
    // Have the Facebook profile object react to changes in the OAuth token
    [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
    
    // Bind to an event emitted by the Facebook SDK indicating we have received profile information on the user
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(profileUpdated:) name:FBSDKProfileDidChangeNotification object:nil];
    
    // Add the button to the View Controller
    [self.view addSubview:loginButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"moveToChats"] || [segue.identifier isEqualToString:@"moveToChatsStatic"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        ChatsTableViewController *chats = [navigationController viewControllers][0];
        chats.facebookToken = [self facebookToken];
        chats.facebookProfile = [self facebookProfile];
    }
}

- (void)leaveWelcome:(id)sender {
    [self performSegueWithIdentifier:@"moveToChats" sender:sender];
}

#pragma mark - Facebook Login

// Invoked when the user has logged in
- (void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error {
    if (error) {
        NSLog(@"%@", error);
    } else {
        if (!result.isCancelled) { // Did the user cancel the login?
            _facebookToken = result.token;
            NSLog(@"The token is %@", _facebookToken.tokenString);
            
            // Need to delay to the segue because the animation from the sigin frame has not finished yet
            [self performSelector:@selector(leaveWelcome:) withObject:self afterDelay:0.9];
        }
    }
}

// Invoked when the user has logged out
- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton {
    NSLog(@"User has logged out");
    _facebookProfile = nil;
    _facebookToken = nil;
}

// Invoked when the Facebook Profile object has been updated
- (void)profileUpdated:(NSNotification *)notification {
    if ([FBSDKProfile currentProfile]) { // Check to see if the profile is not nil
        _facebookProfile = [FBSDKProfile currentProfile];
        NSLog(@"%@ %@", _facebookProfile.firstName, _facebookProfile.lastName);
    }
}

@end
