//
//  ContactTestCase.m
//  Marshmallow
//
//  Created by Brandon Borders on 10/20/15.
//  Copyright © 2015 Cantilevered Marshmallow. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "../Marshmallow/Contact.h"

@interface ContactTestCase : XCTestCase

@property Contact *contact;

@end

@implementation ContactTestCase

- (void)setUp {
    [super setUp];

    _contact = [[Contact alloc] initWithEntityName:@"Contact" andName:@"Brandon Borders"];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInitWithEntityNameAndNameMethod {
    XCTAssertTrue([self.contact.name isEqualToString:@"Brandon Borders"]);
}

@end
