//
//  CMTrendCell.m
//  Marshmallow
//
//  Created by Brandon Borders on 11/2/15.
//  Copyright © 2015 Cantilevered Marshmallow. All rights reserved.
//

#import "CMTrendCell.h"

@implementation CMTrendCell

- (id)init {
    self = [super init];
    
    if (self) {
        self.thumbnail = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 100, 50)];
        
        self.title = [[UILabel alloc] initWithFrame:CGRectMake(120, 30, 100, 20)];
        self.title.font = [UIFont fontWithName:self.title.font.fontName size:20];
        
        [self addSubview:self.thumbnail];
        [self addSubview:self.title];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
