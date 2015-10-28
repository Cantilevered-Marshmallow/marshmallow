//
//  CMGImageSearch.h
//  Marshmallow
//
//  Created by Brandon Borders on 10/27/15.
//  Copyright © 2015 Cantilevered Marshmallow. All rights reserved.
//

#import "CMSearchPopup.h"
#import "CMGImageCell.h"
#import <SFFocusViewLayout/SFFocusViewLayout.h>
#import <Haneke/Haneke.h>
#import <AFNetworking/AFNetworking.h>

@interface CMGImageSearch : CMSearchPopup<UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSArray<NSString *> *images;

@end
