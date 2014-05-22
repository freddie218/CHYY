//
//  ExpenseViewController.h
//  chyy
//
//  Created by huan on 6/12/13.
//  Copyright (c) 2013 huan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"
#import "Expense.h"

@interface ExpenseViewController : UITableViewController

@property (strong) NSMutableArray *expenses;
@property (strong) NSMutableArray *settledExpenses;

@property (strong) Event *event;

@property (strong, nonatomic) IBOutlet UIButton *reportButton;

@end
