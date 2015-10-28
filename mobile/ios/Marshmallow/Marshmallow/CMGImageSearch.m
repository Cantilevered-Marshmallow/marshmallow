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
    [iv hnk_setImageFromURL:[NSURL URLWithString:self.images[indexPath.row]] placeholder:[UIImage imageNamed:@"Icon"]];
    iv.userInteractionEnabled = NO;
    cell.imageUrl = self.images[indexPath.row];
    
    cell.subviews[1].userInteractionEnabled = NO;
    
    cell.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellSelected:)];
    
    [cell addGestureRecognizer:tapGesture];
    
    tapGesture.delegate = self;
    
    return cell;
}

- (void)cellSelected:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        CMGImageCell *cell = ((CMGImageCell *) sender.view);
        
        if (self.selectedCell) {
            ((UIImageView *)self.selectedCell.subviews[1]).image = nil;
        }
        
        self.selectedCell = cell;
        
        NSError *error;
        UIImage *checkbox = [[FAKIonIcons iconWithIdentifier:@"ion-ios-checkmark-outline" size:50 error:&error] imageWithSize:CGSizeMake(50, 50)];
        checkbox = [checkbox imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        UIImageView *accessory = (UIImageView *)cell.subviews[1];
        accessory.image = checkbox;
    }
}

- (void)attachSelected:(id)sender {
    [self.delegate imageSelected:((UIImageView *)self.selectedCell.subviews[0]).image withUrl:self.selectedCell.imageUrl];
    
    [super attachSelected:sender];
}

@end
