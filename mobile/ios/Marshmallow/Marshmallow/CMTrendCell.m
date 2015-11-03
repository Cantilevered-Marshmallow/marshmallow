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
        
        self.thumbnail = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 130, 150)];
        self.thumbnail.contentMode = UIViewContentModeScaleAspectFit;
        
        self.trendTitle = [[UILabel alloc] initWithFrame:CGRectMake(150, 55, 170, 60)];
        self.trendTitle.numberOfLines = 0;
        self.trendTitle.font = [UIFont fontWithName:self.trendTitle.font.fontName size:20];
        
        [self.contentView addSubview:self.thumbnail];
        [self.contentView addSubview:self.trendTitle];
    }
    
    return self;
}

@end
