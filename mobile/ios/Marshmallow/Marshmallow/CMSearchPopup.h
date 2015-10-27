//
//  SearchPopup.h
//  Marshmallow
//
//  Created by Brandon Borders on 10/27/15.
//  Copyright © 2015 Cantilevered Marshmallow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MMPopupView/MMPopupView.h>
#import "MMPopupDefine.h"
#import "MMPopupCategory.h"
#import <Masonry/Masonry.h>

@interface CMSearchPopup : MMPopupView

@property (nonatomic, strong) UISearchBar *searchBar;

@property (nonatomic, strong) UIButton *btnCancel;
@property (nonatomic, strong) UIButton *btnConfirm;

@property (nonatomic, strong) UIView *subview;

@property (nonatomic, weak) NSString *prompt;

- (void)actionHide:(id)sender;

@end
