//
//  Event.h
//  chyy
//
//  Created by huan on 3/2/14.
//  Copyright (c) 2014 huan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Expense;

@interface Event : NSManagedObject

@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *eventexpenses;
@end

@interface Event (CoreDataGeneratedAccessors)

- (void)addEventexpensesObject:(Expense *)value;
- (void)removeEventexpensesObject:(Expense *)value;
- (void)addEventexpenses:(NSSet *)values;
- (void)removeEventexpenses:(NSSet *)values;

@end
