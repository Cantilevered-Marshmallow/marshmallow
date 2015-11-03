//
//  CMTrendCell.h
//  Marshmallow
//
//  Created by Brandon Borders on 11/2/15.
//  Copyright © 2015 Cantilevered Marshmallow. All rights reserved.
//

#import <UIKit/UIKit.h>

@import SafariServices;

@protocol CMOpenUrl

@required

- (void)showViewController:(SFSafariViewController *)controller;

@end

@interface CMTrendCell : UITableViewCell

@property (nonatomic, strong) UIImageView *thumbnail;
@property (nonatomic, strong) UILabel *trendTitle;

@property (nonatomic, strong) NSString *url;

@property (nonatomic, strong) id<CMOpenUrl, SFSafariViewControllerDelegate> delegate;

- (void)cellTapped:(UITapGestureRecognizer *)sender;

@end
