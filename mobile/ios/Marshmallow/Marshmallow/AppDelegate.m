//
//  AppDelegate.m
//  Marshmallow
//
//  Created by Brandon Borders on 10/15/15.
//  Copyright © 2015 Cantilevered Marshmallow. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Binding FBSDKApplicationDelegate to this event
    [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    
    [MagicalRecord setupCoreDataStack];

// Uncomment for seeding of local data
//#ifdef DEBUG
//    [CMDataSeeder run];
//#endif
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    if ([FBSDKAccessToken currentAccessToken]) { // Are we logged in?
        // Then display the chats view controller
        UITabBarController *tb = [storyboard instantiateViewControllerWithIdentifier:@"TabsController"];
        tb.delegate = self;
        UINavigationController *nc = [tb viewControllers][0];
        ChatsTableViewController *chatsVC = [nc viewControllers][0];
        chatsVC.user = [User MR_findFirstByAttribute:@"name" withValue:[[FBSDKProfile currentProfile] name]];
        [[self window] setRootViewController:tb];
    } else {
        // Or else show them the welcome wagon
        WelcomeViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"WelcomeViewController"];
        [[self window] setRootViewController:vc];
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [MagicalRecord cleanUp];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [MagicalRecord cleanUp];
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    // Proper handling of view life cycle in tab bar controller
    for (UIViewController *vc in tabBarController.viewControllers) {
        if (![vc isEqual:viewController]) {
            [vc viewDidDisappear:NO];
        }
    }
}

#pragma mark - Facebook SDK

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    // Binding FBSDKApplicationDelegate to this event
    return [[FBSDKApplicationDelegate sharedInstance]
            application:application
            openURL:url
            sourceApplication:sourceApplication
            annotation:annotation];
}

@end
