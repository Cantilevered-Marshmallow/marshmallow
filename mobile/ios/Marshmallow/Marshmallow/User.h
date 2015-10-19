//
//  User.h
//  Marshmallow
//
//  Created by Brandon Borders on 10/19/15.
//  Copyright © 2015 Cantilevered Marshmallow. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CMDataAccessor.h"

@interface User : NSObject

@property (nonatomic) NSString *name;
@property (nonatomic) NSString *email;
@property (nonatomic) NSString *token;
@property (nonatomic) NSData *profileImage;

@property CMDataAccessor *accessor;

@property (readonly) NSManagedObject *userObject;

- (id)initWithName:(NSString *)userName;

- (BOOL)saveUser;

- (void)getUser;

@end
