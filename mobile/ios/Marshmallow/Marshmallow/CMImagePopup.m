//
//  CMImagePopup.m
//  Marshmallow
//
//  Created by Brandon Borders on 10/30/15.
//  Copyright © 2015 Cantilevered Marshmallow. All rights reserved.
//

#import "CMImagePopup.h"

@implementation CMImagePopup

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.type = MMPopupTypeAlert;
        
        self.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.f];
        
        double screenWidth = [UIScreen mainScreen].bounds.size.width;
        double screenHeight = [UIScreen mainScreen].bounds.size.height;
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(screenWidth);
            make.height.mas_equalTo([UIScreen mainScreen].bounds.size.height);
        }];
        
        self.iv = [[UIImageView alloc] initWithFrame:CGRectMake((screenWidth / 2) - (screenWidth / 2), (screenHeight / 2) - (screenHeight / 2), screenWidth, screenHeight)];
        self.iv.contentMode = UIViewContentModeScaleAspectFit;
        
        [self addSubview:self.iv];
        
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
        recognizer.numberOfTapsRequired = 2;
        [self addGestureRecognizer:recognizer];
        recognizer.delegate = self;
    }
    
    return self;
}

@end
