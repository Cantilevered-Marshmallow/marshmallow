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
    
    [self.messageInput becomeFirstResponder];
    
    [self.navigationItem setTitle:self.chat.chatTitle];
    
    self.messages = [NSMutableArray arrayWithArray:[Message MR_findAllInContext:[NSManagedObjectContext MR_defaultContext]]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"messageCell" forIndexPath:indexPath];
    Message *message = self.messages[indexPath.row];
    
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
                                                                  [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=150&height=150", message.userId]
                                                                  ]];
                }
                
                if ([[[subview class] description] isEqualToString:@"UILabel"]) {
                    UILabel *label = ((UILabel *)subview);
                    
                    if ([label.text isEqualToString:@"John Appleseed"]) {
                        // Username label
                        
                        label.text = [NSString stringWithFormat:@"%@", message.user.name];
                    } else if ([[label text] isEqualToString:@"Nov. 14, 2015"]) {
                        // Date text
                        
                        label.text = [message.timestamp timeAgoSinceNow];
                    }
                }
                
                if ([[[subview class] description] isEqualToString:@"UITextView"]) {
                    UITextView *tv = ((UITextView *) subview);
                    
                    tv.text = message.body;
                }
            }
        }
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messages.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Message *message = self.messages[indexPath.row];
    UITextView *tv = [[UITextView alloc] init];
    tv.text = message.body;
    
    int tvDefaultHeight = 94;
    int differenceInHeight = tvDefaultHeight - [tv contentSize].height;
    if (differenceInHeight > 0) {
        return tvDefaultHeight + differenceInHeight;
    }
    return 110;
}

@end
