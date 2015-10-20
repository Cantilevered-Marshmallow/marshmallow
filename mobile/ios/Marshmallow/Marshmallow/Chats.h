//
//  Chats.h
//  Marshmallow
//
//  Created by Brandon Borders on 10/20/15.
//  Copyright © 2015 Cantilevered Marshmallow. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CMDataAccessor.h"
#import "CMDataModel.h"

@interface Chats : CMDataModel

@property (nonatomic) NSString *id;
@property (nonatomic) NSString *title;

- (id)initWithEntityName:(NSString *)entityName andTitle:(NSString *)title;

@end
