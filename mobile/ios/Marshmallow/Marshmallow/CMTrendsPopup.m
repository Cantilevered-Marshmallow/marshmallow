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
        self.type = MMPopupTypeAlert;
        
        self.backgroundColor = [UIColor whiteColor];
        
        double width = [UIScreen mainScreen].bounds.size.width - 50;
        
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(500);
        }];
        
        self.btnCancel = [UIButton mm_buttonWithTarget:self action:@selector(actionHide:)];
        [self addSubview:self.btnCancel];
        [self.btnCancel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(80, 50));
            make.left.bottom.equalTo(self);
        }];
        [self.btnCancel setTitle:@"Cancel" forState:UIControlStateNormal];
        [self.btnCancel setTitleColor:[UIColor colorWithRed:0/255.0 green:122/255.0 blue:255/255.0 alpha:255/255.0] forState:UIControlStateNormal];
        
        self.btnConfirm = [UIButton mm_buttonWithTarget:self action:@selector(trendSelected:)];
        [self addSubview:self.btnConfirm];
        [self.btnConfirm mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(80, 50));
            make.right.bottom.equalTo(self);
        }];
        [self.btnConfirm setTitle:@"Attach" forState:UIControlStateNormal];
        [self.btnConfirm setTitleColor:[UIColor colorWithRed:0/255.0 green:122/255.0 blue:255/255.0 alpha:255/255.0] forState:UIControlStateNormal];
        
        self.trendsTable = [[UITableView alloc] init];
        [self addSubview:self.trendsTable];
        [self.trendsTable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake([UIScreen mainScreen].bounds.size.width - 50, 400));
            make.left.equalTo(self);
        }];
    }
    
    return self;
}

- (void)actionHide:(id)sender {
    [super hide];
}

- (void)trendSelected:(id)sender {
    
}

@end
