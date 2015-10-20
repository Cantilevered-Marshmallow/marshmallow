//
//  MessageTestCase.m
//  Marshmallow
//
//  Created by Brandon Borders on 10/20/15.
//  Copyright © 2015 Cantilevered Marshmallow. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "../Marshmallow/Message.h"

@interface MessageTestCase : XCTestCase

@property Message *message;

@end

@implementation MessageTestCase

- (void)setUp {
    [super setUp];

    _message = [[Message alloc] initWithEntityName:@"Message" andChatsId:@"id" andUserId:@"id"];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInitWithEntityNameAndChatsIdAndUserIdMethod {
    XCTAssertTrue([_message.chatsId isEqualToString:@"id"]);
    XCTAssertTrue([_message.userId isEqualToString:@"id"]);
}

@end
