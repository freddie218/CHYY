//
//  Member.h
//  chyy
//
//  Created by Huan Wang on 5/23/14.
//  Copyright (c) 2014 huan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event, Expense;

@interface Member : NSManagedObject

@property (nonatomic, retain) NSData * avatar;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * sex;
@property (nonatomic, retain) NSSet *membertoevent;
@property (nonatomic, retain) NSSet *participanttoexpense;
@property (nonatomic, retain) NSSet *payertoexpense;
@end

@interface Member (CoreDataGeneratedAccessors)

- (void)addMembertoeventObject:(Event *)value;
- (void)removeMembertoeventObject:(Event *)value;
- (void)addMembertoevent:(NSSet *)values;
- (void)removeMembertoevent:(NSSet *)values;

- (void)addParticipanttoexpenseObject:(Expense *)value;
- (void)removeParticipanttoexpenseObject:(Expense *)value;
- (void)addParticipanttoexpense:(NSSet *)values;
- (void)removeParticipanttoexpense:(NSSet *)values;

- (void)addPayertoexpenseObject:(Expense *)value;
- (void)removePayertoexpenseObject:(Expense *)value;
- (void)addPayertoexpense:(NSSet *)values;
- (void)removePayertoexpense:(NSSet *)values;

@end
