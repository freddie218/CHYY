//
//  Member.h
//  chyy
//
//  Created by Huan Wang on 3/28/14.
//  Copyright (c) 2014 huan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Member : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * sex;
@property (nonatomic, retain) NSData * avatar;

@end
