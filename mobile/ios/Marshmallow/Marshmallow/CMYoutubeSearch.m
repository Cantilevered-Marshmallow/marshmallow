//
//  CMYoutubeSearch.m
//  Marshmallow
//
//  Created by Brandon Borders on 10/28/15.
//  Copyright © 2015 Cantilevered Marshmallow. All rights reserved.
//

#import "CMYoutubeSearch.h"

@implementation CMYoutubeSearchResult

@end

@implementation CMYoutubeSearch

- (id)init {
    self = [super init];
    
    if (self) {
        self.prompt = @"Search Youtube";
        
        self.resultsTable = [[UITableView alloc] initWithFrame:self.subViewRect];
        
        self.subview = self.resultsTable;
        
        self.searchBar.delegate = self;
    }
    
    return self;
}

@end
