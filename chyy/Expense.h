//
//  Expense.h
//  chyy
//
//  Created by Huan Wang on 4/28/14.
//  Copyright (c) 2014 huan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event, Member;

@interface Expense : NSManagedObject

@property (nonatomic, retain) NSNumber * amount;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * memo;
@property (nonatomic, retain) NSString * participant;
@property (nonatomic, retain) NSString * payer;
@property (nonatomic, retain) NSString * reason;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSDate * time;
@property (nonatomic, retain) Event *expensetoevent;
@property (nonatomic, retain) Member *payermember;
@property (nonatomic, retain) NSSet *participantmembers;
@end

@interface Expense (CoreDataGeneratedAccessors)

- (void)addParticipantmembersObject:(Member *)value;
- (void)removeParticipantmembersObject:(Member *)value;
- (void)addParticipantmembers:(NSSet *)values;
- (void)removeParticipantmembers:(NSSet *)values;

@end
