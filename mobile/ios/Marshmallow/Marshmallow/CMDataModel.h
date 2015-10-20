//
//  CMDataModel.h
//  Marshmallow
//
//  Created by Brandon Borders on 10/20/15.
//  Copyright © 2015 Cantilevered Marshmallow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/objc-runtime.h>

#import "CMDataAccessor.h"

@interface CMDataModel : NSObject

@property CMDataAccessor *accessor;

@property NSManagedObject *dataObject;

- (id)initWithEntityName:(NSString *)entityName;

- (BOOL)saveObject;

- (void)populatePropertiesAtColumn:(NSString *)column withValue:(id)value;

@end
