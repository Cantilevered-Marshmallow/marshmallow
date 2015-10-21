//
//  Contact.m
//  Marshmallow
//
//  Created by Brandon Borders on 10/20/15.
//  Copyright © 2015 Cantilevered Marshmallow. All rights reserved.
//

#import "Contact.h"

@implementation Contact

- (id)initWithEntityName:(NSString *)entityName andName:(NSString *)name {
    self = [super initWithEntityName:entityName];
    
    if (self) {
        [self setValue:name forKey:@"attrName"];
        
        [self populatePropertiesAtColumn:@"name" withValue:name];
    }
    
    return self;
}

- (id)initWithObject:(NSManagedObject *)object {
    self = [super initWithObject:object];
    
    if (self) {
        [self populatePropertiesAtColumn:@"name" withValue:[object valueForKey:@"name"]];
    }
    
    return self;
}

@end
