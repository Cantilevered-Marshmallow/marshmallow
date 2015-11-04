//
//  CMNetworkRequest.h
//  Marshmallow
//
//  Created by Brandon Borders on 10/16/15.
//  Copyright © 2015 Cantilevered Marshmallow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import <MagicalRecord/MagicalRecord.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

#import "User.h"

@interface CMNetworkRequest : NSObject

@property NSURL *baseUrl;

@property AFHTTPRequestOperationManager *manager;

- (id)initWithBaseUrl:(NSURL *)baseUrl;

- (void)requestWithHttpVerb:(NSString *)verb
                    url:(NSString *)url
                   data:(NSDictionary *)data
                    jwt:(NSString *)jwt
               response:(void (^)(NSError *error, NSDictionary *response))response;

- (void)reauthUser:(NSString *)jwt httpVerb:(NSString *)verb url:(NSString *)url data:(NSDictionary *)data response:(void (^)(NSError *error, NSDictionary *response))response;

- (void)updateJwt:(NSString *)newJwt givenOldJwt:(NSString *)oldJwt;

@end
