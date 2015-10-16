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

@interface ViewController : UIViewController <FBSDKLoginButtonDelegate>

@property FBSDKAccessToken *facebookToken;

@end

