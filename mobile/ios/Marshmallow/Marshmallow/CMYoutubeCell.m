//
//  CMYoutubeCell.m
//  Marshmallow
//
//  Created by Brandon Borders on 10/28/15.
//  Copyright © 2015 Cantilevered Marshmallow. All rights reserved.
//

#import "CMYoutubeCell.h"

@implementation CMYoutubeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        // Create thumbnail view
        self.thumbnail = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 120, 90)];
        self.thumbnail.contentMode = UIViewContentModeScaleAspectFit;
        self.thumbnail.userInteractionEnabled = NO;
        
        // Create title label
        self.title = [[UILabel alloc] initWithFrame:CGRectMake(140, 10, self.contentView.frame.size.width - 140, 20)];
        self.title.textColor = [UIColor blackColor];
        self.title.userInteractionEnabled = NO;
        
        // Create channel label
        self.channel = [[UILabel alloc] initWithFrame:CGRectMake(140, 30, self.contentView.frame.size.width - 140, 20)];
        self.channel.textColor = [UIColor grayColor];
        self.channel.userInteractionEnabled = NO;
        
        // Create runtime label
        self.runtime = [[UILabel alloc] initWithFrame:CGRectMake(140, 50, self.contentView.frame.size.width - 140, 20)];
        self.runtime.textColor = [UIColor grayColor];
        self.runtime.userInteractionEnabled = NO;
        
        // Create highthumbnail off cell
        self.highThumbnail = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 480, 360)];
        self.highThumbnail.hidden = YES;
        self.highThumbnail.contentMode = UIViewContentModeScaleAspectFit;
        self.highThumbnail.userInteractionEnabled = NO;
        
        // Add views to the contentview
        [self.contentView addSubview:self.thumbnail];
        [self.contentView addSubview:self.highThumbnail];
        [self.contentView addSubview:self.title];
        [self.contentView addSubview:self.channel];
        [self.contentView addSubview:self.runtime];
        
        // Set the height to 110
        self.contentView.frame = CGRectMake(0, 0, self.contentView.frame.size.width, 110);
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
