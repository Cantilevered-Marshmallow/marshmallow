//
//  Message+CoreDataProperties.h
//  Marshmallow
//
//  Created by Brandon Borders on 10/21/15.
//  Copyright © 2015 Cantilevered Marshmallow. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Message.h"

NS_ASSUME_NONNULL_BEGIN

@interface Message (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *body;
@property (nullable, nonatomic, retain) NSString *chatsId;
@property (nullable, nonatomic, retain) NSString *googleImageId;
@property (nullable, nonatomic, retain) NSDate *timestamp;
@property (nullable, nonatomic, retain) NSString *userId;
@property (nullable, nonatomic, retain) NSString *youtubeVideoId;
@property (nullable, nonatomic, retain) Chats *chats;
@property (nullable, nonatomic, retain) User *user;

@end

NS_ASSUME_NONNULL_END
