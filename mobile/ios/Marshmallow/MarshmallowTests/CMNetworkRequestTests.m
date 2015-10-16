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

#pragma mark - Method Exists

- (void)testRequestWithUserMethodExists {
    XCTAssertTrue([CMNetworkRequest instancesRespondToSelector:@selector(requestWithUser:httpVerb:url:data:)]);
}

- (void)testRequestWithVerbMethodExists {
    XCTAssertTrue([CMNetworkRequest instancesRespondToSelector:@selector(requestWithHttpVerb:url:data:)]);
}

#pragma mark - Method Behavior

- (void)testInitWithBaseUrlMethod {
    XCTAssertTrue([[_request.baseUrl absoluteString] isEqualToString:@"http://marshmallow.camelcased.com"]);
}

- (void)testInitMethod {
    CMNetworkRequest *request = [[CMNetworkRequest alloc] init];
    XCTAssertTrue([[request.baseUrl absoluteString] isEqualToString:@"http://marshmallow.camelcased.com"]);
}

@end
