//
//  CMNetworkRequest.h
//  Marshmallow
//
//  Created by Brandon Borders on 10/16/15.
//  Copyright © 2015 Cantilevered Marshmallow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFHTTPRequestOperationManager.h>

@interface CMNetworkRequest : NSObject

@property NSURL *baseUrl;

@property AFHTTPRequestOperationManager *manager;

- (id)initWithBaseUrl:(NSURL *)baseUrl;

- (void)requestWithHttpVerb:(NSString *)verb
                    url:(NSString *)url
                   data:(NSDictionary *)data
               response:(void (^)(NSError *error, NSDictionary *response))response;

@end
