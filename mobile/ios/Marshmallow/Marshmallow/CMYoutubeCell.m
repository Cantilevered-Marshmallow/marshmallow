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
        
        // Create title label
        self.title = [[UILabel alloc] initWithFrame:CGRectMake(140, 10, self.contentView.frame.size.width - 140, 20)];
        self.title.textColor = [UIColor blackColor];
        
        // Create channel label
        self.channel = [[UILabel alloc] initWithFrame:CGRectMake(140, 30, self.contentView.frame.size.width - 140, 20)];
        self.channel.textColor = [UIColor grayColor];
        
        // Create runtime label
        self.runtime = [[UILabel alloc] initWithFrame:CGRectMake(140, 50, self.contentView.frame.size.width - 140, 20)];
        self.runtime.textColor = [UIColor grayColor];
        
        // Add views to the contentview
        [self.contentView addSubview:self.thumbnail];
        [self.contentView addSubview:self.title];
        [self.contentView addSubview:self.channel];
        [self.contentView addSubview:self.runtime];
        
        self.contentView.frame = CGRectMake(0, 0, self.contentView.frame.size.width, 110);
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
