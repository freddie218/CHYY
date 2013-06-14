//
//  ExpenseDetailViewController.h
//  chyy
//
//  Created by huan on 6/12/13.
//  Copyright (c) 2013 huan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExpenseDetailViewController : UIViewController <UITextFieldDelegate>

@property (strong) NSManagedObject *expense;

@property (strong, nonatomic) IBOutlet UITextField *payerTextField;
@property (strong, nonatomic) IBOutlet UITextField *amountTextField;
@property (strong, nonatomic) IBOutlet UITextField *reasonTextField;
@property (strong, nonatomic) IBOutlet UITextField *locationTextField;
@property (strong, nonatomic) IBOutlet UITextField *timeTextField;
@property (strong, nonatomic) IBOutlet UITextField *memoTextField;
@property (strong, nonatomic) IBOutlet UITextField *participantTextField;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;

@end
