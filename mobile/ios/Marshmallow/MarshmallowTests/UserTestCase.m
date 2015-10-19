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
    
    _user = [[User alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSaveUserMethod {
    _user.name = @"Marsh Canti";
    _user.email = @"marsh@marshmallowworld.com";
    XCTAssertTrue([_user saveUser]);
}

- (void)testGetUserMethod {
    _user.name = @"Marsh Canti";
    [_user getUser];
    XCTAssertTrue([_user.email isEqualToString:@"marsh@marshmallowworld.com"]);
}

- (void)testInitWithNameMethod {
    _user = [[User alloc] initWithName:@"Marsh Canti"];
    XCTAssertTrue([_user.name isEqualToString:@"Marsh Canti"]);
}

@end
