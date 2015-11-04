//
//  Message.m
//  Marshmallow
//
//  Created by Brandon Borders on 10/21/15.
//  Copyright © 2015 Cantilevered Marshmallow. All rights reserved.
//

#import "Message.h"
#import "Chats.h"
#import "User.h"

@implementation Message

- (NSString *)description {
    return [NSString stringWithFormat:@"Message is the following: %@ from %@ in %@", self.body, self.userId, self.chatsId];
}

- (void)storeTrend:(NSDictionary *)trend {
    self.trend = [NSKeyedArchiver archivedDataWithRootObject:trend];
}

- (NSDictionary *)fetchTrend {
    return (NSDictionary *) [NSKeyedUnarchiver unarchiveObjectWithData:self.trend];
}

@end
