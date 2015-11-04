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
        baseTitle = [baseTitle stringByAppendingString:friends[0].name];
    } else {
        NSString *friendNames = @"";
        for (Contact *friend in friends) {
            NSString *firstName = [friend.name componentsSeparatedByString:@" "][0];
            
            friendNames = [friendNames stringByAppendingString:[NSString stringWithFormat:@", %@", firstName]];
        }
        
        baseTitle = [baseTitle stringByAppendingString:friendNames];
    }
    
    return baseTitle;
}

@end
