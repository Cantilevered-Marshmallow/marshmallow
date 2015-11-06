//
//  CMDataSeeder.m
//  Marshmallow
//
//  Created by Brandon Borders on 11/6/15.
//  Copyright © 2015 Cantilevered Marshmallow. All rights reserved.
//

#import "CMDataSeeder.h"

@implementation CMDataSeeder

+ (void)run {
    // Create some friends
    NSArray *friends = @[
                         @{
                             @"contactId": @"1",
                             @"name": @"Daniel O'Leary"
                             },
                         @{
                             @"contactId": @"2",
                             @"name": @"Brian Leung"
                             },
                         @{
                             @"contactId": @"3",
                             @"name": @"Brandon Borders"
                             },
                         @{
                             @"contactId": @"4",
                             @"name": @"Kyle Cho"
                             },
                         @{
                             @"contactId": @"5",
                             @"name": @"Marsh"
                             }
                         ];
    
    for (NSDictionary *friend in friends) {
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
            Contact *contact = [Contact MR_createEntityInContext:localContext];
            
            contact.contactId = friend[@"contactId"];
            contact.name = friend[@"name"];
        }];
    }
    
    int i;
    for (i = 6; i < 26; i++) {
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
            Contact *contact = [Contact MR_createEntityInContext:localContext];
            
            contact.contactId = [NSString stringWithFormat:@"%d", i];
            contact.name = [NSString stringWithFormat:@"John Appleseed%d", i];
        }];
    }
    
    // Create some chats
    NSArray *chats = @[
                       @{
                           @"chatId": @"90",
                           @"chatTitle": @"Pro Tips"
                       },
                       @{
                           @"chatId": @"91",
                           @"chatTitle": @"HR33"
                        },
                       @{
                           @"chatId": @"92",
                           @"chatTitle": @"Cantilevered?"
                        },
                       @{
                           @"chatId": @"93",
                           @"chatTitle": @"Random"
                        },
                     ];
    
    for (NSDictionary *chat in chats) {
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
            Chats *newChat = [Chats MR_createEntityInContext:localContext];
            
            newChat.chatId = chat[@"chatId"];
            newChat.chatTitle = chat[@"chatId"];
        }];
    }
    
    // Create some messages
    NSArray *chatIds = @[@"1", @"2", @"3", @"94"];
    for (i = 0; i < 100; i++) {
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
            Message *message = [Message MR_createEntityInContext:localContext];
            
            message.body = @"Message";
            message.timestamp = [NSDate date];
            message.chatsId = chatIds[arc4random_uniform((int)chatIds.count)];
            message.userId = [NSString stringWithFormat:@"%d", arc4random_uniform(25)];
            
            NSArray *mediaAttrs = @[@"googleImageId", @"youtubeVideoId", @"trend"];
            
            NSString *randomMediaAttr = mediaAttrs[arc4random_uniform((int)mediaAttrs.count)];
            
            if ([randomMediaAttr isEqualToString:@"googleImageId"]) {
                message.googleImageId = @"http://www.blirk.net/wallpapers/1152x864/fuzzy-monkey-1.jpg";
            } else if ([randomMediaAttr isEqualToString:@"youtubeVideoId"]) {
                message.youtubeVideoId = @"playnmJB_TI";
            } else {
                message.trend = [NSKeyedArchiver archivedDataWithRootObject:@{
                                                                                @"url": @"http://cantilevered-marshmallow.github.io",
                                                                                @"title": @"Cantileverd",
                                                                                @"thumbnail": @"https://avatars3.githubusercontent.com/u/15129174?v=3&s=200"
                                                                              }];
            }
        }];
    }
}

@end
