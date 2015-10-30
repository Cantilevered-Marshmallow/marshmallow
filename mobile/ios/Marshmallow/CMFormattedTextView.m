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
    self.formattedText = [self.text emojizedString];
    
    if (![self.formattedText isEqualToString:self.text]) {
        self.unformattedText = self.text;
        self.text = self.formattedText;
    } else {
        self.unformattedText = self.text;
    }
}

@end
