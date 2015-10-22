//
//  User+CoreDataProperties.h
//  Marshmallow
//
//  Created by Brandon Borders on 10/21/15.
//  Copyright © 2015 Cantilevered Marshmallow. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface User (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *email;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSData *profileImage;
@property (nullable, nonatomic, retain) NSString *token;
@property (nullable, nonatomic, retain) NSManagedObject *chatParticipation;

@end

NS_ASSUME_NONNULL_END
