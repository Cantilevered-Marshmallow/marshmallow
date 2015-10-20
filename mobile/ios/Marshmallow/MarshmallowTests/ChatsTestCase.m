//
//  ChatsTestCase.m
//  Marshmallow
//
//  Created by Brandon Borders on 10/20/15.
//  Copyright © 2015 Cantilevered Marshmallow. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "../Marshmallow/Chats.h"

@interface ChatsTestCase : XCTestCase

@property Chats *chats;

@end

@implementation ChatsTestCase

- (void)setUp {
    [super setUp];

    _chats = [[Chats alloc] initWithEntityName:@"Chats" andTitle:@"Lonely Chat"];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInitWithEntityNameAndTitleMethod {
    XCTAssertTrue([_chats.title isEqualToString:@"Lonely Chat"]);
}

@end
