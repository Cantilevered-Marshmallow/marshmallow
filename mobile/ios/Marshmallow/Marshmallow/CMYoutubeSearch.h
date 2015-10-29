//
//  CMYoutubeSearch.h
//  Marshmallow
//
//  Created by Brandon Borders on 10/28/15.
//  Copyright © 2015 Cantilevered Marshmallow. All rights reserved.
//

#import "CMSearchPopup.h"

@interface CMYoutubeSearchResult : NSObject

@property (strong, nonatomic) UIImage *thumbnail;

@property (strong, nonatomic) NSString *title;

@property (strong, nonatomic) NSString *length;

@property (strong, nonatomic) NSString *channel;

@end

@protocol CMYoutubeSearchDelegate

@required

- (void)videoSelected:(CMYoutubeSearchResult *)result;

@end

@interface CMYoutubeSearch : CMSearchPopup <UISearchBarDelegate>

@property (strong, nonatomic) UITableView *resultsTable;

@property (strong, nonatomic) id<CMYoutubeSearchDelegate> delegate;

@end
