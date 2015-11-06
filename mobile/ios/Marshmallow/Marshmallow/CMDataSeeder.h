//
//  CMDataSeeder.h
//  Marshmallow
//
//  Created by Brandon Borders on 11/6/15.
//  Copyright © 2015 Cantilevered Marshmallow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MagicalRecord/MagicalRecord.h>

#import "Contact.h"
#import "Chats.h"
#import "Message.h"

@interface CMDataSeeder : NSObject

+ (void)run;

@end
