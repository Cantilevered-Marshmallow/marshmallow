//
//  SearchPopup.m
//  Marshmallow
//
//  Created by Brandon Borders on 10/27/15.
//  Copyright © 2015 Cantilevered Marshmallow. All rights reserved.
//

#import "CMSearchPopup.h"

@implementation CMSearchPopup

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
        
        self.btnConfirm = [UIButton mm_buttonWithTarget:self action:@selector(attachSelected:)];
        [self addSubview:self.btnConfirm];
        [self.btnConfirm mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(80, 50));
            make.right.bottom.equalTo(self);
        }];
        [self.btnConfirm setTitle:@"Attach" forState:UIControlStateNormal];
        [self.btnConfirm setTitleColor:[UIColor colorWithRed:0/255.0 green:122/255.0 blue:255/255.0 alpha:255/255.0] forState:UIControlStateNormal];
        
        self.searchBar = [[UISearchBar alloc] init];
        [self addSubview:self.searchBar];
        [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(width, 50));
            make.left.top.equalTo(self);
        }];
    }
    
    return self;
}

- (void)actionHide:(id)sender {
    [self hide];
}

- (void)attachSelected:(id)sender {
    [self hide];
    
    // Subviews should override this
}

- (void)setPrompt:(NSString *)prompt {
    self.searchBar.placeholder = prompt;
}

- (void)setSubview:(UIView *)subview {
    if (self.subview != nil) {
        [self.subview removeFromSuperview];
    }
    
    _subview = subview;
    
    [self addSubview:subview];
    [self.subview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake([UIScreen mainScreen].bounds.size.width - 50, 400));
        make.left.equalTo(self);
        make.top.mas_equalTo(50);
    }];
    
    self.subViewRect = self.subview.frame;
}

@end
