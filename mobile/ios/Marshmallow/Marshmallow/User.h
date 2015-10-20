//
//  User.h
//  Marshmallow
//
//  Created by Brandon Borders on 10/19/15.
//  Copyright © 2015 Cantilevered Marshmallow. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CMDataModel.h"

@interface User : CMDataModel

@property (nonatomic) NSString *name;
@property (nonatomic) NSString *email;
@property (nonatomic) NSString *token;
@property (nonatomic) NSData *profileImage;

- (id)initWithEntityName:(NSString *)entityName andName:(NSString *)userName;

@end
