//
//  ChatViewController.h
//  Marshmallow
//
//  Created by Brandon Borders on 10/16/15.
//  Copyright © 2015 Cantilevered Marshmallow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DateTools/NSDate+DateTools.h>

#import "FBSDKCoreKit.h"
#import "FBSDKLoginKit.h"

#import "CMRemoteImageView.h"

@interface ChatViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *messageInput;
@property (weak, nonatomic) IBOutlet UIView *chatControls;

@end
