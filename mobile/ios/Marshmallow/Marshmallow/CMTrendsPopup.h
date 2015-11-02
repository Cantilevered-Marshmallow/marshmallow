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

@interface CMTrendsPopup : MMPopupView

@property (nonatomic, strong) UIButton *btnCancel;
@property (nonatomic, strong) UIButton *btnConfirm;

@property (nonatomic, strong) UITableView *trendsTable;

- (void)actionHide:(id)sender;
- (void)trendSelected:(id)sender;

@end
