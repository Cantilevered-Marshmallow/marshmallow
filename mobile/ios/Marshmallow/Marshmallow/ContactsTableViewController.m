//
//  ContactsTableViewController.m
//  Marshmallow
//
//  Created by Brandon Borders on 10/20/15.
//  Copyright © 2015 Cantilevered Marshmallow. All rights reserved.
//

#import "ContactsTableViewController.h"

@implementation ContactsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _accessor = [[CMDataAccessor alloc] init];
    _contacts = [[NSMutableArray alloc] init];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Contact" inManagedObjectContext:self.accessor.managedObjectContext];
    [request setEntity:entity];
    
    NSError *error;
    NSArray *result = [self.accessor.managedObjectContext executeFetchRequest:request error:&error];
    
    for (NSManagedObject *resultItem in result) {
        [self.contacts addObject:[[Contact alloc] initWithObject:resultItem]];
    }
    
    [self.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"contactCell"];
    
    Contact *contact = self.contacts[indexPath.row];
    
    NSArray *subviews = [cell subviews];
    // Ewww, why so many nested statements?
    // Because the API forced me
    for (UIView *view in subviews) {
        if ([[[view class] description] isEqualToString:@"UITableViewCellContentView"]) {
            for (UIView *subview in [view subviews]) {
                if ([[[subview class] description] isEqualToString:@"CMRemoteImageView"]) {
                    CMRemoteImageView *iv = ((CMRemoteImageView *)subview);
                    if (!contact.profileImage) {
                        [iv setRemoteUrl:[NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=150&height=150", contact.contactId]
                                                                  ]];
                        [NSTimer scheduledTimerWithTimeInterval:5.0
                                                         target:self
                                                       selector:@selector(saveContactImage:)
                                                       userInfo:@{@"iv": iv, @"contact": contact}
                                                        repeats:NO];
                    } else {
                        iv.image = [UIImage imageWithData:contact.profileImage];
                    }
                }
                
                if ([[[subview class] description] isEqualToString:@"UILabel"]) {
                    UILabel *label = ((UILabel *)subview);
                    
                    if ([[label text] isEqualToString:@"John Appleseed"]) {
                        label.text = contact.name;
                    }
                }
            }
        }
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.contacts count];
}

- (void)saveContactImage:(NSTimer *)timer {
    CMRemoteImageView *iv = (CMRemoteImageView *)timer.userInfo[@"iv"];
    Contact *contact = (Contact *)timer.userInfo[@"contact"];
    [contact setValue:UIImagePNGRepresentation(iv.image) forKey:@"attrProfileImage"];
    [contact saveObject];
}

@end
