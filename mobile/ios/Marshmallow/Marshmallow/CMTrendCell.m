//
//  CMTrendCell.m
//  Marshmallow
//
//  Created by Brandon Borders on 11/2/15.
//  Copyright © 2015 Cantilevered Marshmallow. All rights reserved.
//

#import "CMTrendCell.h"

@implementation CMTrendCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        // Initialize the thumbnail
        self.thumbnail = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 130, 150)];
        self.thumbnail.contentMode = UIViewContentModeScaleAspectFit;
        
        // Initialize the title
        self.trendTitle = [[UILabel alloc] initWithFrame:CGRectMake(150, 55, 170, 60)];
        self.trendTitle.numberOfLines = 0;
        self.trendTitle.font = [UIFont fontWithName:self.trendTitle.font.fontName size:20];
        
        [self.contentView addSubview:self.thumbnail];
        [self.contentView addSubview:self.trendTitle];
        
        // Add single tap recognizer to have the event bubble up to the table view
        UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:nil];
        singleRecognizer.numberOfTapsRequired = 1;
        
        singleRecognizer.cancelsTouchesInView = NO;
        
        [self addGestureRecognizer:singleRecognizer];
        
        // Add double tap to display the web page
        UITapGestureRecognizer *doubleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTapped:)];
        doubleRecognizer.numberOfTapsRequired = 2;
        
        [self addGestureRecognizer:doubleRecognizer];
        
        // Tells the double tap to not fire when a single tap occurs
        [singleRecognizer requireGestureRecognizerToFail:doubleRecognizer];
    }
    
    return self;
}

- (void)cellTapped:(UITapGestureRecognizer *)sender {
    SFSafariViewController *safariViewController = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:self.url] entersReaderIfAvailable:NO];
    safariViewController.delegate = self.delegate;
    
    // Tell the delegate to display the web view
    [self.delegate showViewController:safariViewController];
    
    self.accessoryView = nil;
}

@end
