//
//  CMChatTitle.m
//  Marshmallow
//
//  Created by Brandon Borders on 11/3/15.
//  Copyright © 2015 Cantilevered Marshmallow. All rights reserved.
//

#import "NSString+ChatTitle.h"

@implementation NSString (ChatTitle)

+ (NSString *)titleForFriends:(NSArray<Contact *> *)friends {
    NSString *baseTitle = @"Chat with ";
    
    if (friends.count == 1) {
        baseTitle = [baseTitle stringByAppendingString:friends[0].name]; // Use the users full name when the chat is only with one other person
    } else {
        NSString *friendNames = @"";
        for (Contact *friend in friends) { // Loop through each friend
            NSString *firstName = [friend.name componentsSeparatedByString:@" "][0];
            
            // Append their first name in a comma seperated list to the title
            friendNames = [friendNames stringByAppendingString:[NSString stringWithFormat:@", %@", firstName]];
        }
        
        baseTitle = [baseTitle stringByAppendingString:friendNames];
    }
    
    return baseTitle;
}

@end
