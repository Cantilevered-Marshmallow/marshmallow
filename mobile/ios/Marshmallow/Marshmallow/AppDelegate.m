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
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    if ([FBSDKAccessToken currentAccessToken]) { // Are we logged in?
        UINavigationController *nc = [storyboard instantiateViewControllerWithIdentifier:@"NavigationController"];
        ChatsTableViewController *chatsVC = [nc viewControllers][0];
        chatsVC.user = [[User alloc] initWithName:[[FBSDKProfile currentProfile] name]];
        [[self window] setRootViewController:nc];
    } else {
        WelcomeViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"WelcomeViewController"];
        [[self window] setRootViewController:vc];
    }
    
    _accessor = [[CMDataAccessor alloc] init];
    
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
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [_accessor saveContext];
}

#pragma mark - Core Data stack

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "org.cantilevered.marshmallow.test_core_data" in the application's documents directory.
    return [_accessor applicationDocumentsDirectory];
}

- (NSManagedObjectModel *)managedObjectModel {
    return [_accessor managedObjectModel];
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    return [_accessor persistentStoreCoordinator];
}


- (NSManagedObjectContext *)managedObjectContext {
    return [_accessor managedObjectContext];
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
