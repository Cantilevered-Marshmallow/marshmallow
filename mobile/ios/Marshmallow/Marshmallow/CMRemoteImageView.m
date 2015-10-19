//
//  CMRemoteImageView.m
//  Marshmallow
//
//  Created by Brandon Borders on 10/17/15.
//  Copyright © 2015 Cantilevered Marshmallow. All rights reserved.
//

#import "CMRemoteImageView.h"

@implementation CMRemoteImageView

- (id)initWithPlaceholder:(UIImage *)placeholder andRemoteUrl:(NSURL *)remoteUrl {
    self = [super init];
    
    if (self) {
        _placeholder = placeholder;
        _remoteUrl = remoteUrl;
        
        [self setImage:placeholder];
    }
    
    return self;
}

- (void)setRemoteUrl:(NSURL *)remoteUrl {
    _remoteUrl = remoteUrl;
    
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:[NSURLRequest requestWithURL:remoteUrl]];
    requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
    
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self setImage:((UIImage *)responseObject)];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Image error: %@", error);
    }];
    [requestOperation start];
}

@end
