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
        self.googleImage = [[UIImageView alloc] initWithFrame:CGRectMake(25, 140, 200, 200)];
        
        // Add subviews
        [self.contentView addSubview:self.googleImage];
    }
    
    return self;
}

@end
