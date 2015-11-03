//
//  ChatViewController.m
//  Marshmallow
//
//  Created by Brandon Borders on 10/16/15.
//  Copyright © 2015 Cantilevered Marshmallow. All rights reserved.
//

#import "ChatViewController.h"

@implementation ChatViewController

#pragma mark - controller life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Initialize message input
    _messageInput.layer.borderColor = [[UIColor grayColor] CGColor];
    _messageInput.layer.borderWidth = 0.25;
    _messageInput.layer.cornerRadius = 5;
    
    self.messageInput.placeholder = self.messageInput.text;
    self.messageInput.placeholderColor = [UIColor grayColor];
    self.messageInput.text = @"";
    
    [self.messageInput becomeFirstResponder];
    
    // Initialize HTTP helper
    _request = [[CMNetworkRequest alloc] init];
    
    // Add a border to divide the message controls from the messages table
    CALayer *upperBorder = [CALayer layer];
    upperBorder.backgroundColor = [[UIColor grayColor] CGColor];
    upperBorder.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 0.5f);
    [_chatControls.layer addSublayer:upperBorder];
    
    // Set the title of the view to the title of the chat room
    [self.navigationItem setTitle:self.chat.chatTitle];
    
    // Retrieve all the messages to display sorted by their timestamp
    self.messages = [NSMutableArray arrayWithArray:[Message MR_findAllSortedBy:@"timestamp:YES" ascending:YES withPredicate:[NSPredicate predicateWithFormat:@"chatsId == %@", self.chat.chatId] inContext:[NSManagedObjectContext MR_defaultContext]]];
    
    // Set interval for fetching of new messages
    self.fetchMessagesTimer = [NSTimer scheduledTimerWithTimeInterval:2.5 target:self selector:@selector(fetchMessages:) userInfo:nil repeats:YES];
    
    // Register message cells for use later
    [self.tableView registerClass:[CMMessageCell class] forCellReuseIdentifier:@"messageCell"];
    [self.tableView registerClass:[CMGImageMessageCell class] forCellReuseIdentifier:@"gImageMessageCell"];
    [self.tableView registerClass:[CMYoutubeVideoMessageCell class] forCellReuseIdentifier:@"youtubevideoMessageCell"];
    
    // Bind the message control buttons
    [self.sendMessageButton addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
    [self.attachmentButton addTarget:self action:@selector(showAttachments:) forControlEvents:UIControlEventTouchUpInside];
    [self.clearAttachmentButton addTarget:self action:@selector(clearAttachment:) forControlEvents:UIControlEventTouchUpInside];
    self.trendsButton.target = self;
    self.trendsButton.action = @selector(trendsClicked:);
    
    // Set flag for detecting if we just opened the view
    self.firstLoad = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // Check to see if we don't have timer already; Prevents the same action from being performed twice
    if (!self.fetchMessagesTimer) {
        self.fetchMessagesTimer = [NSTimer scheduledTimerWithTimeInterval:2.5 target:self selector:@selector(fetchMessages:) userInfo:nil repeats:true];
    }
    
    // Scroll to bottom of messages table
    if (self.messages.count > 0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:self.messages.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // Stop the timer
    [self.fetchMessagesTimer invalidate];
    self.fetchMessagesTimer = nil;
}

#pragma mark - table view handlers

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Message *message = self.messages[indexPath.row];
    
    // Default message cell
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
                    
        cell.messageBody.text = [ZWEmoji emojify:message.body];
        
        CGFloat fixedWidth = cell.messageBody.frame.size.width;
        CGSize newSize = [cell.messageBody sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
        CGRect newFrame = cell.messageBody.frame;
        newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
        cell.messageBody.frame = newFrame;
        
        return cell;
        
    // Google Image message cell
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
        
        cell.messageBody.text = [ZWEmoji emojify:message.body];
        
        CGFloat fixedWidth = cell.messageBody.frame.size.width;
        CGSize newSize = [cell.messageBody sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
        CGRect newFrame = cell.messageBody.frame;
        newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
        cell.messageBody.frame = newFrame;
        
        [cell.googleImage hnk_setImageFromURL:[NSURL URLWithString:message.googleImageId]];
        
        return cell;
        
    // Youtube video message cell
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
        
        cell.messageBody.text = [ZWEmoji emojify:message.body];
        
        CGFloat fixedWidth = cell.messageBody.frame.size.width;
        CGSize newSize = [cell.messageBody sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
        CGRect newFrame = cell.messageBody.frame;
        newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
        cell.messageBody.frame = newFrame;
        
        // Set placeholder for thumbnail
        cell.thumbnail.image = [UIImage imageNamed:@"Icon"];
        cell.videoId = message.youtubeVideoId;
        
        cell.viewController = self;
        
        // In order to get the metadata for the video we need to send an API call to Youtube
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
    
    int cellDefaultHeight = 120;
    
    // The message body is larger than the default height of the text view
    if (tv.contentSize.height > tv.frame.size.height) {
        if (![message.googleImageId isEqualToString:@""]) {
            return cellDefaultHeight + tv.contentSize.height + 240;
        } else if (![message.youtubeVideoId isEqualToString:@""]) {
            return cellDefaultHeight + tv.contentSize.height + 150;
        } else {
            return cellDefaultHeight + tv.contentSize.height;
        }
    
    // The message is shorter or equal to the height of the text view
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

#pragma mark - Handlers

- (void)fetchMessages:(id)sender {
    // Fetch all the new messages
    [self.request requestWithHttpVerb:@"GET" url:[NSString stringWithFormat:@"/chat/%@", self.chat.chatId] data:nil jwt:self.user.jwt response:^(NSError *error, NSDictionary *response) {
        if (!error) {
            NSArray *fetchedMessages = response[@"messages"];
            
            for (NSDictionary *fetchedMessage in fetchedMessages) {
                // Does the message already exist locally?
                if (![Message MR_findFirstByAttribute:@"timestamp" withValue:[NSDate dateWithISO8601String:fetchedMessage[@"createdAt"]] inContext:[NSManagedObjectContext MR_defaultContext]]) {
                    // Save the message locally
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
                                // Reload the table to display the new messages
                                self.messages = [NSMutableArray arrayWithArray:[Message MR_findAllSortedBy:@"timestamp:YES" ascending:YES withPredicate:[NSPredicate predicateWithFormat:@"chatsId == %@", self.chat.chatId] inContext:[NSManagedObjectContext MR_defaultContext]]];
                                
                                [self.tableView reloadData];
                                
                                // Scroll to bottom of messages if the previous newest message is visible
                                NSArray<NSIndexPath *> *visibleRows = [self.tableView indexPathsForVisibleRows];
                                for (NSIndexPath *indexPath in visibleRows) {
                                    if (indexPath.row == self.messages.count - 1) {
                                        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:self.messages.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                                    }
                                }
                                
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
    // Is the message more than just whitespace?
    if (![[self.messageInput.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        NSLog(@"Pass");
        // Message has a Google Image attachment
        if (self.gImageResult != nil) {
            [self.request requestWithHttpVerb:@"POST" url:[NSString stringWithFormat:@"/chat/%@", self.chat.chatId] data:@{@"text": [ZWEmoji unemojify:self.messageInput.text], @"youtubeVideoId": @"", @"googleImageId": self.gImageResult.url} jwt:self.user.jwt response:^(NSError *error, NSDictionary *response) {
                if (!error) {
                    UIImageView *iv = ((UIImageView *)self.view.subviews[1].subviews[0]);
                    iv.image = nil;
                    self.gImageResult = nil;
                    
                    self.view.subviews[1].userInteractionEnabled = NO;
                    iv.userInteractionEnabled = NO;
                    
                    [self resetMessageInput];
                    [self fetchMessages:self];
                    
                    BOOL isAttach = !self.attachmentButton.hidden;
                    if (!isAttach) {
                        [self toggleAttachmentAction];
                    }
                }
            }];
        }
        
        // Message has a Youtube video attachment
        if (self.videoResult != nil) {
            [self.request requestWithHttpVerb:@"POST" url:[NSString stringWithFormat:@"/chat/%@", self.chat.chatId] data:@{@"text": [ZWEmoji unemojify:self.messageInput.text], @"youtubeVideoId": self.videoResult.videoId, @"googleImageId": @""} jwt:self.user.jwt response:^(NSError *error, NSDictionary *response) {
                if (!error) {
                    UIImageView *iv = ((UIImageView *)self.view.subviews[1].subviews[0]);
                    iv.image = nil;
                    self.videoResult = nil;
                    
                    self.view.subviews[1].userInteractionEnabled = NO;
                    iv.userInteractionEnabled = NO;
                    
                    [self resetMessageInput];
                    [self fetchMessages:self];
                    
                    BOOL isAttach = !self.attachmentButton.hidden;
                    if (!isAttach) {
                        [self toggleAttachmentAction];
                    }
                }
            }];
        }
        
        if (self.trendResult != nil) {
            [self.request requestWithHttpVerb:@"POST" url:[NSString stringWithFormat:@"/chat/%@", self.chat.chatId] data:@{@"text": [ZWEmoji unemojify:self.messageInput.text], @"youtubeVideoId": @"", @"googleImageId": @"", @"redditAttachment": self.trendResult} jwt:self.user.jwt response:^(NSError *error, NSDictionary *response) {
                if (!error) {
                    UIImageView *iv = ((UIImageView *)self.view.subviews[1].subviews[0]);
                    iv.image = nil;
                    self.videoResult = nil;
                    
                    self.view.subviews[1].userInteractionEnabled = NO;
                    iv.userInteractionEnabled = NO;
                    
                    [self resetMessageInput];
                    [self fetchMessages:self];
                    
                    BOOL isAttach = !self.attachmentButton.hidden;
                    if (!isAttach) {
                        [self toggleAttachmentAction];
                    }
                }
            }];
        }
        
        // Default message
        if (self.gImageResult == nil && self.videoResult == nil && self.trendResult == nil) {
            [self.request requestWithHttpVerb:@"POST" url:[NSString stringWithFormat:@"/chat/%@", self.chat.chatId] data:@{@"text": [ZWEmoji unemojify:self.messageInput.text], @"youtubeVideoId": @"", @"googleImageId": @""} jwt:self.user.jwt response:^(NSError *error, NSDictionary *response) {
                if (!error) {
                    NSLog(@"Response");
                    [self resetMessageInput];
                    [self fetchMessages:self];
                    
                    BOOL isAttach = !self.attachmentButton.hidden;
                    if (!isAttach) {
                        [self toggleAttachmentAction];
                    }
                } else {
                    NSLog(@"Error: %@", error);
                }
            }];
        }
    }
}

- (void)trendsClicked:(id)sender {
    CMTrendsPopup *pop = [[CMTrendsPopup alloc] initWithJwt:self.user.jwt];
    pop.delegate = self;
    
    [pop show];
}

#pragma mark - Handle attachments

- (void)imageSelected:(CMGImageResult *)result {
    // A Google Image has been selected
    
    // Set the preview to the selected image
    UIImageView *iv = ((UIImageView *)self.view.subviews[1].subviews[0]);
    iv.image = result.image;

    // Prevent user from interacting with messages table when tapping the preview
    self.view.subviews[1].userInteractionEnabled = YES;
    iv.userInteractionEnabled = YES;
    
    self.gImageResult = result;
    
    // Toggle the attachment action button
    [self toggleAttachmentAction];
}

- (void)videoSelected:(CMYoutubeSearchResult *)result {
    // A Youtube video was selected
    
    // Set the preview to the thumbnail of the video
    UIImageView *iv = ((UIImageView *)self.view.subviews[1].subviews[0]);
    iv.image = result.highThumbnail;
    
    // Prevent user from interacting with messages table when tapping the preview
    self.view.subviews[1].userInteractionEnabled = YES;
    iv.userInteractionEnabled = YES;
    
    self.videoResult = result;
    
    // Toggle the attachment action
    [self toggleAttachmentAction];
}

- (void)trendSelected:(NSDictionary *)trend {
    // A trend was selected
    
    // Set the preview to the thumbnail of the video
    UIImageView *iv = ((UIImageView *)self.view.subviews[1].subviews[0]);
    [iv hnk_setImageFromURL:[NSURL URLWithString:trend[@"thumbnail"]]];
    
    // Prevent user from interacting with messages table when tapping the preview
    self.view.subviews[1].userInteractionEnabled = YES;
    iv.userInteractionEnabled = YES;
    
    self.trendResult = trend;
    
    // Toggle the attachment action
    [self toggleAttachmentAction];
}

- (void)displayTrend:(SFSafariViewController *)safariController {
    [self presentViewController:safariController animated:YES completion:nil];
}

#pragma mark - Helpers

- (void)clearAttachment:(id)sender {
    // Remove the preview for the attachment
    UIImageView *iv = ((UIImageView *)self.view.subviews[1].subviews[0]);
    iv.image = nil;
    
    // Allow user to interact with the messages table in the area of the preview
    self.view.subviews[1].userInteractionEnabled = NO;
    iv.userInteractionEnabled = NO;
    
    self.videoResult = nil;
    self.gImageResult = nil;
    
    // Toggle the attachment option
    [self toggleAttachmentAction];
}

- (void)toggleAttachmentAction {
    // Who doesn't like binary?
    BOOL isAttach = !self.attachmentButton.hidden;
    
    self.attachmentButton.hidden = isAttach;
    self.attachmentButton.userInteractionEnabled = !isAttach;
    
    self.clearAttachmentButton.hidden = !isAttach;
    self.clearAttachmentButton.userInteractionEnabled = isAttach;
    // Anyone?
}

- (void)resetMessageInput {
    self.messageInput.placeholder = @"Enter your message here";
    self.messageInput.text = @"";
}

- (void)showAttachments:(UIImageView *)sender {
    // Action handler for click on attachment button
    
    // Create the popup sheet for displaying options on which attachment to use
    UIAlertController *attachmentsSheet = [UIAlertController alertControllerWithTitle:@"Choose Attachment" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    // Google Image search option
    [attachmentsSheet addAction:[UIAlertAction actionWithTitle:@"Google Images" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        CMGImageSearch *pop = [[CMGImageSearch alloc] init];
        pop.delegate = self;
        [pop show];
    }]];
    
    // Youtube video option
    [attachmentsSheet addAction:[UIAlertAction actionWithTitle:@"Youtube" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        CMYoutubeSearch *pop = [[CMYoutubeSearch alloc] init];
        pop.delegate = self;
        [pop show];
    }]];
    
    // Cancel option
    [attachmentsSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    
    // Style the sheet
    attachmentsSheet.modalPresentationStyle = UIModalPresentationPopover;
    
    UIPopoverPresentationController * popover = attachmentsSheet.popoverPresentationController;
    popover.permittedArrowDirections = UIPopoverArrowDirectionUp;
    popover.sourceView = sender;
    popover.sourceRect = sender.bounds;
    
    // Display the sheet
    [self presentViewController:attachmentsSheet animated:YES completion:nil];
}


@end
