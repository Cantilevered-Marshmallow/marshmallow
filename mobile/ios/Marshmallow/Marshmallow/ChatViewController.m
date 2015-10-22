//
//  ChatViewController.m
//  Marshmallow
//
//  Created by Brandon Borders on 10/16/15.
//  Copyright © 2015 Cantilevered Marshmallow. All rights reserved.
//

#import "ChatViewController.h"

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _messageInput.layer.borderColor = [[UIColor grayColor] CGColor];
    _messageInput.layer.borderWidth = 0.25;
    _messageInput.layer.cornerRadius = 5;
    
    CALayer *upperBorder = [CALayer layer];
    upperBorder.backgroundColor = [[UIColor grayColor] CGColor];
    upperBorder.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 0.5f);
    [_chatControls.layer addSublayer:upperBorder];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"messageCell" forIndexPath:indexPath];
    FBSDKProfile *userProfile = [FBSDKProfile currentProfile];
    
    NSArray *subviews = [cell subviews];
    // Ewww, why so many nested statements?
    // Because the API forced me
    for (UIView *view in subviews) {
        if ([[[view class] description] isEqualToString:@"UITableViewCellContentView"]) {
            for (UIView *subview in [view subviews]) {
                if ([[[subview class] description] isEqualToString:@"UIImageView"]) {
                    // Hah, found you.
                    // Set the image in the cell to be the profile image of the user from facebook
                    [((UIImageView *)subview) hnk_setImageFromURL:[NSURL URLWithString:
                                                                  [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=150&height=150", [userProfile userID]]
                                                                  ]];
                }
                
                if ([[[subview class] description] isEqualToString:@"UILabel"]) {
                    UILabel *label = ((UILabel *)subview);
                    
                    if ([label.text isEqualToString:@"John Appleseed"]) {
                        // Username label
                        
                        label.text = [NSString stringWithFormat:@"%@ %@", [userProfile firstName], [userProfile lastName]];
                    } else if ([[label text] isEqualToString:@"Nov. 14, 2015"]) {
                        // Date text
                        
                        label.text = [[NSDate dateWithTimeIntervalSinceNow:-4] timeAgoSinceNow];
                    }
                }
                
                if ([[[subview class] description] isEqualToString:@"UITextView"]) {
                    UITextView *tv = ((UITextView *) subview);
                    NSArray *messages = @[
                                          @"Hey it's Marsh.",
                                          @"Some very long text. This message has no reason for it's existence other than to annoy you right now. So apparently I need to be even longer than I was before. Hopefully I'm long enough now."
                                        ];
                    
                    tv.text = messages[indexPath.row];
                }
            }
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *messages = @[
                          @"Hey it's Marsh.",
                          @"Some very long text. This message has no reason for it's existence other than to annoy you right now. So apparently I need to be even longer than I was before. Hopefully I'm long enough now."
                          ];
    UITextView *tv = [[UITextView alloc] init];
    tv.text = messages[indexPath.row];
    
    int tvDefaultHeight = 94;
    int differenceInHeight = tvDefaultHeight - [tv contentSize].height;
    if (differenceInHeight > 0) {
        return tvDefaultHeight + differenceInHeight;
    }
    return 110;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

@end
