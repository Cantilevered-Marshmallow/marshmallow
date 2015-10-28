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
#import <FontAwesomeKit/FontAwesomeKit.h>

@protocol CMGImageSearchDelegate

@required

- (void)imageSelected:(UIImage *)selectedImage withUrl:(NSString *)url;

@end

@interface CMGImageSearch : CMSearchPopup<UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate, UISearchBarDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSArray<NSString *> *images;

@property (nonatomic, strong) id<CMGImageSearchDelegate> delegate;

@property (nonatomic, weak) CMGImageCell *selectedCell;

- (void)cellSelected:(UITapGestureRecognizer *)sender;

@end