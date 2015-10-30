//
//  CMFormattedTextView.h
//  Marshmallow
//
//  Created by Brandon Borders on 10/30/15.
//  Copyright © 2015 Cantilevered Marshmallow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <NSStringEmojize/NSString+Emojize.h>

@interface CMFormattedTextView : UITextView <UITextViewDelegate>

@property (strong, nonatomic) NSString *formattedText;

@property (strong, nonatomic) NSString *unformattedText;

@end
