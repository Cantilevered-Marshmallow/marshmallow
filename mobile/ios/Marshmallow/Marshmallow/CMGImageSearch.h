//
//  CMGImageSearch.h
//  Marshmallow
//
//  Created by Brandon Borders on 10/27/15.
//  Copyright © 2015 Cantilevered Marshmallow. All rights reserved.
//

#import "CMSearchPopup.h"
#import <SFFocusViewLayout/SFFocusViewLayout.h>

@interface CMGImageSearch : CMSearchPopup

@property (nonatomic, strong) UICollectionView *collectionView;

- (id)initWithDelegate:(id<UICollectionViewDelegate>)delegate andDatasource:(id<UICollectionViewDataSource>)datasource;

@end
