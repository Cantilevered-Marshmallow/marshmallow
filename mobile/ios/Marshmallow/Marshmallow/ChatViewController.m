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
    
    self.messages = [NSMutableArray arrayWithArray:[Message MR_findAllInContext:[NSManagedObjectContext MR_defaultContext]]];
    
    self.fetchMessagesTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(fetchMessages:) userInfo:nil repeats:YES];
    
    [self.tableView registerClass:[CMMessageCell class] forCellReuseIdentifier:@"messageCell"];
    
    [self.sendMessageButton addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
    [self.attachmentButton addTarget:self action:@selector(showAttachments:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (!self.fetchMessagesTimer) {
        self.fetchMessagesTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(fetchMessages:) userInfo:nil repeats:true];
    }
    
    // Scroll to bottom of messages table
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:self.messages.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.fetchMessagesTimer invalidate];
    self.fetchMessagesTimer = nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CMMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"messageCell" forIndexPath:indexPath];
    Message *message = self.messages[indexPath.row];
    
    [cell.userImage hnk_setImageFromURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=150&height=150", message.userId]]];
                
    if (![message.userId isEqualToString:[[FBSDKAccessToken currentAccessToken] userID]]) {
        Contact *contact = [Contact MR_findFirstByAttribute:@"contactId" withValue:message.userId inContext:[NSManagedObjectContext MR_defaultContext]];
        cell.userName.text = contact.name;
    } else {
        cell.userName.text = @"From You";
    }
    cell.timestamp.text = [message.timestamp timeAgoSinceNow];
                
    cell.messageBody.text = message.body;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messages.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Message *message = self.messages[indexPath.row];
    UITextView *tv = [[UITextView alloc] init];
    tv.text = message.body;
    
    int tvDefaultHeight = 60;
    int differenceInHeight = tvDefaultHeight - [tv contentSize].height;
    if (differenceInHeight > 0) {
        return tvDefaultHeight + differenceInHeight;
    }
    return 110;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CMGImageCell *cell = (CMGImageCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"googleImageCell" forIndexPath:indexPath];
    
    UIImageView *iv = (UIImageView *)cell.subviews[0];
    NSArray<NSString *> *urls = @[@"https://s-media-cache-ak0.pinimg.com/236x/b8/ca/44/b8ca4427b00141b9d461068770490a65.jpg", @"https://s-media-cache-ak0.pinimg.com/736x/f0/1d/8a/f01d8a9f362bdf1bc15a7ac9cb6b5a45.jpg", @"https://c1.staticflickr.com/1/38/91607831_009166aa41.jpg", @"https://apanache.files.wordpress.com/2015/06/baby-monkey1.jpg"];
    [iv hnk_setImageFromURL:[NSURL URLWithString:urls[indexPath.row]]];
    
    return cell;
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
                                self.messages = [NSMutableArray arrayWithArray:[Message MR_findAllInContext:[NSManagedObjectContext MR_defaultContext]]];
                                
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
        [self.request requestWithHttpVerb:@"POST" url:[NSString stringWithFormat:@"/chat/%@", self.chat.chatId] data:@{@"text": self.messageInput.text, @"youtubeVideoId": @"", @"googleImageId": @""} jwt:self.user.jwt response:^(NSError *error, NSDictionary *response) {
            if (!error) {
                self.messageInput.text = @"Enter your message here";
                [self fetchMessages:self];
            }
        }];
    }
}

- (void)showAttachments:(id)sender {
    CMGImageSearch *pop = [[CMGImageSearch alloc] initWithDelegate:self andDatasource:self];
    [pop show];
}

@end
