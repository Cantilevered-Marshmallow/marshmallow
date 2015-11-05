//
//  CMGImageMessageCell.m
//  Marshmallow
//
//  Created by Brandon Borders on 10/28/15.
//  Copyright © 2015 Cantilevered Marshmallow. All rights reserved.
//

#import "CMGImageMessageCell.h"

@implementation CMGImageMessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        // Setup google image view
        double screenWidth = [UIScreen mainScreen].bounds.size.width;
        // Center formula 50% screen width - 50% image width
        self.googleImage = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth / 2 - 100, 140, 200, 200)];
        self.googleImage.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapOnImage:)];
        recognizer.numberOfTapsRequired = 2;
        [self.googleImage addGestureRecognizer:recognizer];
        recognizer.delegate = self;
        
        // Add subviews
        [self.contentView addSubview:self.googleImage];
    }
    
    return self;
}

- (void)handleTapOnImage:(id)sender {
    // Popup for larger version of image
    CMImagePopup *pop = [[CMImagePopup alloc] init];
    [pop.iv setImage:self.googleImage.image];
    
    [pop show];
}

@end
