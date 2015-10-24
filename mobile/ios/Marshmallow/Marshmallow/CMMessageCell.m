//
//  CMMessageCell.m
//  Marshmallow
//
//  Created by Brandon Borders on 10/23/15.
//  Copyright © 2015 Cantilevered Marshmallow. All rights reserved.
//

#import "CMMessageCell.h"

@implementation CMMessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        // Setup user image
        self.userImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 5, 50, 50)];
        
        // Setup user name label
        self.userName = [[UILabel alloc] initWithFrame:CGRectMake(85, 5, 140, 20)];
        
        [self.userName setTextColor:[UIColor darkGrayColor]];
        [self.userName setFont:[UIFont systemFontOfSize:14]];
        
        // Setup timestamp label
        self.timestamp = [[UILabel alloc] initWithFrame:CGRectMake(85, 25, 140, 20)];
        
        [self.timestamp setTextColor:[UIColor darkGrayColor]];
        [self.timestamp setFont:[UIFont systemFontOfSize:12]];
        
        // Setup message text view
        self.messageBody = [[UITextView alloc] initWithFrame:CGRectMake(25, 60, 200, 60)];
        
        [self.messageBody setEditable:NO];
        
        // Add subviews
        [self.contentView addSubview:self.userImage];
        [self.contentView addSubview:self.userName];
        [self.contentView addSubview:self.timestamp];
        [self.contentView addSubview:self.messageBody];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return self;
}

@end
