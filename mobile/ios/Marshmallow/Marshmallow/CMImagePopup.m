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
        // Set the type of the popup
        self.type = MMPopupTypeAlert;
        
        // Set the background color of the popup
        self.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.f];
        
        // Set the constraints for the view
        double screenWidth = [UIScreen mainScreen].bounds.size.width;
        double screenHeight = [UIScreen mainScreen].bounds.size.height;
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(screenWidth);
            make.height.mas_equalTo([UIScreen mainScreen].bounds.size.height);
        }];
        
        // Initialize the image view
        self.iv = [[UIImageView alloc] initWithFrame:CGRectMake((screenWidth / 2) - (screenWidth / 2), (screenHeight / 2) - (screenHeight / 2), screenWidth, screenHeight)];
        self.iv.contentMode = UIViewContentModeScaleAspectFit;
        
        [self addSubview:self.iv];
        
        // Have the window hide when double tapped
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
        recognizer.numberOfTapsRequired = 2;
        [self addGestureRecognizer:recognizer];
        recognizer.delegate = self;
    }
    
    return self;
}

@end
