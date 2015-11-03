//
//  CMTrendMessageCell.h
//  Marshmallow
//
//  Created by Brandon Borders on 11/3/15.
//  Copyright © 2015 Cantilevered Marshmallow. All rights reserved.
//

#import "CMMessageCell.h"

#import "CMTrendsPopup.h"

@interface CMTrendMessageCell : CMMessageCell

@property (nonatomic, strong) UIImageView *thumbnail;
@property (nonatomic, strong) UILabel *trendTitle;

@property (nonatomic, strong) NSString *url;

@property (nonatomic, strong) UIViewController<CMTrendsDelegate> *delegate;

- (void)cellTapped:(id)sender;

@end
