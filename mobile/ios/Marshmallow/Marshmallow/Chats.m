//
//  Chats.m
//  Marshmallow
//
//  Created by Brandon Borders on 10/20/15.
//  Copyright © 2015 Cantilevered Marshmallow. All rights reserved.
//

#import "Chats.h"

@implementation Chats

- (id)initWithEntityName:(NSString *)entityName andTitle:(NSString *)title {
    self = [super initWithEntityName:entityName];
    
    if (self) {
        [self setValue:title forKey:@"attrTitle"];
        
        [self populatePropertiesAtColumn:@"title" withValue:title];
    }
    
    return self;
}

@end
