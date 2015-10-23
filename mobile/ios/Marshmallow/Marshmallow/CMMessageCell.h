//
//  CMMessageCell.h
//  Marshmallow
//
//  Created by Brandon Borders on 10/23/15.
//  Copyright © 2015 Cantilevered Marshmallow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMMessageCell : UITableViewCell

@property (strong, nonatomic) UIImageView *userImage;
@property (strong, nonatomic) UILabel *userName;
@property (strong, nonatomic) UILabel *timestamp;
@property (strong, nonatomic) UITextView *messageBody;

@end
