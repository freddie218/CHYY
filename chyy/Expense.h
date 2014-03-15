//
//  Expense.h
//  chyy
//
//  Created by huan on 3/2/14.
//  Copyright (c) 2014 huan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Expense : NSManagedObject

@property (nonatomic, retain) NSNumber * amount;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * memo;
@property (nonatomic, retain) NSString * participant;
@property (nonatomic, retain) NSString * payer;
@property (nonatomic, retain) NSString * reason;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSDate * time;
@property (nonatomic, retain) NSManagedObject *expensetoevent;

@end
