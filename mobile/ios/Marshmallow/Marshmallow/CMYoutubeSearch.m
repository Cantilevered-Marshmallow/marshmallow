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
        
        self.results = [NSMutableArray array];
        
        self.resultsTable = [[UITableView alloc] initWithFrame:self.subViewRect];
        self.resultsTable.delegate = self;
        self.resultsTable.dataSource = self;
        
        [self.resultsTable registerClass:[CMYoutubeCell class] forCellReuseIdentifier:@"youtubeResultCell"];
        
        self.subview = self.resultsTable;
        
        self.searchBar.delegate = self;
        
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"keys" ofType:@"plist"];
        self.apiKey = [NSDictionary dictionaryWithContentsOfFile:plistPath][@"YOUTUBE_KEY"];
    }
    
    return self;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CMYoutubeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"youtubeResultCell"];
    
    NSDictionary *video = self.results[indexPath.row];
    NSDictionary *snippet = video[@"snippet"];
    
    [cell.thumbnail hnk_setImageFromURL:[NSURL URLWithString:snippet[@"thumbnails"][@"medium"][@"url"]]];
    
    cell.title.text = snippet[@"title"];
    
    cell.channel.text = snippet[@"channelTitle"];
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellSelected:)];
    
    [cell addGestureRecognizer:recognizer];
    
    recognizer.delegate = self;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.results.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110;
}

- (void)cellSelected:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        CMYoutubeCell *cell = ((CMYoutubeCell *) sender.view);
        
        if (self.selectedCell != nil) {
            [self.selectedCell setSelected:NO];
        }
        
        [cell setSelected:YES];
        self.selectedCell = cell;
    }
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    NSString *text = [self.searchBar.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        [manager GET:[NSString stringWithFormat:@"https://www.googleapis.com/youtube/v3/search?part=snippet&type=video&key=%@&q=%@", self.apiKey, text]
          parameters:nil
             success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     NSArray *results = responseObject[@"items"];
                     
                     for (NSDictionary *item in results) {
                         NSDictionary *snippet = item[@"snippet"];
                         NSString *videoId = item[@"id"][@"videoId"];
                         
                         [self.results addObject:@{@"id": videoId, @"snippet": snippet}];
                     }
                     
                     [self.resultsTable reloadData];
                 });
             }
         
             failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
            
             }];
    });
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
}

@end
