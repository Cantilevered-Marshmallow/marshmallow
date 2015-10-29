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
        // Setup video thumbnail view
        self.thumbnail = [[UIImageView alloc] initWithFrame:CGRectMake(25, 140, 120, 90)];
        
        // Setup title label
        self.title = [[UILabel alloc] initWithFrame:CGRectMake(150, 140, self.contentView.frame.size.width - 150, 20)];
        
        // Setup chanel label
        self.channel = [[UILabel alloc] initWithFrame:CGRectMake(150, 160, self.contentView.frame.size.width - 150, 20)];
        self.channel.textColor = [UIColor grayColor];
        
        // Add subviews
        [self.contentView addSubview:self.thumbnail];
        [self.contentView addSubview:self.title];
        [self.contentView addSubview:self.channel];
    }
    
    return self;
}

@end
