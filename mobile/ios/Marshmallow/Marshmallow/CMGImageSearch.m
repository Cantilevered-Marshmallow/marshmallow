//
//  CMGImageSearch.m
//  Marshmallow
//
//  Created by Brandon Borders on 10/27/15.
//  Copyright © 2015 Cantilevered Marshmallow. All rights reserved.
//

#import "CMGImageSearch.h"

@implementation CMGImageSearch

- (id)initWithDelegate:(id<UICollectionViewDelegate>)delegate andDatasource:(id<UICollectionViewDataSource>)datasource {
    self = [super init];
    
    if (self) {
        self.prompt = @"Search Google Images";
        
        SFFocusViewLayout *collectionLayout = [[SFFocusViewLayout alloc] init];
        collectionLayout.standardHeight = 100.f;
        collectionLayout.focusedHeight = 300.f;
        collectionLayout.dragOffset = 150.f;
        self.collectionView = [[UICollectionView alloc] initWithFrame:self.subViewRect collectionViewLayout:collectionLayout];
        self.collectionView.delegate = delegate;
        self.collectionView.dataSource = datasource;
        
        [self.collectionView registerNib:[UINib nibWithNibName:@"GoogleImageCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"googleImageCell"];
        
        self.subview = self.collectionView;
    }
    
    return self;
}

@end
