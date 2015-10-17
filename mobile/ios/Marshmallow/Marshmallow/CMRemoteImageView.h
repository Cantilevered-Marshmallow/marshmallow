//
//  CMRemoteImageView.h
//  Marshmallow
//
//  Created by Brandon Borders on 10/17/15.
//  Copyright © 2015 Cantilevered Marshmallow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking/AFHTTPRequestOperationManager.h>

IB_DESIGNABLE
@interface CMRemoteImageView : UIImageView

@property IBInspectable UIImage *placeholder;
@property (nonatomic) NSURL *remoteUrl;

- (id)initWithPlaceholder:(UIImage *)placeholder andRemoteUrl:(NSURL *)remoteUrl;

@end
