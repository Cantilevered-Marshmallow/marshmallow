//
//  Contact.h
//  Marshmallow
//
//  Created by Brandon Borders on 10/20/15.
//  Copyright © 2015 Cantilevered Marshmallow. All rights reserved.
//

#import "CMDataModel.h"

@interface Contact : CMDataModel

@property (nonatomic) NSString *contactId;
@property (nonatomic) NSString *name;
@property (nonatomic) NSData *profileImage;

- (id)initWithEntityName:(NSString *)entityName andName:(NSString *)name;

@end
