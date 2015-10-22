//
//  Contact+CoreDataProperties.h
//  Marshmallow
//
//  Created by Brandon Borders on 10/21/15.
//  Copyright © 2015 Cantilevered Marshmallow. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Contact.h"

NS_ASSUME_NONNULL_BEGIN

@interface Contact (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *contactId;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSData *profileImage;

@end

NS_ASSUME_NONNULL_END
