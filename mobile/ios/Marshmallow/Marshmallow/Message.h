//
//  Message.h
//  Marshmallow
//
//  Created by Brandon Borders on 10/20/15.
//  Copyright © 2015 Cantilevered Marshmallow. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CMDataModel.h"

@interface Message : CMDataModel

@property (nonatomic) NSString *body;
@property (nonatomic) NSString *chatsId;
@property (nonatomic) NSString *googleImageId;
@property (nonatomic) NSString *userId;
@property (nonatomic) NSString *youtubeVideoId;
@property (nonatomic) NSDate *timestamp;

- (id)initWithEntityName:(NSString *)entityName andChatsId:(NSString *)chatsId andUserId:(NSString *)userId;

@end
