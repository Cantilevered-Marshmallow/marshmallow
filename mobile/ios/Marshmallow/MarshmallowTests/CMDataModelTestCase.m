//
//  CMDataModelTestCase.m
//  Marshmallow
//
//  Created by Brandon Borders on 10/20/15.
//  Copyright © 2015 Cantilevered Marshmallow. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "../Marshmallow/User.h"

@interface CMDataModelTestCase : XCTestCase

@property User *model;

@end

@implementation CMDataModelTestCase

- (void)setUp {
    [super setUp];

    _model = [[User alloc] initWithEntityName:@"TestUser"];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSetValueForKeyOverrideWithUnderscores {
    [self.model setValue:[@"Hello, World" dataUsingEncoding:NSUTF8StringEncoding] forKey:@"attrProfile_image"];
    NSString *profileImageString = [[NSString alloc] initWithData:self.model.profileImage encoding:NSUTF8StringEncoding];
    XCTAssertTrue([profileImageString isEqualToString:@"Hello, World"]);
}

- (void)testSetValueForKeyOverrideWithAttrPrefix {
    [self.model setValue:@"Marsh Canti" forKey:@"attrName"];
    XCTAssertTrue([self.model.name isEqualToString:@"Marsh Canti"]);
}

- (void)testSetValueForKeyOverrideDeafult {
    [self.model setValue:@"Marsh Canti" forKey:@"name"];
    XCTAssertTrue([self.model.name isEqualToString:@"Marsh Canti"]);
}

- (void)testValueForKeyOverrideDefault {
    self.model.name = @"Marsh Canti";
    XCTAssertTrue([[self.model valueForKey:@"name"] isEqualToString:@"Marsh Canti"]);
    
    self.model.name = nil;
    
    [self.model setValue:@"Marsh Canti" forKey:@"attrName"];
    XCTAssertTrue([[self.model valueForKey:@"name"] isEqualToString:@"Marsh Canti"]);
}

- (void)testValueForKeyOverrideWithAttrPrefix {
    [self.model setValue:@"Marsh Canti" forKey:@"attrName"];
    XCTAssertTrue([[self.model valueForKey:@"attrName"] isEqualToString:@"Marsh Canti"]);
}

- (void)testSaveObjectMethod {
    [_model setValue:@"Marsh Canti" forKey:@"attrName"];
    [_model saveObject];
    
    _model = [[User alloc] initWithEntityName:@"TestUser"];
    [_model populatePropertiesAtColumn:@"name" withValue:@"Marsh Canti"];
    XCTAssertTrue([_model.name isEqualToString:@"Marsh Canti"]);
}

@end
