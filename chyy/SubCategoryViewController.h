//
//  SubCategoryViewController.h
//  chyy
//
//  Created by huan on 3/10/14.
//  Copyright (c) 2014 huan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubCategoryDetailViewController.h"
#import "Category.h"

@interface SubCategoryViewController : UITableViewController

@property (strong) Category *parentCategory;

@property (strong) NSMutableArray *subCategories;

@end
