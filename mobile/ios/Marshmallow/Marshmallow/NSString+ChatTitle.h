//
//  CMChatTitle.h
//  Marshmallow
//
//  Created by Brandon Borders on 11/3/15.
//  Copyright © 2015 Cantilevered Marshmallow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Contact.h"

@interface NSString (ChatTitle)

+ (NSString *)titleForFriends:(NSArray<Contact *> *)friends;

@end
