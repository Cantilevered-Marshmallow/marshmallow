//
//  CMNetworkRequestTests.m
//  Marshmallow
//
//  Created by Brandon Borders on 10/16/15.
//  Copyright © 2015 Cantilevered Marshmallow. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "../Marshmallow/CMNetworkRequest.h"

@interface CMNetworkRequestTests : XCTestCase

@property CMNetworkRequest *request;

@end

@implementation CMNetworkRequestTests

- (void)setUp {
    [super setUp];

    _request = [[CMNetworkRequest alloc] initWithBaseUrl:[NSURL URLWithString:@"http://marshmallow.camelcased.com"]];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testRequestWithUserMethodExists {
    XCTAssertTrue([CMNetworkRequest instancesRespondToSelector:@selector(requestWithUser:httpVerb:data:)]);
}

- (void)testRequestWithVerbMethodExists {
    XCTAssertTrue([CMNetworkRequest instancesRespondToSelector:@selector(requestWithHttpVerb:data:)]);
}

@end
