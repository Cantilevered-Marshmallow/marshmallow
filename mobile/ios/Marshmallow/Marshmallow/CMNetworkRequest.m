//
//  CMNetworkRequest.m
//  Marshmallow
//
//  Created by Brandon Borders on 10/16/15.
//  Copyright © 2015 Cantilevered Marshmallow. All rights reserved.
//

#import "CMNetworkRequest.h"

@implementation CMNetworkRequest

- (id)init {
    self = [super init];
    
    if (self) {
        _baseUrl = [NSURL URLWithString:@"https://marshy.herokuapp.com"];
        _manager = [AFHTTPRequestOperationManager manager];
    }
    
    return self;
}

- (id)initWithBaseUrl:(NSURL *)baseUrl {
    self = [super init];
    
    if (self) {
        _baseUrl = baseUrl;
        _manager = [AFHTTPRequestOperationManager manager];
    }
    
    return self;
}

- (void)requestWithHttpVerb:(NSString *)verb
                        url:(NSString *)url
                       data:(NSDictionary *)data
                        jwt:(NSString *)jwt
                   response:(void (^)(NSError *error, NSDictionary *response))response {
    _manager.requestSerializer = [AFJSONRequestSerializer serializer]; // Reassign the request serializer to use JSON
    [_manager.requestSerializer setValue:jwt forHTTPHeaderField:@"token"];
    
    NSLog(@"Data: %@", data);
    
    if ([verb isEqualToString:@"GET"]) {
        [_manager GET:[[_baseUrl absoluteString] stringByAppendingString:url]
           parameters:data
              success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
                  NSLog(@"Success");
                  response(nil, responseObject);
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  NSLog(@"Error: %@", error);
                  response(error, nil);
              }];
    } else if ([verb isEqualToString:@"POST"]) {
        [_manager POST:[[_baseUrl absoluteString] stringByAppendingString:url]
            parameters:data
               success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
                   response(nil, responseObject);
                   NSLog(@"Success");
               }
               failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                   NSLog(@"Error: %@", error);
                   response(error, nil);
               }];
    }
}

@end
