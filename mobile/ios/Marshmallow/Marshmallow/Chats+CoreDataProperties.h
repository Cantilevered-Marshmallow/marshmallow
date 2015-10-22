//
//  Chats+CoreDataProperties.h
//  Marshmallow
//
//  Created by Brandon Borders on 10/21/15.
//  Copyright © 2015 Cantilevered Marshmallow. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Chats.h"

NS_ASSUME_NONNULL_BEGIN

@interface Chats (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *id;
@property (nullable, nonatomic, retain) NSString *title;

@end

NS_ASSUME_NONNULL_END
