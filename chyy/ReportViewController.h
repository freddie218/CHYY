//
//  ReportViewController.h
//  chyy
//
//  Created by huan on 2/23/14.
//  Copyright (c) 2014 huan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"
#import "Expense.h"
#import "Member.h"
#import "ExpenseViewController.h"

@interface ReportViewController : UITableViewController

@property (strong) NSMutableArray *reports;
@property (strong) NSMutableArray *expenses;

@property (strong) Event *event;

- (IBAction)resolve:(id)sender;

@end
