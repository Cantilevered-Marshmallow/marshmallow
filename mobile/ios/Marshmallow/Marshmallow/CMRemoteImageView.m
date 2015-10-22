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

- (void)setRemoteUrl:(NSURL *)remoteUrl success:(void (^)(UIImage *))success {
    _remoteUrl = remoteUrl;
    
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:[NSURLRequest requestWithURL:remoteUrl]];
    requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
    
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        UIImage *image = ((UIImage *)responseObject);
        [self setImage:image];
        success(image);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Image error: %@", error);
    }];
    [requestOperation start];
}

@end
