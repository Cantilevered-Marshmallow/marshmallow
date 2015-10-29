//
//  CMYoutubeSearch.m
//  Marshmallow
//
//  Created by Brandon Borders on 10/28/15.
//  Copyright © 2015 Cantilevered Marshmallow. All rights reserved.
//

#import "CMYoutubeSearch.h"

@implementation CMYoutubeSearch

- (id)init {
    self = [super init];
    
    if (self) {
        self.prompt = @"Search Youtube";
    }
    
    return self;
}

@end
