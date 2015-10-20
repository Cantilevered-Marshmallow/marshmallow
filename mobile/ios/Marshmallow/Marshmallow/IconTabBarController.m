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
            item.image = [[FAKFontAwesome iconWithIdentifier:@"fa-envelope-o" size:25 error:&error] imageWithSize:CGSizeMake(25, 25)];
        }
    }
}

@end
