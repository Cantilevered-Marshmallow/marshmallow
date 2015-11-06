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
        // Assign the base url to be our server
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
    
    if ([verb isEqualToString:@"GET"]) { // Is it going to be a GET request?
        [_manager GET:[[_baseUrl absoluteString] stringByAppendingString:url]
           parameters:data
              success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
                  NSLog(@"Success");
                  response(nil, responseObject);
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  NSLog(@"Error: %@", error);
                  
                  // Notify the user
                  [HDNotificationView showNotificationViewWithImage:[UIImage imageNamed:@"Icon"] title:@"Network Error" message:@"An error occured trying to communicate with our server" isAutoHide:YES];
                  
                  if (operation.response.statusCode == 401) {
                      // Attempt to reauth the user
                      [self reauthUser:jwt httpVerb:verb url:url data:data response:response];
                  } else {
                      response(error, nil);
                  }
              }];
    } else if ([verb isEqualToString:@"POST"]) { // Or is it going to be a POST request?
        [_manager POST:[[_baseUrl absoluteString] stringByAppendingString:url]
            parameters:data
               success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
                   response(nil, responseObject);
                   NSLog(@"Success");
               }
               failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                   NSLog(@"Error: %@", error);
                   
                   // Notify the user
                   [HDNotificationView showNotificationViewWithImage:[UIImage imageNamed:@"Icon"] title:@"Network Error" message:@"An error occured trying to communicate with our server" isAutoHide:YES];
                   
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
    // Get the user object for use later
    User *user = [User MR_findFirstByAttribute:@"jwt" withValue:jwt inContext:[NSManagedObjectContext MR_defaultContext]];
    if ([verb isEqualToString:@"GET"]) { // Is it going to be a GET request?
        [_manager POST:[[_baseUrl absoluteString] stringByAppendingString:@"/login"]
           parameters:@{@"facebookId": [[FBSDKAccessToken currentAccessToken] userID], @"email": user.email, @"oauthToken": [[FBSDKAccessToken currentAccessToken] tokenString]}
              success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                  // Update the user with the new jwt
                  [self updateJwt:responseObject[@"token"] givenOldJwt:jwt];
                  
                  [_manager GET:[[_baseUrl absoluteString] stringByAppendingString:url]
                     parameters:data
                        success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                            NSLog(@"Success");
                            response(nil, responseObject);
                        }
                        failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
                            NSLog(@"Error: %@", error);
                            
                            // Notify the user
                            [HDNotificationView showNotificationViewWithImage:[UIImage imageNamed:@"Icon"] title:@"Network Error" message:@"An error occured trying to communicate with our server" isAutoHide:YES];
                            
                            response(error, nil);
                        }];
              }
              failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
                  NSLog(@"Unable to log back in");
                  
                  // Notify the user
                  [HDNotificationView showNotificationViewWithImage:[UIImage imageNamed:@"Icon"] title:@"Authentication Error" message:@"Your session has expired. Restart the app in a few minutes" isAutoHide:YES];
              }];
    } else if([verb isEqualToString:@"POST"]) { // Or is it going to be a POST request?
        [_manager POST:[[_baseUrl absoluteString] stringByAppendingString:@"/login"]
           parameters:@{@"facebookId": [[FBSDKAccessToken currentAccessToken] userID], @"email": user.email, @"oauthToken": [[FBSDKAccessToken currentAccessToken] tokenString]}
              success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                  // Update the user with the new jwt
                  [self updateJwt:responseObject[@"token"] givenOldJwt:jwt];
                  
                  [_manager POST:[[_baseUrl absoluteString] stringByAppendingString:url]
                     parameters:data
                        success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                            NSLog(@"Success");
                            response(nil, responseObject);
                        }
                        failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
                            NSLog(@"Error: %@", error);
                            
                            // Notify the user
                            [HDNotificationView showNotificationViewWithImage:[UIImage imageNamed:@"Icon"] title:@"Network Error" message:@"An error occured trying to communicate with our server" isAutoHide:YES];
                            
                            response(error, nil);
                        }];
              }
              failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
                  NSLog(@"Unable to log back in");
                  
                  // Notify the user
                  [HDNotificationView showNotificationViewWithImage:[UIImage imageNamed:@"Icon"] title:@"Authentication Error" message:@"Your session has expired. Restart the app in a few minutes" isAutoHide:YES];
              }];
    }
}

- (void)updateJwt:(NSString *)newJwt givenOldJwt:(NSString *)oldJwt {
    // Save the new jwt
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        User *user = [User MR_findFirstByAttribute:@"jwt" withValue:oldJwt inContext:localContext];
        user.jwt = newJwt;
    }];
}

@end
