//
//  CMYoutubeVideoMessageCell.h
//  Marshmallow
//
//  Created by Brandon Borders on 10/29/15.
//  Copyright © 2015 Cantilevered Marshmallow. All rights reserved.
//

#import "CMMessageCell.h"

#import <XCDYouTubeKit/XCDYouTubeKit.h>

@interface CMYoutubeVideoMessageCell : CMMessageCell <UIGestureRecognizerDelegate>

@property (strong, nonatomic) UIImageView *thumbnail;

@property (strong, nonatomic) UILabel *title;

@property (strong, nonatomic) UILabel *channel;

@property (strong, nonatomic) NSString *videoId;

@property (weak, nonatomic) UIViewController *viewController;

- (void)showVideo:(id)sender;

@end
