//
//  ChatViewController.h
//  Marshmallow
//
//  Created by Brandon Borders on 10/16/15.
//  Copyright © 2015 Cantilevered Marshmallow. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FBSDKLoginKit.h"

@interface ChatViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *messageInput;
@property (weak, nonatomic) IBOutlet UIView *chatControls;

- (void)logout:(id)sender;

@end
