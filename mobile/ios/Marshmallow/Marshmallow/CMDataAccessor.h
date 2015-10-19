//
//  CMDataAccessor.h
//  Marshmallow
//
//  Created by Brandon Borders on 10/19/15.
//  Copyright © 2015 Cantilevered Marshmallow. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>

@interface CMDataAccessor : NSObject

#pragma mark - core data

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

- (NSEntityDescription *)getEntityForName:(NSString *)entityName;
- (NSArray *)fetchRowsForColumn:(NSString *)columnName withValue:(id)aValue anEntityName:(NSString *)entityName;
- (NSManagedObject *)createObjectForEntityName:(NSString *)entityName;
- (BOOL)saveObject:(NSManagedObject *)aObject;

@end
