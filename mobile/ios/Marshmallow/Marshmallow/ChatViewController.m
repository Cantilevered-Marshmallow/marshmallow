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
    [self.tableView registerClass:[CMYoutubeVideoMessageCell class] forCellReuseIdentifier:@"youtubevideoMessageCell"];
    
    [self.sendMessageButton addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
    [self.attachmentButton addTarget:self action:@selector(showAttachments:) forControlEvents:UIControlEventTouchUpInside];
    [self.clearAttachmentButton addTarget:self action:@selector(clearAttachment:) forControlEvents:UIControlEventTouchUpInside];
    
    self.messageInput.placeholder = self.messageInput.text;
    self.messageInput.placeholderColor = [UIColor grayColor];
    self.messageInput.text = @"";
    
    self.firstLoad = YES;
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
    
    if ([message.googleImageId isEqualToString:@""] && [message.youtubeVideoId isEqualToString:@""]) {
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
        
        cell.messageBody.frame = CGRectMake(cell.messageBody.frame.origin.x, cell.messageBody.frame.origin.y, cell.messageBody.frame.size.width, cell.messageBody.contentSize.height);
        
        return cell;
    } else if (![message.googleImageId isEqualToString:@""]) {
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
        
        cell.messageBody.frame = CGRectMake(cell.messageBody.frame.origin.x, cell.messageBody.frame.origin.y, cell.messageBody.frame.size.width, cell.messageBody.contentSize.height);
        
        [cell.googleImage hnk_setImageFromURL:[NSURL URLWithString:message.googleImageId]];
        
        return cell;
    } else {
        CMYoutubeVideoMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"youtubevideoMessageCell" forIndexPath:indexPath];
        
        [cell.userImage hnk_setImageFromURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=150&height=150", message.userId]]];
        
        if (![message.userId isEqualToString:[[FBSDKAccessToken currentAccessToken] userID]]) {
            Contact *contact = [Contact MR_findFirstByAttribute:@"contactId" withValue:message.userId inContext:[NSManagedObjectContext MR_defaultContext]];
            cell.userName.text = contact.name;
        } else {
            cell.userName.text = @"From You";
        }
        cell.timestamp.text = [message.timestamp timeAgoSinceNow];
        
        cell.messageBody.text = message.body;
        
        cell.messageBody.frame = CGRectMake(cell.messageBody.frame.origin.x, cell.messageBody.frame.origin.y, cell.messageBody.frame.size.width, cell.messageBody.contentSize.height);
        
        cell.thumbnail.image = [UIImage imageNamed:@"Icon"];
        cell.videoId = message.youtubeVideoId;
        
        cell.viewController = self;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
            
            NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"keys" ofType:@"plist"];
            
            [manager GET:[NSString stringWithFormat:@"https://www.googleapis.com/youtube/v3/videos?part=snippet&maxResults=1&id=%@&key=%@", message.youtubeVideoId, [NSDictionary dictionaryWithContentsOfFile:plistPath][@"YOUTUBE_KEY"]]
              parameters:@{}
                 success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                     NSDictionary *video = responseObject[@"items"][0][@"snippet"];
                     
                     cell.title.text = video[@"title"];
                     cell.channel.text = video[@"channelTitle"];
                     
                     [cell.thumbnail hnk_setImageFromURL:[NSURL URLWithString:video[@"thumbnails"][@"medium"][@"url"]]];
                 }
                 failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
                     
                 }];
        });
        
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
        if (![message.googleImageId isEqualToString:@""]) {
            return cellDefaultHeight + tv.contentSize.height + 240;
        } else if (![message.youtubeVideoId isEqualToString:@""]) {
            return cellDefaultHeight + tv.contentSize.height + 150;
        } else {
            return cellDefaultHeight + tv.contentSize.height;
        }
    } else {
        if (![message.googleImageId isEqualToString:@""]) {
            return cellDefaultHeight + 240;
        } else if (![message.youtubeVideoId isEqualToString:@""]) {
            return cellDefaultHeight + 150;
        } else {
            return cellDefaultHeight;
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
                                
                                if (self.firstLoad) {
                                    self.firstLoad = NO;
                                    
                                    // Scroll to bottom of messages table
                                    if (self.messages.count > 0) {
                                        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:self.messages.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                                    }
                                }
                            });
                        }
                    }];
                }
            }
        }
    }];
}

- (void)sendMessage:(id)sender {
    if (![[self.messageInput.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        if (self.gImageResult != nil) {
            [self.request requestWithHttpVerb:@"POST" url:[NSString stringWithFormat:@"/chat/%@", self.chat.chatId] data:@{@"text": self.messageInput.text, @"youtubeVideoId": @"", @"googleImageId": self.gImageResult.url} jwt:self.user.jwt response:^(NSError *error, NSDictionary *response) {
                if (!error) {
                    UIImageView *iv = ((UIImageView *)self.view.subviews[1].subviews[0]);
                    iv.image = nil;
                    self.gImageResult = nil;
                    
                    self.view.subviews[1].userInteractionEnabled = NO;
                    iv.userInteractionEnabled = NO;
                    
                    [self resetMessageInput];
                    [self fetchMessages:self];
                }
            }];
        }
        
        if (self.videoResult != nil) {
            [self.request requestWithHttpVerb:@"POST" url:[NSString stringWithFormat:@"/chat/%@", self.chat.chatId] data:@{@"text": self.messageInput.text, @"youtubeVideoId": self.videoResult.videoId, @"googleImageId": @""} jwt:self.user.jwt response:^(NSError *error, NSDictionary *response) {
                if (!error) {
                    UIImageView *iv = ((UIImageView *)self.view.subviews[1].subviews[0]);
                    iv.image = nil;
                    self.videoResult = nil;
                    
                    self.view.subviews[1].userInteractionEnabled = NO;
                    iv.userInteractionEnabled = NO;
                    
                    [self resetMessageInput];
                    [self fetchMessages:self];
                }
            }];
        }
        
        if (self.gImageResult == nil && self.videoResult == nil) {
            [self.request requestWithHttpVerb:@"POST" url:[NSString stringWithFormat:@"/chat/%@", self.chat.chatId] data:@{@"text": self.messageInput.text, @"youtubeVideoId": @"", @"googleImageId": @""} jwt:self.user.jwt response:^(NSError *error, NSDictionary *response) {
                if (!error) {
                    [self resetMessageInput];
                    [self fetchMessages:self];
                }
            }];
        }
    }
}

- (void)showAttachments:(UIImageView *)sender {
    UIAlertController *attachmentsSheet = [UIAlertController alertControllerWithTitle:@"Choose Attachment" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [attachmentsSheet addAction:[UIAlertAction actionWithTitle:@"Google Images" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        CMGImageSearch *pop = [[CMGImageSearch alloc] init];
        pop.delegate = self;
        [pop show];
    }]];
    
    [attachmentsSheet addAction:[UIAlertAction actionWithTitle:@"Youtube" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        CMYoutubeSearch *pop = [[CMYoutubeSearch alloc] init];
        pop.delegate = self;
        [pop show];
    }]];
    
    [attachmentsSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    
    attachmentsSheet.modalPresentationStyle = UIModalPresentationPopover;
    
    UIPopoverPresentationController * popover = attachmentsSheet.popoverPresentationController;
    popover.permittedArrowDirections = UIPopoverArrowDirectionUp;
    popover.sourceView = sender;
    popover.sourceRect = sender.bounds;
    
    [self presentViewController:attachmentsSheet animated:YES completion:nil];
}

- (void)imageSelected:(CMGImageResult *)result {
    UIImageView *iv = ((UIImageView *)self.view.subviews[1].subviews[0]);
    iv.image = result.image;

    
    self.view.subviews[1].userInteractionEnabled = YES;
    iv.userInteractionEnabled = YES;
    
    self.gImageResult = result;
    
    [self toggleAttachmentAction];
}

- (void)videoSelected:(CMYoutubeSearchResult *)result {
    UIImageView *iv = ((UIImageView *)self.view.subviews[1].subviews[0]);
    iv.image = result.highThumbnail;
    
    self.view.subviews[1].userInteractionEnabled = YES;
    iv.userInteractionEnabled = YES;
    
    self.videoResult = result;
    
    [self toggleAttachmentAction];
}

- (void)clearAttachment:(id)sender {
    UIImageView *iv = ((UIImageView *)self.view.subviews[1].subviews[0]);
    iv.image = nil;
    
    self.view.subviews[1].userInteractionEnabled = NO;
    iv.userInteractionEnabled = NO;
    
    self.videoResult = nil;
    self.gImageResult = nil;
    
    [self toggleAttachmentAction];
}

- (void)toggleAttachmentAction {
    BOOL isAttach = !self.attachmentButton.hidden;
    
    self.attachmentButton.hidden = isAttach;
    self.attachmentButton.userInteractionEnabled = !isAttach;
    
    self.clearAttachmentButton.hidden = !isAttach;
    self.clearAttachmentButton.userInteractionEnabled = isAttach;
}

- (void)resetMessageInput {
    self.messageInput.placeholder = @"Enter your message here";
    self.messageInput.text = @"";
}

@end
