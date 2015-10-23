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
               response:(void (^)(NSError  * _Nullable error, NSDictionary  * _Nullable response))response {
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
        _manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [_manager POST:[[_baseUrl absoluteString] stringByAppendingString:url]
            parameters:data
               success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
                   response(nil, responseObject);
               }
               failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                   response(error, nil);
               }];
    }
}

@end
