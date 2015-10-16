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
    
}

- (void)requestWithHttpVerb:(NSString *)verb
                        url:(NSString *)url
                       data:(NSDictionary *)data
                   response:(void (^)(NSError *error, NSDictionary *response))response {
    
}

@end
