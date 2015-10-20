//
//  Message.m
//  Marshmallow
//
//  Created by Brandon Borders on 10/20/15.
//  Copyright © 2015 Cantilevered Marshmallow. All rights reserved.
//

#import "Message.h"

@implementation Message

- (id)initWithEntityName:(NSString *)entityName andChatsId:(NSString *)chatsId andUserId:(NSString *)userId {
    self = [super initWithEntityName:entityName];
    
    if (self) {
        [self setValue:chatsId forKey:@"attrChatsId"];
        [self setValue:userId forKey:@"attrUserId"];
        
        [self populatePropertiesAtColumn:@"chatsId" withValue:chatsId];
    }
    
    return self;
}

@end
