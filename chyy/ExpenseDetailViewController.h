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
#import "Member.h"
#import "ExpenseCollectionViewCell.h"
#import "MemberCollectionViewController.h"

@interface ExpenseDetailViewController : UIViewController <UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) NSMutableArray *members;
@property (strong, nonatomic) NSMutableSet *participantSet;

@property (strong, nonatomic) NSMutableArray *categories;
@property (strong, nonatomic) NSMutableArray *subCategories;

@property (strong) Expense *expense;
@property (strong) Event *event;
@property (strong) Member *selectedMember;

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
