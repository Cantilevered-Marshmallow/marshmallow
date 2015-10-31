//
//  CMFormattedTextView.m
//  Marshmallow
//
//  Created by Brandon Borders on 10/30/15.
//  Copyright © 2015 Cantilevered Marshmallow. All rights reserved.
//

#import "CMFormattedTextView.h"

@implementation CMFormattedTextView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.delegate = self;
}

- (void)textViewDidChange:(UITextView *)textView {
    self.text = [ZWEmoji emojify:self.text];
}

@end
