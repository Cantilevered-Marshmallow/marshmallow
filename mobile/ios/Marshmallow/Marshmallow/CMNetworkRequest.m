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
        _baseUrl = [NSURL URLWithString:@"http://159.203.90.131:8080"];
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
                  
                  if (operation.response.statusCode == 401) {
                      // Attempt to reauth the user
                      [self reauthUser:jwt httpVerb:verb url:url data:data response:response];
                  } else {
                      response(error, nil);
                  }
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
                   
                   if (operation.response.statusCode == 401) {
                       // Attempt to reauth the user
                       [self reauthUser:jwt httpVerb:verb url:url data:data response:response];
                   } else {
                       response(error, nil);
                   }
               }];
    }
}

- (void)reauthUser:(NSString *)jwt httpVerb:(NSString *)verb url:(NSString *)url data:(NSDictionary *)data response:(void (^)(NSError *, NSDictionary *))response {
    User *user = [User MR_findFirstByAttribute:@"jwt" withValue:jwt inContext:[NSManagedObjectContext MR_defaultContext]];
    if ([verb isEqualToString:@"GET"]) {
        [_manager POST:[[_baseUrl absoluteString] stringByAppendingString:@"/login"]
           parameters:@{@"facebookId": [[FBSDKAccessToken currentAccessToken] userID], @"email": user.email, @"oauthToken": [[FBSDKAccessToken currentAccessToken] tokenString]}
              success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                  [self updateJwt:responseObject[@"token"] givenOldJwt:jwt];
                  [_manager GET:[[_baseUrl absoluteString] stringByAppendingString:url]
                     parameters:data
                        success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                            NSLog(@"Success");
                            response(nil, responseObject);
                        }
                        failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
                            NSLog(@"Error: %@", error);
                            response(error, nil);
                        }];
              }
              failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
                  NSLog(@"Unable to log back in");
              }];
    } else if([verb isEqualToString:@"POST"]) {
        [_manager POST:[[_baseUrl absoluteString] stringByAppendingString:@"/login"]
           parameters:@{@"facebookId": [[FBSDKAccessToken currentAccessToken] userID], @"email": user.email, @"oauthToken": [[FBSDKAccessToken currentAccessToken] tokenString]}
              success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                  [self updateJwt:responseObject[@"token"] givenOldJwt:jwt];
                  [_manager POST:[[_baseUrl absoluteString] stringByAppendingString:url]
                     parameters:data
                        success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                            NSLog(@"Success");
                            response(nil, responseObject);
                        }
                        failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
                            NSLog(@"Error: %@", error);
                            response(error, nil);
                        }];
              }
              failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
                  NSLog(@"Unable to log back in");
              }];
    }
}

- (void)updateJwt:(NSString *)newJwt givenOldJwt:(NSString *)oldJwt {
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        User *user = [User MR_findFirstByAttribute:@"jwt" withValue:oldJwt inContext:localContext];
        user.jwt = newJwt;
    }];
}

@end
