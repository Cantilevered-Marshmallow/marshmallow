//
//  CMTrendsPopup.m
//  Marshmallow
//
//  Created by Brandon Borders on 11/2/15.
//  Copyright © 2015 Cantilevered Marshmallow. All rights reserved.
//

#import "CMTrendsPopup.h"

@implementation CMTrendsPopup

- (instancetype)init {
    self = [super init];
    
    if (self) {
        // Set the type of the popup
        self.type = MMPopupTypeAlert;
        
        // Sert the background color of the popup
        self.backgroundColor = [UIColor whiteColor];
        
        // Set the constraints of the view
        double width = [UIScreen mainScreen].bounds.size.width - 50;
        
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(500);
        }];
        
        // Add a cancel button
        self.btnCancel = [UIButton mm_buttonWithTarget:self action:@selector(actionHide:)];
        [self addSubview:self.btnCancel];
        [self.btnCancel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(80, 50));
            make.left.bottom.equalTo(self);
        }];
        [self.btnCancel setTitle:@"Cancel" forState:UIControlStateNormal];
        [self.btnCancel setTitleColor:[UIColor colorWithRed:0/255.0 green:122/255.0 blue:255/255.0 alpha:255/255.0] forState:UIControlStateNormal];
        
        // Add a confirm button
        self.btnConfirm = [UIButton mm_buttonWithTarget:self action:@selector(trendSelected:)];
        [self addSubview:self.btnConfirm];
        [self.btnConfirm mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(80, 50));
            make.right.bottom.equalTo(self);
        }];
        [self.btnConfirm setTitle:@"Attach" forState:UIControlStateNormal];
        [self.btnConfirm setTitleColor:[UIColor colorWithRed:0/255.0 green:122/255.0 blue:255/255.0 alpha:255/255.0] forState:UIControlStateNormal];
        
        // Add the table view
        self.trendsTable = [[UITableView alloc] init];
        self.trendsTable.dataSource = self;
        self.trendsTable.delegate = self;
        
        [self.trendsTable registerClass:[CMTrendCell class] forCellReuseIdentifier:@"trendCell"];
        
        [self addSubview:self.trendsTable];
        [self.trendsTable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake([UIScreen mainScreen].bounds.size.width - 50, 400));
            make.left.equalTo(self);
            make.top.mas_equalTo(0);
        }];
    }
    
    return self;
}

// Preferred initializer
- (CMTrendsPopup *)initWithJwt:(NSString *)jwt {
    self = [self init];
    
    if (self) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            CMNetworkRequest *request = [[CMNetworkRequest alloc] init];
            
            // Fetch the trends
            [request requestWithHttpVerb:@"GET" url:@"/trends" data:@{} jwt:jwt response:^(NSError *error, NSDictionary *response) {
                if (!error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.trends = [NSArray arrayWithArray:response[@"links"]];
                        
                        [self.trendsTable reloadData];
                    });
                }
            }];
        });
    }
    
    return self;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CMTrendCell *cell = [self.trendsTable dequeueReusableCellWithIdentifier:@"trendCell"];
    NSDictionary *trend = self.trends[indexPath.row];
    
    if ([((NSString *)trend[@"thumbnail"]) hasPrefix:@"http://"] || [((NSString *)trend[@"thumbnail"]) hasPrefix:@"https://"]) {
        [cell.thumbnail hnk_setImageFromURL:[NSURL URLWithString:trend[@"thumbnail"]] placeholder:[UIImage imageNamed:@"Icon"]];
    }
    cell.trendTitle.text = trend[@"title"];
    
    cell.url = trend[@"url"];
    
    cell.delegate = self;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.trends.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 170;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CMTrendCell *cell = [self.trendsTable cellForRowAtIndexPath:indexPath];
    
    if (self.selectedTrend != nil) { // Deselect the previously selected trend
        self.selectedTrend.accessoryView = nil;
    }
    
    if (cell.accessoryView == nil) {
        // Add a checkmark to the cell
        NSError *error;
        UIImage *checkbox = [[FAKIonIcons iconWithIdentifier:@"ion-ios-checkmark-outline" size:50 error:&error] imageWithSize:CGSizeMake(50, 50)];
        checkbox = [checkbox imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        UIImageView *iv = [[UIImageView alloc] initWithImage:checkbox];
        [iv setTintColor:[UIColor colorFromHexString:@"#006400"]];
        cell.accessoryView = iv;
        self.selectedTrend = cell;
    } else {
        cell.accessoryView = nil;
    }
}

- (void)actionHide:(id)sender {
    [super hide];
}

- (void)showViewController:(SFSafariViewController *)controller {
    [super hide];
    // Have the delegate display the web view
    [self.delegate displayTrend:controller];
}

- (void)safariViewControllerDidFinish:(SFSafariViewController *)controller {
    [super show];
}

- (void)trendSelected:(id)sender {
    // Send the selected trend to the delegate
    [self.delegate trendSelected:self.trends[[self.trendsTable indexPathForCell:self.selectedTrend].row]];
    
    [super hide];
}

@end
