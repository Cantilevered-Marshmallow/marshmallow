//
//  CMDataAccessorTestCase.m
//  Marshmallow
//
//  Created by Brandon Borders on 10/19/15.
//  Copyright © 2015 Cantilevered Marshmallow. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "../Marshmallow/CMDataAccessor.h"

@interface CMDataAccessorTestCase : XCTestCase

@property CMDataAccessor *accessor;

@end

@implementation CMDataAccessorTestCase

- (void)setUp {
    [super setUp];
    
    _accessor = [[CMDataAccessor alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testGetEntityForNameMethod {
    XCTAssertTrue([@"TestUser" isEqualToString:[[_accessor getEntityForName:@"TestUser"] name]]);
}

- (void)testCreateObjectForEntityNameMethod {
    NSEntityDescription *entity = [[_accessor createObjectForEntityName:@"TestUser"] entity];
    XCTAssertTrue([@"TestUser" isEqualToString:[entity name]]);
}

- (void)testSaveObjectMethod {
    NSManagedObject *object = [_accessor createObjectForEntityName:@"TestUser"];
    [object setValue:@"Marsh Canti" forKey:@"name"];
    XCTAssertTrue([_accessor saveObject:object]);
}

- (void)testFetchRowsForColumnWithValueEntityNameMethod {
    NSArray *results = [_accessor fetchRowsForColumn:@"name" withValue:@"Marsh Canti" anEntityName:@"TestUser"];
    XCTAssertTrue([results count] > 0);
}

@end
