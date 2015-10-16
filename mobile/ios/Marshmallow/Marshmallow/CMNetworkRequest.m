//
//  CMNetworkRequest.m
//  Marshmallow
//
//  Created by Brandon Borders on 10/16/15.
//  Copyright © 2015 Cantilevered Marshmallow. All rights reserved.
//

#import "CMNetworkRequest.h"

@implementation CMNetworkRequest

- (id)initWithBaseUrl:(NSURL *)baseUrl {
    self = [super init];
    
    if (self) {
        _baseUrl = baseUrl;
    }
    
    return self;
}

- (void)requestWithUser:(NSString *)token httpVerb:(NSString *)verb data:(NSDictionary *)data {
    
}

- (void)requestWithHttpVerb:(NSString *)verb data:(NSDictionary *)data {
    
}

@end