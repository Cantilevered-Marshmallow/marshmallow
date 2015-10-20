//
//  User.m
//  Marshmallow
//
//  Created by Brandon Borders on 10/19/15.
//  Copyright © 2015 Cantilevered Marshmallow. All rights reserved.
//

#import "User.h"

@implementation User

// Use this instead of init as this will properly initialize the object
- (id)initWithEntityName:(NSString *)entityName andName:(NSString *)userName {
    self = [super initWithEntityName:entityName];
    
    if (self) {
        [self setValue:userName forKey:@"attrName"];
        
        [self populatePropertiesAtColumn:@"name" withValue:userName];
    }
    
    return self;
}

@end
