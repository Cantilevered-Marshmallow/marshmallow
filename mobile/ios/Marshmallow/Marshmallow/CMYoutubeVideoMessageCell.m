//
//  CMYoutubeVideoMessageCell.m
//  Marshmallow
//
//  Created by Brandon Borders on 10/29/15.
//  Copyright © 2015 Cantilevered Marshmallow. All rights reserved.
//

#import "CMYoutubeVideoMessageCell.h"

@implementation CMYoutubeVideoMessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        // Setup the container
        self.videoContianer = [[UIView alloc] initWithFrame:CGRectMake(25, 140, self.contentView.frame.size.width, 90)];
        self.videoContianer.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showVideo:)];
        recognizer.numberOfTapsRequired = 1;
        [self.videoContianer addGestureRecognizer:recognizer];
        recognizer.delegate = self;
        
        // Setup video thumbnail view
        self.thumbnail = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 120, 90)];
        
        // Setup title label
        self.title = [[UILabel alloc] initWithFrame:CGRectMake(125, 0, self.contentView.frame.size.width - 120, 20)];
        
        // Setup chanel label
        self.channel = [[UILabel alloc] initWithFrame:CGRectMake(125, 20, self.contentView.frame.size.width - 120, 20)];
        self.channel.textColor = [UIColor grayColor];
        
        // Add subviews
        [self.videoContianer addSubview:self.thumbnail];
        [self.videoContianer addSubview:self.title];
        [self.videoContianer addSubview:self.channel];
        
        [self.contentView addSubview:self.videoContianer];
    }
    
    return self;
}

- (void)showVideo:(id)sender {
    // Play the video when selected
    XCDYouTubeVideoPlayerViewController *videoPlayerController = [[XCDYouTubeVideoPlayerViewController alloc] initWithVideoIdentifier:self.videoId];
    [self.viewController presentMoviePlayerViewControllerAnimated:videoPlayerController];
}

@end
