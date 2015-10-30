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

    _request = [[CMNetworkRequest alloc] initWithBaseUrl:[NSURL URLWithString:@"http://159.203.90.131:8080"]];
    
    // Remove any cookies from a previous logged in session
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:@"http://159.203.90.131:8080"]];
    for (NSHTTPCookie *cookie in cookies)
    {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    }
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

#pragma mark - Method Exists

- (void)testRequestWithVerbMethodExists {
    XCTAssertTrue([CMNetworkRequest instancesRespondToSelector:@selector(requestWithHttpVerb:url:data:jwt:response:)]);
}

#pragma mark - Method Behavior

- (void)testInitWithBaseUrlMethod {
    XCTAssertTrue([[_request.baseUrl absoluteString] isEqualToString:@"http://159.203.90.131:8080"]);
    XCTAssertTrue(_request.manager);
}

- (void)testInitMethod {
    CMNetworkRequest *request = [[CMNetworkRequest alloc] init];
    XCTAssertTrue([[request.baseUrl absoluteString] isEqualToString:@"http://159.203.90.131:8080"]);
    XCTAssertTrue(_request.manager);
}

- (void)testRequestWithHttpVerbUrlDataResponseMethod {
    XCTestExpectation *getException = [self expectationWithDescription:@"GET request threw"];
    
    // Test GET request without user
    [_request requestWithHttpVerb:@"GET"
                              url:@"/"
                             data:@{}
                              jwt:nil
                         response:^(NSError *error, NSDictionary *response) {
                             if ([error.userInfo[@"NSLocalizedDescription"] isEqualToString:@"Request failed: not found (404)"]) {
                                 [getException fulfill];
                             } else {
                                 NSLog(@"Callback: %@", error);
                             }
                         }];
    
    XCTestExpectation *postException = [self expectationWithDescription:@"POST request threw"];
    // Test POST request without user
    [_request requestWithHttpVerb:@"POST"
                              url:@"/"
                             data:@{}
                              jwt:nil
                         response:^(NSError *error, NSDictionary *response) {
                             if ([error.userInfo[@"NSLocalizedDescription"] isEqualToString:@"Request failed: not found (404)"]) {
                                 [postException fulfill];
                             } else {
                                 NSLog(@"Callback: %@", error);
                             }
                         }];
    
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error) {
        if (error) {
            XCTFail(@"Exception for request without user failed: %@", error);
        }
    }];
}

@end
