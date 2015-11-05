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
        // Set the prompt of the search bar
        self.prompt = @"Search Youtube";
        
        // Initialize data
        self.results = [NSMutableArray array];
        
        // Intiialize table view
        self.resultsTable = [[UITableView alloc] initWithFrame:self.subViewRect];
        self.resultsTable.delegate = self;
        self.resultsTable.dataSource = self;
        
        [self.resultsTable registerClass:[CMYoutubeCell class] forCellReuseIdentifier:@"youtubeResultCell"];
        
        self.subview = self.resultsTable;
        
        // Assign delegate of search bar
        self.searchBar.delegate = self;
        
        // Find the API key for youtube
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
    [cell.highThumbnail hnk_setImageFromURL:[NSURL URLWithString:snippet[@"thumbnails"][@"high"][@"url"]]];
    
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
        
        if (self.selectedCell != nil) { // Deselect the previously selected cell
            [self.selectedCell setSelected:NO];
        }
        
        // Select the cell
        [cell setSelected:YES];
        self.selectedCell = cell;
    }
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    NSString *text = [self.searchBar.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        // Query the Youtube API
        [manager GET:[NSString stringWithFormat:@"https://www.googleapis.com/youtube/v3/search?part=snippet&type=video&key=%@&q=%@", self.apiKey, text]
          parameters:nil
             success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     NSArray *results = responseObject[@"items"];
                     
                     if (self.results.count > 0) { // Did we already have some results?
                         [self.results removeAllObjects];
                     }
                     
                     // Parse the response
                     for (NSDictionary *item in results) {
                         NSDictionary *snippet = item[@"snippet"];
                         NSString *videoId = item[@"id"][@"videoId"];
                         
                         [self.results addObject:@{@"id": videoId, @"snippet": snippet}];
                     }
                     
                     // Reload the data
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

- (void)attachSelected:(id)sender {
    if (self.selectedCell != nil) {
        // Prepare the result
        CMYoutubeSearchResult *result = [[CMYoutubeSearchResult alloc] init];
        result.title = self.selectedCell.title.text;
        result.channel = self.selectedCell.channel.text;
        result.thumbnail = self.selectedCell.thumbnail.image;
        result.highThumbnail = self.selectedCell.highThumbnail.image;
        
        NSDictionary *video = self.results[[self.resultsTable indexPathForCell:self.selectedCell].row];
        result.videoId = video[@"id"];
        
        // Send the result to the delegate
        [self.delegate videoSelected:result];
        
        // Invoke super
        [super attachSelected:sender];
    }
}

@end
