//
//  ViewController.h
//  Marshmallow
//
//  Created by Brandon Borders on 10/15/15.
//  Copyright © 2015 Cantilevered Marshmallow. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FBSDKCoreKit.h"
#import "FBSDKLoginKit.h"

@interface WelcomeViewController : UIViewController <FBSDKLoginButtonDelegate>

# pragma mark - Facebook Properties

// The OAuth token returned from Facebook
@property FBSDKAccessToken *facebookToken;

// The profile of the signed in user from Facebook
@property FBSDKProfile *facebookProfile;

@end

