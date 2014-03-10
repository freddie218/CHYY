//
//  ExpenseDetailViewController.h
//  chyy
//
//  Created by huan on 6/12/13.
//  Copyright (c) 2013 huan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"
#import "Expense.h"

@interface ExpenseDetailViewController : UIViewController <UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) NSMutableArray *members;
@property (strong, nonatomic) NSMutableArray *categories;

@property (strong) Expense *expense;
@property (strong) Event *event;

@property (strong, nonatomic) IBOutlet UITextField *payerTextField;
@property (strong, nonatomic) IBOutlet UITextField *amountTextField;
@property (strong, nonatomic) IBOutlet UITextField *reasonTextField;
@property (strong, nonatomic) IBOutlet UITextField *locationTextField;
@property (strong, nonatomic) IBOutlet UITextField *timeTextField;
@property (strong, nonatomic) IBOutlet UITextField *memoTextField;
@property (strong, nonatomic) IBOutlet UITextField *participantTextField;

@property (strong, nonatomic) IBOutlet UITextField *currentTextField;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;

@end
