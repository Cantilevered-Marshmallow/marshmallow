//
//  IconTabBarController.m
//  Marshmallow
//
//  Created by Brandon Borders on 10/20/15.
//  Copyright © 2015 Cantilevered Marshmallow. All rights reserved.
//

#import "IconTabBarController.h"

@implementation IconTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSError *error;
    NSArray *items = self.tabBar.items;
    
    for (UITabBarItem *item in items) {
        if ([item.title isEqualToString:@"Chats"]) {
            item.image = [[FAKIonIcons iconWithIdentifier:@"ion-ios-chatboxes-outline" size:35 error:&error] imageWithSize:CGSizeMake(35, 35)];
        } else if ([item.title isEqualToString:@"Contacts"]) {
            item.image = [[FAKIonIcons iconWithIdentifier:@"ion-ios-people-outline" size:35 error:&error] imageWithSize:CGSizeMake(35, 35)];
        }
    }
}

@end
