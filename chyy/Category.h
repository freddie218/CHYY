//
//  Category.h
//  chyy
//
//  Created by huan on 3/7/14.
//  Copyright (c) 2014 huan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Category;

@interface Category : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *childcategories;
@end

@interface Category (CoreDataGeneratedAccessors)

- (void)addChildcategoriesObject:(Category *)value;
- (void)removeChildcategoriesObject:(Category *)value;
- (void)addChildcategories:(NSSet *)values;
- (void)removeChildcategories:(NSSet *)values;

@end
