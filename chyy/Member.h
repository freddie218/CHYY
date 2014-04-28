//
//  Member.h
//  chyy
//
//  Created by Huan Wang on 4/28/14.
//  Copyright (c) 2014 huan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event, Expense;

@interface Member : NSManagedObject

@property (nonatomic, retain) NSData * avatar;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * sex;
@property (nonatomic, retain) Event *membertoevent;
@property (nonatomic, retain) Expense *payertoexpense;
@property (nonatomic, retain) Expense *participanttoexpense;

@end
