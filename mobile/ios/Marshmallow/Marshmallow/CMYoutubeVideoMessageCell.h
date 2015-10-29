//
//  CMYoutubeVideoMessageCell.h
//  Marshmallow
//
//  Created by Brandon Borders on 10/29/15.
//  Copyright © 2015 Cantilevered Marshmallow. All rights reserved.
//

#import "CMMessageCell.h"

@interface CMYoutubeVideoMessageCell : CMMessageCell

@property (strong, nonatomic) UIImageView *thumbnail;

@property (strong, nonatomic) UILabel *title;

@property (strong, nonatomic) UILabel *channel;

@end
