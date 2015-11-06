//
//  AppDelegate.h
//  Marshmallow
//
//  Created by Brandon Borders on 10/15/15.
//  Copyright © 2015 Cantilevered Marshmallow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MagicalRecord/MagicalRecord.h>

#import "FBSDKCoreKit.h"
#import "User.h"

#import "WelcomeViewController.h"
#import "ChatsTableViewController.h"

// Uncomment for seeding of local data
//#ifdef DEBUG
//    #import "CMDataSeeder.h"
//#endif

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@end

