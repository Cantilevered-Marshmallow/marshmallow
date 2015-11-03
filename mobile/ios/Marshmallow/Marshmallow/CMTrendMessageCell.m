//
//  CMTrendMessageCell.m
//  Marshmallow
//
//  Created by Brandon Borders on 11/3/15.
//  Copyright © 2015 Cantilevered Marshmallow. All rights reserved.
//

#import "CMTrendMessageCell.h"

@implementation CMTrendMessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.thumbnail = [[UIImageView alloc] initWithFrame:CGRectMake(10, 130, 150, 140)];
        self.thumbnail.contentMode = UIViewContentModeScaleAspectFit;
        
        self.trendTitle = [[UILabel alloc] initWithFrame:CGRectMake(170, 165, 200, 60)];
        self.trendTitle.numberOfLines = 0;
        self.trendTitle.font = [UIFont fontWithName:self.trendTitle.font.fontName size:16];
        
        [self.contentView addSubview:self.thumbnail];
        [self.contentView addSubview:self.trendTitle];
        
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTapped:)];
        recognizer.numberOfTapsRequired = 1;
        
        [self addGestureRecognizer:recognizer];
    }
    
    return self;
}

- (void)cellTapped:(id)sender {
    SFSafariViewController *safariViewController = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:self.url] entersReaderIfAvailable:NO];
    [self.delegate displayTrend:safariViewController];
}

@end
