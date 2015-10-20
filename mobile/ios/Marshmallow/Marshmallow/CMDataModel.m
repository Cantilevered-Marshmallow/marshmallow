//
//  CMDataModel.m
//  Marshmallow
//
//  Created by Brandon Borders on 10/20/15.
//  Copyright © 2015 Cantilevered Marshmallow. All rights reserved.
//

#import "CMDataModel.h"

@implementation CMDataModel

- (id)initWithEntityName:(NSString *)entityName {
    self = [super init];
    
    if (self) {
        _accessor = [[CMDataAccessor alloc] init];
        
        _dataObject = [_accessor createObjectForEntityName:entityName];
    }
    
    return self;
}

- (void)setValue:(id)value forKey:(NSString *)key {
    // camelCase-ify the string
    if ([key containsString:@"_"]) {
        NSArray *components = [key componentsSeparatedByString:@"_"];
        key = components[0];
        
        for(int i = 1; i < [components count]; ++i) {
            NSString *uppercase = [[components[i] substringWithRange:NSMakeRange(0, 1)] uppercaseString];
            key = [key stringByAppendingString:uppercase];
            key = [key stringByAppendingString:[components[i] substringFromIndex:1]];
        }
        
        [self setValue:value forKeyPath:key];
    } else {
        if ([key hasPrefix:@"attr"]) {
            key = [key substringFromIndex:4];
            [key stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:[[key substringToIndex:0] lowercaseString]];
            [_dataObject setValue:value forKey:key];
        }
        
        [super setValue:value forKey:key];
    }
}

- (id)valueForKey:(NSString *)key {
    if ([key hasPrefix:@"attr"]) {
        NSString *dataKey = [key substringFromIndex:4];
        [dataKey stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:[[dataKey substringToIndex:0] lowercaseString]];
        return [self.dataObject valueForKey:dataKey];
    } else {
        return [super valueForKey:key];
    }
}

- (BOOL)saveObject {
    return [_accessor saveObject:self.dataObject];
}

- (void)populatePropertiesAtColumn:(NSString *)column withValue:(id)value {
    NSManagedObject *row = [_accessor fetchRowsForColumn:column withValue:value anEntityName:[[_dataObject entity] name]][0];
    
    // Get all the properties of the class
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    for (size_t i = 0; i < count; ++i) {
        NSString *key = [NSString stringWithCString:property_getName(properties[i])];
        
        if (![key isEqualToString:@"accessor"] && ![key isEqualToString:@"dataObject"]) {
            NSString *attrKey = [[key substringWithRange:NSMakeRange(0, 1)] uppercaseString];
            attrKey = [attrKey stringByAppendingString:[key substringFromIndex:1]];
            [self setValue:[row valueForKey:key] forKey:[NSString stringWithFormat:@"attr%@", attrKey]];
        }
    }
}

@end
