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
    
    _request = [[CMNetworkRequest alloc] init];
    
    CALayer *upperBorder = [CALayer layer];
    upperBorder.backgroundColor = [[UIColor grayColor] CGColor];
    upperBorder.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 0.5f);
    [_chatControls.layer addSublayer:upperBorder];
    
    [self.messageInput becomeFirstResponder];
    
    [self.navigationItem setTitle:self.chat.chatTitle];
    
    self.messages = [NSMutableArray arrayWithArray:[Message MR_findAllSortedBy:@"timestamp:YES" ascending:YES withPredicate:[NSPredicate predicateWithFormat:@"chatsId == %@", self.chat.chatId] inContext:[NSManagedObjectContext MR_defaultContext]]];
    
    self.fetchMessagesTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(fetchMessages:) userInfo:nil repeats:YES];
    
    [self.tableView registerClass:[CMMessageCell class] forCellReuseIdentifier:@"messageCell"];
    [self.tableView registerClass:[CMGImageMessageCell class] forCellReuseIdentifier:@"gImageMessageCell"];
    
    [self.sendMessageButton addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
    [self.attachmentButton addTarget:self action:@selector(showAttachments:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (!self.fetchMessagesTimer) {
        self.fetchMessagesTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(fetchMessages:) userInfo:nil repeats:true];
    }
    
    // Scroll to bottom of messages table
    if (self.messages.count > 0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:self.messages.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.fetchMessagesTimer invalidate];
    self.fetchMessagesTimer = nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Message *message = self.messages[indexPath.row];
    
    if ([message.googleImageId isEqualToString:@""]) {
        CMMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"messageCell" forIndexPath:indexPath];
        
        [cell.userImage hnk_setImageFromURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=150&height=150", message.userId]]];
                    
        if (![message.userId isEqualToString:[[FBSDKAccessToken currentAccessToken] userID]]) {
            Contact *contact = [Contact MR_findFirstByAttribute:@"contactId" withValue:message.userId inContext:[NSManagedObjectContext MR_defaultContext]];
            cell.userName.text = contact.name;
        } else {
            cell.userName.text = @"From You";
        }
        cell.timestamp.text = [message.timestamp timeAgoSinceNow];
                    
        cell.messageBody.text = message.body;
        
        if (cell.messageBody.contentSize.height > cell.messageBody.frame.size.height) {
            cell.messageBody.frame = CGRectMake(cell.messageBody.frame.origin.x, cell.messageBody.frame.origin.y, cell.messageBody.frame.size.width, cell.messageBody.contentSize.height);
        }
        
        return cell;
    } else {
        CMGImageMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"gImageMessageCell" forIndexPath:indexPath];
        
        [cell.userImage hnk_setImageFromURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=150&height=150", message.userId]]];
        
        if (![message.userId isEqualToString:[[FBSDKAccessToken currentAccessToken] userID]]) {
            Contact *contact = [Contact MR_findFirstByAttribute:@"contactId" withValue:message.userId inContext:[NSManagedObjectContext MR_defaultContext]];
            cell.userName.text = contact.name;
        } else {
            cell.userName.text = @"From You";
        }
        cell.timestamp.text = [message.timestamp timeAgoSinceNow];
        
        cell.messageBody.text = message.body;
        
        if (cell.messageBody.contentSize.height > cell.messageBody.frame.size.height) {
            cell.messageBody.frame = CGRectMake(cell.messageBody.frame.origin.x, cell.messageBody.frame.origin.y, cell.messageBody.frame.size.width, cell.messageBody.contentSize.height);
        }
        
        [cell.googleImage hnk_setImageFromURL:[NSURL URLWithString:message.googleImageId]];
        
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messages.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Message *message = self.messages[indexPath.row];
    UITextView *tv = [[UITextView alloc] initWithFrame:CGRectMake(25, 60, 200, 60)];
    tv.text = message.body;
    
    int cellDefaultHeight = 110;
    
    if (tv.contentSize.height > tv.frame.size.height) {
        if ([message.googleImageId isEqualToString:@""]) {
            return cellDefaultHeight + tv.contentSize.height;
        } else {
            return cellDefaultHeight + tv.contentSize.height + 240;
        }
    } else {
        if ([message.googleImageId isEqualToString:@""]) {
            return cellDefaultHeight;
        } else {
            return cellDefaultHeight + 240;
        }
    }
}

- (void)fetchMessages:(id)sender {
    [self.request requestWithHttpVerb:@"GET" url:[NSString stringWithFormat:@"/chat/%@", self.chat.chatId] data:nil jwt:self.user.jwt response:^(NSError *error, NSDictionary *response) {
        if (!error) {
            NSArray *fetchedMessages = response[@"messages"];
            
            for (NSDictionary *fetchedMessage in fetchedMessages) {
                if (![Message MR_findFirstByAttribute:@"timestamp" withValue:[NSDate dateWithISO8601String:fetchedMessage[@"createdAt"]] inContext:[NSManagedObjectContext MR_defaultContext]]) {
                    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
                        Message *message = [Message MR_createEntityInContext:localContext];
                        message.body = fetchedMessage[@"text"];
                        
                        if (fetchedMessage[@"youtubeVideoId"] != (id)[NSNull null]) {
                            message.youtubeVideoId = fetchedMessage[@"youtubeVideoId"];
                        } else {
                            message.youtubeVideoId = @"";
                        }
                        
                        if (fetchedMessage[@"googleImageId"] != (id)[NSNull null]) {
                            message.googleImageId = fetchedMessage[@"googleImageId"];
                        } else {
                            message.googleImageId = @"";
                        }
                        message.chatsId = [fetchedMessage[@"chatId"] stringValue];
                        message.userId = fetchedMessage[@"userFacebookId"];
                        message.timestamp = [NSDate dateWithISO8601String:fetchedMessage[@"createdAt"]];
                    } completion:^(BOOL contextDidSave, NSError *error) {
                        if (contextDidSave) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                self.messages = [NSMutableArray arrayWithArray:[Message MR_findAllSortedBy:@"timestamp:YES" ascending:YES withPredicate:[NSPredicate predicateWithFormat:@"chatsId == %@", self.chat.chatId] inContext:[NSManagedObjectContext MR_defaultContext]]];
                                
                                [self.tableView reloadData];
                            });
                        }
                    }];
                }
            }
        }
    }];
}

- (void)sendMessage:(id)sender {
    if (![self.messageInput.text isEqualToString:@"Enter your message here"]) {
        if (self.gImageResult != nil) {
            [self.request requestWithHttpVerb:@"POST" url:[NSString stringWithFormat:@"/chat/%@", self.chat.chatId] data:@{@"text": self.messageInput.text, @"youtubeVideoId": @"", @"googleImageId": self.gImageResult.url} jwt:self.user.jwt response:^(NSError *error, NSDictionary *response) {
                if (!error) {
                    UIImageView *iv = ((UIImageView *)self.view.subviews[1].subviews[0]);
                    iv.image = nil;
                    self.gImageResult = nil;
                    
                    self.view.subviews[1].userInteractionEnabled = NO;
                    iv.userInteractionEnabled = NO;
                    
                    self.messageInput.text = @"Enter your message here";
                    [self fetchMessages:self];
                }
            }];
        } else {
            [self.request requestWithHttpVerb:@"POST" url:[NSString stringWithFormat:@"/chat/%@", self.chat.chatId] data:@{@"text": self.messageInput.text, @"youtubeVideoId": @"", @"googleImageId": @""} jwt:self.user.jwt response:^(NSError *error, NSDictionary *response) {
                if (!error) {
                    self.messageInput.text = @"Enter your message here";
                    [self fetchMessages:self];
                }
            }];
        }
    }
}

- (void)showAttachments:(id)sender {
    CMGImageSearch *pop = [[CMGImageSearch alloc] init];
    pop.delegate = self;
    [pop show];
}

- (void)imageSelected:(CMGImageResult *)result {
    UIImageView *iv = ((UIImageView *)self.view.subviews[1].subviews[0]);
    iv.image = result.image;

    
    self.view.subviews[1].userInteractionEnabled = YES;
    iv.userInteractionEnabled = YES;
    
    self.gImageResult = result;
}

@end
