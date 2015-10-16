//
//  CMNetworkRequest.h
//  Marshmallow
//
//  Created by Brandon Borders on 10/16/15.
//  Copyright © 2015 Cantilevered Marshmallow. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CMNetworkRequest : NSObject

@property NSURL *baseUrl;

- (id)initWithBaseUrl:(NSURL *)baseUrl;

- (void)requestWithUser:(NSString *)token;

@end
