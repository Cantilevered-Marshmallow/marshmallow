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
        _baseUrl = [NSURL URLWithString:@"http://marshmallow.camelcased.com"];
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

- (void)requestWithUser:(NSString *)token
               httpVerb:(NSString *)verb
                    url:(NSString *)url
                   data:(NSDictionary *)data
               response:(void (^)(NSError *error, NSDictionary *response))response {
    if ([verb isEqualToString:@"GET"]) {
        [_manager GET:[[_baseUrl absoluteString] stringByAppendingString:url]
           parameters:data
              success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
                  response(nil, responseObject);
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  response(error, nil);
              }];
    } else if ([verb isEqualToString:@"POST"]) {
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

- (void)requestWithHttpVerb:(NSString *)verb
                        url:(NSString *)url
                       data:(NSDictionary *)data
                   response:(void (^)(NSError *error, NSDictionary *response))response {
    
}

@end
