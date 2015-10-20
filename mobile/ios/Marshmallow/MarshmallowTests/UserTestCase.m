//
//  UserTestCase.m
//  Marshmallow
//
//  Created by Brandon Borders on 10/19/15.
//  Copyright © 2015 Cantilevered Marshmallow. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "../Marshmallow/User.h"

@interface UserTestCase : XCTestCase

@property User *user;

@end

@implementation UserTestCase

- (void)setUp {
    [super setUp];
    
    _user = [[User alloc] initWithEntityName:@"TestUser" andName:@"Marsh Canti"];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInitWithNameMethod {
    XCTAssertTrue([_user.name isEqualToString:@"Marsh Canti"]);
}

@end
