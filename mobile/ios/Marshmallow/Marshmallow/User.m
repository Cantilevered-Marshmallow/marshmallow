//
//  User.m
//  Marshmallow
//
//  Created by Brandon Borders on 10/19/15.
//  Copyright © 2015 Cantilevered Marshmallow. All rights reserved.
//

#import "User.h"

@implementation User

- (id)init {
    self = [super init];
    
    if (self) {
        _accessor = [[CMDataAccessor alloc] init];
        
        _userObject = [_accessor createObjectForEntityName:@"User"];
    }
    
    return self;
}

- (id)initWithName:(NSString *)userName {
    self = [self init];
    
    if (self) {
        self.name = userName;
        
        [self getUser];
    }
    
    return self;
}

- (BOOL)saveUser {
    return [_accessor saveObject:_userObject];
}

- (void)getUser {
    NSArray *results = [_accessor fetchRowsForColumn:@"name" withValue:self.name anEntityName:@"User"];
    
    if ([results count] > 0) {
        _userObject = results[0];
        self.email = [_userObject valueForKey:@"email"];
        self.token = [_userObject valueForKey:@"token"];
        self.profileImage = [_userObject valueForKey:@"profile_image"];
    }
}

- (NSString *)description {
    return [NSString stringWithFormat:@"User %@ prefers to be contacted at %@. Their auth token is %@.", self.name, self.email, self.token];
}

#pragma mark - setters

- (void)setName:(NSString *)name {
    _name = name;
    
    [_userObject setValue:name forKey:@"name"];
}

- (void)setEmail:(NSString *)email {
    _email = email;
    
    [_userObject setValue:email forKey:@"email"];
}

- (void)setToken:(NSString *)token {
    _token = token;
    
    [_userObject setValue:token forKey:@"token"];
}

- (void)setProfileImage:(NSData *)profileImage {
    _profileImage = profileImage;
    
    [_userObject setValue:profileImage forKey:@"profile_image"];
}

@end
