//
//  CMImagePopup.h
//  Marshmallow
//
//  Created by Brandon Borders on 10/30/15.
//  Copyright © 2015 Cantilevered Marshmallow. All rights reserved.
//

#import <MMPopupView/MMPopupView.h>
#import <Masonry/Masonry.h>

@interface CMImagePopup : MMPopupView <UIGestureRecognizerDelegate>

@property (strong, nonatomic) UIImageView *iv;

@end
