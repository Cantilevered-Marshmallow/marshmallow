//
//  CMGImageSearch.m
//  Marshmallow
//
//  Created by Brandon Borders on 10/27/15.
//  Copyright © 2015 Cantilevered Marshmallow. All rights reserved.
//

#import "CMGImageSearch.h"

@implementation CMGImageSearch

- (id)init {
    self = [super init];
    
    if (self) {
        self.prompt = @"Search Google Images";
        
        SFFocusViewLayout *collectionLayout = [[SFFocusViewLayout alloc] init];
        collectionLayout.standardHeight = 100.f;
        collectionLayout.focusedHeight = 300.f;
        collectionLayout.dragOffset = 150.f;
        self.collectionView = [[UICollectionView alloc] initWithFrame:self.subViewRect collectionViewLayout:collectionLayout];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        
        [self.collectionView registerNib:[UINib nibWithNibName:@"GoogleImageCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"googleImageCell"];
        
        self.subview = self.collectionView;
        
        self.searchBar.delegate = self;
    }
    
    return self;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    NSString *text = [self.searchBar.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    
    NSLog(@"End");
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        [manager GET:[NSString
                      stringWithFormat:@"https://ajax.googleapis.com/ajax/services/search/images?v=1.0&q=%@&rsz=5", text]
                            parameters:nil
                               success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                                   NSArray *results = responseObject[@"responseData"][@"results"];
                                   
                                   NSMutableArray *urls = [NSMutableArray array];
                                   for (NSDictionary *result in results) {
                                       NSURL *url = [NSURL URLWithString:result[@"url"]];
                                       
                                       [urls addObject:[url absoluteString]];
                                   }
                                   
                                   self.images = [NSArray arrayWithArray:urls];
                                   
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       [self.collectionView reloadData];
                                   });
                               }
                               failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
                                   NSLog(@"%@", error);
                               }];
    });
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
    
    [self searchBarTextDidEndEditing:searchBar];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CMGImageCell *cell = (CMGImageCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"googleImageCell" forIndexPath:indexPath];
    
    UIImageView *iv = (UIImageView *)cell.subviews[0];
    [iv hnk_setImageFromURL:[NSURL URLWithString:self.images[indexPath.row]]];
    
    return cell;
}

@end
