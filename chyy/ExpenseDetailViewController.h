//
//  ExpenseDetailViewController.h
//  chyy
//
//  Created by huan on 6/12/13.
//  Copyright (c) 2013 huan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExpenseDetailViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *payerTextField;
@property (strong, nonatomic) IBOutlet UITextField *amountTextField;
@property (strong, nonatomic) IBOutlet UITextField *reasonTextField;
@property (strong, nonatomic) IBOutlet UITextField *locationTextField;
@property (strong, nonatomic) IBOutlet UITextField *timeTextField;
@property (strong, nonatomic) IBOutlet UITextField *memoTextField;

- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;


@end
