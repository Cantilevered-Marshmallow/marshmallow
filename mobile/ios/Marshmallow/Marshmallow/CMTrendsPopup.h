//
//  CMTrendsPopup.h
//  Marshmallow
//
//  Created by Brandon Borders on 11/2/15.
//  Copyright © 2015 Cantilevered Marshmallow. All rights reserved.
//

#import <MMPopupView/MMPopupView.h>
#import "MMPopupDefine.h"
#import "MMPopupCategory.h"
#import <Masonry/Masonry.h>
#import <Haneke/Haneke.h>

#import "CMNetworkRequest.h"
#import "CMTrendCell.h"

@interface CMTrendsPopup : MMPopupView <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIButton *btnCancel;
@property (nonatomic, strong) UIButton *btnConfirm;

@property (nonatomic, strong) UITableView *trendsTable;

@property (nonatomic, strong) NSArray *trends;

- (CMTrendsPopup *)initWithJwt:(NSString *)jwt;

- (void)actionHide:(id)sender;
- (void)trendSelected:(id)sender;

@end